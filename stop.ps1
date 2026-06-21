#Requires -Version 5.1
<#
.SYNOPSIS
  NEPM - stop backend and all frontends
.USAGE
  powershell -ExecutionPolicy Bypass -File .\stop.ps1
#>

$Root = $PSScriptRoot
$PidFile = Join-Path $Root ".run\pids.json"

function Write-Info($msg) { Write-Host "[INFO] $msg" -ForegroundColor Cyan }
function Write-Ok($msg) { Write-Host "[OK]   $msg" -ForegroundColor Green }

function Stop-ByPort($port) {
  $conns = Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction SilentlyContinue
  foreach ($conn in $conns) {
    $procId = $conn.OwningProcess
    if ($procId -and $procId -ne 0) {
      $proc = Get-Process -Id $procId -ErrorAction SilentlyContinue
      if ($proc) {
        Stop-Process -Id $procId -Force -ErrorAction SilentlyContinue
        Write-Ok "Stopped port $port (PID $procId, $($proc.ProcessName))"
      }
    }
  }
}

function Stop-Tree($procId) {
  if (-not $procId) { return }
  Get-CimInstance Win32_Process -Filter "ParentProcessId=$procId" -ErrorAction SilentlyContinue |
    ForEach-Object { Stop-Tree $_.ProcessId }
  Stop-Process -Id $procId -Force -ErrorAction SilentlyContinue
}

Write-Host ""
Write-Host "Stopping project..." -ForegroundColor Magenta
Write-Host ""

if (Test-Path $PidFile) {
  try {
    $pids = Get-Content $PidFile -Raw | ConvertFrom-Json
    if ($pids.backendPid) {
      Stop-Tree $pids.backendPid
      Write-Ok "Stopped backend (PID $($pids.backendPid))"
    }
    if ($pids.frontendPid) {
      Stop-Tree $pids.frontendPid
      Write-Ok "Stopped frontend (PID $($pids.frontendPid))"
    }
    if ($pids.frontendPids) {
      foreach ($fpid in $pids.frontendPids) {
        Stop-Tree $fpid
        Write-Ok "Stopped frontend (PID $fpid)"
      }
    }
    Remove-Item $PidFile -Force
  } catch {
    Write-Info "PID file invalid, stopping by port"
  }
}

Stop-ByPort 8080
Stop-ByPort 5173
Stop-ByPort 5174
Stop-ByPort 5175

Write-Host ""
Write-Host "Project stopped." -ForegroundColor Green
Write-Host ""
