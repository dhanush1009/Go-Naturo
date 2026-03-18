param(
  [int]$Port = 3000,
  [switch]$NoFlutterRun
)

$ErrorActionPreference = 'Stop'

function Get-PrimaryIPv4 {
  $defaultRoute = Get-NetRoute -DestinationPrefix '0.0.0.0/0' |
    Sort-Object RouteMetric, ifMetric |
    Select-Object -First 1

  if (-not $defaultRoute) {
    return $null
  }

  $ip = Get-NetIPAddress -AddressFamily IPv4 -InterfaceIndex $defaultRoute.InterfaceIndex |
    Where-Object {
      $_.IPAddress -ne '127.0.0.1' -and
      $_.IPAddress -notlike '169.254*'
    } |
    Select-Object -First 1 -ExpandProperty IPAddress

  return $ip
}

function Wait-ForBackend {
  param(
    [string]$HealthUrl,
    [int]$MaxSeconds = 25
  )

  $start = Get-Date
  while (((Get-Date) - $start).TotalSeconds -lt $MaxSeconds) {
    try {
      $response = Invoke-WebRequest -Uri $HealthUrl -UseBasicParsing -TimeoutSec 2
      if ($response.StatusCode -ge 200 -and $response.StatusCode -lt 500) {
        return $true
      }
    } catch {
      Start-Sleep -Seconds 1
    }
  }

  return $false
}

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$ip = Get-PrimaryIPv4

if (-not $ip) {
  Write-Host 'Could not detect LAN IPv4. Connect this PC to Wi-Fi/LAN and try again.' -ForegroundColor Red
  exit 1
}

$apiBaseUrl = "http://$ip`:$Port"
$healthUrl = "$apiBaseUrl/health"

Write-Host "Detected LAN IP: $ip" -ForegroundColor Cyan
Write-Host "API base URL for mobile: $apiBaseUrl" -ForegroundColor Green

$backendReady = $false
try {
  $probe = Invoke-WebRequest -Uri $healthUrl -UseBasicParsing -TimeoutSec 2
  if ($probe.StatusCode -eq 200) {
    $backendReady = $true
  }
} catch {
  $backendReady = $false
}

if (-not $backendReady) {
  Write-Host 'Starting backend server in a new window...' -ForegroundColor Yellow
  Start-Process -FilePath 'cmd.exe' -ArgumentList '/k', "cd /d \"$root\\backend\" && node server.js" -WorkingDirectory $root
  $backendReady = Wait-ForBackend -HealthUrl $healthUrl -MaxSeconds 30
}

if (-not $backendReady) {
  Write-Host 'Backend did not become ready. Check backend window for errors.' -ForegroundColor Red
  exit 1
}

Write-Host 'Backend is ready.' -ForegroundColor Green
Write-Host ''
Write-Host 'Use this same Wi-Fi for both PC and mobile.' -ForegroundColor Cyan
Write-Host "Flutter command: flutter run --dart-define=API_BASE_URL=$apiBaseUrl" -ForegroundColor DarkCyan
Write-Host ''

if ($NoFlutterRun) {
  exit 0
}

Set-Location $root
& flutter run "--dart-define=API_BASE_URL=$apiBaseUrl"
