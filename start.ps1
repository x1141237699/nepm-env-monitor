#Requires -Version 5.1
<#
.SYNOPSIS
  东软环保公众监督系统 - 一键启动前后端
.USAGE
  powershell -ExecutionPolicy Bypass -File .\start.ps1
  或双击 start.bat
#>

$ErrorActionPreference = "Stop"
$Root = $PSScriptRoot
$BackApiDir = Join-Path $Root "back-api"
$NepmDir = Join-Path $Root "nepm"
$PidFile = Join-Path $Root ".run\pids.json"

function Write-Info($msg) { Write-Host "[INFO] $msg" -ForegroundColor Cyan }
function Write-Ok($msg) { Write-Host "[OK]   $msg" -ForegroundColor Green }
function Write-Warn($msg) { Write-Host "[WARN] $msg" -ForegroundColor Yellow }

function Test-CommandExists($name) {
  return $null -ne (Get-Command $name -ErrorAction SilentlyContinue)
}

function Find-Maven {
  if (Test-CommandExists "mvn") {
    return (Get-Command "mvn").Source
  }
  $patterns = @(
    "$env:USERPROFILE\.m2\wrapper\dists\apache-maven-*\*\apache-maven-*\bin\mvn.cmd",
    "$env:USERPROFILE\.m2\wrapper\dists\apache-maven-*\apache-maven-*\bin\mvn.cmd"
  )
  foreach ($pattern in $patterns) {
    $found = Get-ChildItem -Path $pattern -ErrorAction SilentlyContinue | Sort-Object FullName -Descending | Select-Object -First 1
    if ($found) { return $found.FullName }
  }
  return $null
}

function Test-PortListening($port) {
  return [bool](Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction SilentlyContinue)
}

function Wait-ForUrl($url, $timeoutSec = 120) {
  $deadline = (Get-Date).AddSeconds($timeoutSec)
  while ((Get-Date) -lt $deadline) {
    try {
      $resp = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 3
      if ($resp.StatusCode -ge 200 -and $resp.StatusCode -lt 500) { return $true }
    } catch {}
    Start-Sleep -Seconds 2
  }
  return $false
}

function Save-Pids($backendPid, $frontendPid) {
  $dir = Split-Path $PidFile -Parent
  if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir | Out-Null }
  @{
    backendPid = $backendPid
    frontendPid = $frontendPid
    startedAt = (Get-Date).ToString("o")
  } | ConvertTo-Json | Set-Content -Path $PidFile -Encoding UTF8
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Magenta
Write-Host " 东软环保公众监督系统 - 一键启动" -ForegroundColor Magenta
Write-Host "========================================" -ForegroundColor Magenta
Write-Host ""

# 环境检查
$missing = @()
if (-not (Test-CommandExists "java")) { $missing += "JDK 8+（java 命令）" }
if (-not (Test-CommandExists "node")) { $missing += "Node.js 18+（node 命令）" }
if (-not (Test-CommandExists "npm")) { $missing += "npm（随 Node.js 安装）" }
$mvn = Find-Maven
if (-not $mvn) { $missing += "Maven 3.6+（mvn 命令）" }

if ($missing.Count -gt 0) {
  Write-Warn "缺少以下环境，请先安装："
  $missing | ForEach-Object { Write-Host "  - $_" -ForegroundColor Yellow }
  exit 1
}

if (Test-PortListening 8080) {
  Write-Warn "端口 8080 已被占用，请先运行 stop.ps1 或手动结束进程"
  exit 1
}
if (Test-PortListening 5173) {
  Write-Warn "端口 5173 已被占用，请先运行 stop.ps1 或手动结束进程"
  exit 1
}

# 前端依赖
if (-not (Test-Path (Join-Path $NepmDir "node_modules"))) {
  Write-Info "首次运行，正在安装前端依赖 (npm install)..."
  Push-Location $NepmDir
  npm install
  if ($LASTEXITCODE -ne 0) { Pop-Location; throw "npm install 失败" }
  Pop-Location
  Write-Ok "前端依赖安装完成"
}

# 启动后端
Write-Info "正在启动后端 (8080)..."
$backendProc = Start-Process -FilePath $mvn -ArgumentList "spring-boot:run" -WorkingDirectory $BackApiDir -PassThru -WindowStyle Minimized
Write-Ok "后端进程已启动 (PID $($backendProc.Id))"

Write-Info "等待后端就绪..."
if (Wait-ForUrl "http://localhost:8080/api/statistics/dashboard" 120) {
  Write-Ok "后端已就绪: http://localhost:8080/api"
} else {
  Write-Warn "后端启动超时，请检查 MySQL 是否运行、数据库是否已初始化"
}

# 启动前端
Write-Info "正在启动前端 (5173)..."
$frontendProc = Start-Process -FilePath "npm" -ArgumentList "run", "dev" -WorkingDirectory $NepmDir -PassThru -WindowStyle Minimized
Write-Ok "前端进程已启动 (PID $($frontendProc.Id))"

Write-Info "等待前端就绪..."
if (Wait-ForUrl "http://localhost:5173" 60) {
  Write-Ok "前端已就绪: http://localhost:5173"
} else {
  Write-Warn "前端启动较慢，请稍后手动访问 http://localhost:5173"
}

Save-Pids $backendProc.Id $frontendProc.Id

Write-Host ""
Write-Host "启动完成！" -ForegroundColor Green
Write-Host "  前端: http://localhost:5173"
Write-Host "  后端: http://localhost:8080/api"
Write-Host "  停止: 运行 stop.ps1 或 stop.bat"
Write-Host ""
