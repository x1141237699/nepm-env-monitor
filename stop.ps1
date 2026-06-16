#Requires -Version 5.1
<#
.SYNOPSIS
  东软环保公众监督系统 - 停止前后端
.USAGE
  powershell -ExecutionPolicy Bypass -File .\stop.ps1
  或双击 stop.bat
#>

$Root = $PSScriptRoot
$PidFile = Join-Path $Root ".run\pids.json"

function Write-Info($msg) { Write-Host "[INFO] $msg" -ForegroundColor Cyan }
function Write-Ok($msg) { Write-Host "[OK]   $msg" -ForegroundColor Green }

function Stop-ByPort($port) {
  $conns = Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction SilentlyContinue
  foreach ($conn in $conns) {
    $pid = $conn.OwningProcess
    if ($pid -and $pid -ne 0) {
      $proc = Get-Process -Id $pid -ErrorAction SilentlyContinue
      if ($proc) {
        Stop-Process -Id $pid -Force -ErrorAction SilentlyContinue
        Write-Ok "已停止端口 $port 的进程 (PID $pid, $($proc.ProcessName))"
      }
    }
  }
}

function Stop-Tree($pid) {
  if (-not $pid) { return }
  Get-CimInstance Win32_Process -Filter "ParentProcessId=$pid" -ErrorAction SilentlyContinue |
    ForEach-Object { Stop-Tree $_.ProcessId }
  Stop-Process -Id $pid -Force -ErrorAction SilentlyContinue
}

Write-Host ""
Write-Host "正在停止项目..." -ForegroundColor Magenta
Write-Host ""

if (Test-Path $PidFile) {
  try {
    $pids = Get-Content $PidFile -Raw | ConvertFrom-Json
    if ($pids.backendPid) {
      Stop-Tree $pids.backendPid
      Write-Ok "已停止后端进程 (PID $($pids.backendPid))"
    }
    if ($pids.frontendPid) {
      Stop-Tree $pids.frontendPid
      Write-Ok "已停止前端进程 (PID $($pids.frontendPid))"
    }
    Remove-Item $PidFile -Force
  } catch {
    Write-Info "PID 文件读取失败，改为按端口停止"
  }
}

Stop-ByPort 8080
Stop-ByPort 5173

Write-Host ""
Write-Host "项目已停止。" -ForegroundColor Green
Write-Host ""
