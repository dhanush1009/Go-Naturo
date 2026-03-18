param(
  [int]$Port = 3000,
  [int]$PollSeconds = 2
)

$ErrorActionPreference = 'SilentlyContinue'
$lastState = ''

function Get-ConnectedDeviceIds {
  $lines = adb devices 2>$null
  if (-not $lines) { return @() }

  $ids = @()
  foreach ($line in $lines) {
    if ($line -match '^([A-Za-z0-9:_-]+)\s+device$') {
      $ids += $Matches[1]
    }
  }
  return $ids
}

Write-Host "Watching USB devices and keeping adb reverse tcp:$Port -> tcp:$Port active..." -ForegroundColor Cyan
Write-Host "Press Ctrl+C to stop." -ForegroundColor DarkGray

while ($true) {
  $deviceIds = Get-ConnectedDeviceIds

  if ($deviceIds.Count -eq 0) {
    if ($lastState -ne 'none') {
      Write-Host "No USB debug device connected." -ForegroundColor Yellow
      $lastState = 'none'
    }
    Start-Sleep -Seconds $PollSeconds
    continue
  }

  foreach ($id in $deviceIds) {
    adb -s $id reverse "tcp:$Port" "tcp:$Port" | Out-Null
  }

  $stateText = ($deviceIds -join ',')
  if ($lastState -ne $stateText) {
    Write-Host "Reverse active for: $stateText" -ForegroundColor Green
    $lastState = $stateText
  }

  Start-Sleep -Seconds $PollSeconds
}
