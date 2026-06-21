#Requires -Version 5.1
<#
.SYNOPSIS
  NEPM - start backend and all frontends
.USAGE
  powershell -ExecutionPolicy Bypass -File .\start.ps1
#>

$ErrorActionPreference = "Stop"
$Root = $PSScriptRoot
$BackApiDir = Join-Path $Root "back-api"
$PidFile = Join-Path $Root ".run\pids.json"

$Frontends = @(
  @{ Name = "nepm"; Dir = (Join-Path $Root "nepm"); Port = 5173 },
  @{ Name = "nepg"; Dir = (Join-Path $Root "nepg"); Port = 5174 },
  @{ Name = "nepv"; Dir = (Join-Path $Root "nepv"); Port = 5175 }
)

function Write-Info($msg) { Write-Host "[INFO] $msg" -ForegroundColor Cyan }
function Write-Ok($msg) { Write-Host "[OK]   $msg" -ForegroundColor Green }
function Write-Warn($msg) { Write-Host "[WARN] $msg" -ForegroundColor Yellow }

function Test-CommandExists($name) {
  return $null -ne (Get-Command $name -ErrorAction SilentlyContinue)
}

function Find-Maven {
  if (Test-CommandExists "mvn") { return (Get-Command "mvn").Source }
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

function Ensure-NpmInstall($dir, $name) {
  if (-not (Test-Path (Join-Path $dir "node_modules"))) {
    Write-Info "npm install in $name..."
    Push-Location $dir
    npm install
    if ($LASTEXITCODE -ne 0) { Pop-Location; throw "npm install failed in $name" }
    Pop-Location
    Write-Ok "$name dependencies ready"
  }
}

function Start-Frontend($dir, $port) {
  $viteCmd = Join-Path $dir "node_modules\.bin\vite.cmd"
  if (Test-Path $viteCmd) {
    return Start-Process -FilePath $viteCmd -WorkingDirectory $dir -PassThru -WindowStyle Minimized
  }
  return Start-Process -FilePath "npm" -ArgumentList "exec", "vite" -WorkingDirectory $dir -PassThru -WindowStyle Minimized
}

function Save-Pids($backendPid, $frontendPids) {
  $dir = Split-Path $PidFile -Parent
  if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir | Out-Null }
  @{
    backendPid = $backendPid
    frontendPids = $frontendPids
    startedAt = (Get-Date).ToString("o")
  } | ConvertTo-Json | Set-Content -Path $PidFile -Encoding UTF8
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Magenta
Write-Host " NEPM - Start Backend and Frontends" -ForegroundColor Magenta
Write-Host "========================================" -ForegroundColor Magenta
Write-Host ""

$missing = @()
if (-not (Test-CommandExists "java")) { $missing += "JDK 8+ (java)" }
if (-not (Test-CommandExists "node")) { $missing += "Node.js 18+ (node)" }
if (-not (Test-CommandExists "npm")) { $missing += "npm" }
$mvn = Find-Maven
if (-not $mvn) { $missing += "Maven 3.6+ (mvn)" }

if ($missing.Count -gt 0) {
  Write-Warn "Missing dependencies:"
  $missing | ForEach-Object { Write-Host "  - $_" -ForegroundColor Yellow }
  exit 1
}

$ports = @(8080) + ($Frontends | ForEach-Object { $_.Port })
foreach ($port in $ports) {
  if (Test-PortListening $port) {
    Write-Warn "Port $port is in use. Run stop.ps1 first."
    exit 1
  }
}

foreach ($fe in $Frontends) {
  Ensure-NpmInstall $fe.Dir $fe.Name
}

Write-Info "Starting backend on 8080..."
$backendProc = Start-Process -FilePath $mvn -ArgumentList "spring-boot:run" -WorkingDirectory $BackApiDir -PassThru -WindowStyle Minimized
Write-Ok "Backend started (PID $($backendProc.Id))"

Write-Info "Waiting for backend..."
if (Wait-ForUrl "http://localhost:8080/api/statistics/dashboard" 120) {
  Write-Ok "Backend ready: http://localhost:8080/api"
} else {
  Write-Warn "Backend timeout. Check MySQL and database init."
}

$frontendPids = @()
foreach ($fe in $Frontends) {
  Write-Info "Starting $($fe.Name) on $($fe.Port)..."
  $proc = Start-Frontend $fe.Dir $fe.Port
  $frontendPids += $proc.Id
  Write-Ok "$($fe.Name) started (PID $($proc.Id))"
}

Start-Sleep -Seconds 3
foreach ($fe in $Frontends) {
  if (Wait-ForUrl "http://localhost:$($fe.Port)" 30) {
    Write-Ok "$($fe.Name) ready: http://localhost:$($fe.Port)"
  } else {
    Write-Warn "$($fe.Name) slow. Try http://localhost:$($fe.Port) later."
  }
}

Save-Pids $backendProc.Id $frontendPids

Write-Host ""
Write-Host "Done!" -ForegroundColor Green
Write-Host "  nepm (admin):  http://localhost:5173"
Write-Host "  nepg (grid):   http://localhost:5174"
Write-Host "  nepv (screen): http://localhost:5175"
Write-Host "  backend:       http://localhost:8080/api"
Write-Host "  Stop:          stop.ps1 / stop.bat"
Write-Host ""
