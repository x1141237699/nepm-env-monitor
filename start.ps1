#Requires -Version 5.1
<#
.SYNOPSIS
  NEPM - start backend and frontend
.USAGE
  powershell -ExecutionPolicy Bypass -File .\start.ps1
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
Write-Host " NEPM - Start Backend and Frontend" -ForegroundColor Magenta
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

if (Test-PortListening 8080) {
  Write-Warn "Port 8080 is in use. Run stop.ps1 first."
  exit 1
}
if (Test-PortListening 5173) {
  Write-Warn "Port 5173 is in use. Run stop.ps1 first."
  exit 1
}

if (-not (Test-Path (Join-Path $NepmDir "node_modules"))) {
  Write-Info "Running npm install..."
  Push-Location $NepmDir
  npm install
  if ($LASTEXITCODE -ne 0) { Pop-Location; throw "npm install failed" }
  Pop-Location
  Write-Ok "npm install done"
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

$viteCmd = Join-Path $NepmDir "node_modules\.bin\vite.cmd"
if (-not (Test-Path $viteCmd)) { $viteCmd = "npx" }
$viteArgs = if ($viteCmd -eq "npx") { @("vite") } else { @() }

Write-Info "Starting frontend on 5173..."
if ($viteCmd -eq "npx") {
  $frontendProc = Start-Process -FilePath "npm" -ArgumentList "exec", "vite" -WorkingDirectory $NepmDir -PassThru -WindowStyle Minimized
} else {
  $frontendProc = Start-Process -FilePath $viteCmd -WorkingDirectory $NepmDir -PassThru -WindowStyle Minimized
}
Write-Ok "Frontend started (PID $($frontendProc.Id))"

Write-Info "Waiting for frontend..."
if (Wait-ForUrl "http://localhost:5173" 60) {
  Write-Ok "Frontend ready: http://localhost:5173"
} else {
  Write-Warn "Frontend slow. Try http://localhost:5173 later."
}

Save-Pids $backendProc.Id $frontendProc.Id

Write-Host ""
Write-Host "Done!" -ForegroundColor Green
Write-Host "  Frontend: http://localhost:5173"
Write-Host "  Backend:  http://localhost:8080/api"
Write-Host "  Stop:     stop.ps1 / stop.bat"
Write-Host ""
