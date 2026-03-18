@echo off
setlocal

set ROOT=%~dp0
cd /d "%ROOT%"

echo [1/3] Starting backend server in a new window...
start "GoNaturo Backend" cmd /k "cd /d "%ROOT%backend" && node server.js"

echo [2/3] Starting USB reverse auto-reconnect watcher...
start "ADB Reverse Watcher" powershell -NoProfile -ExecutionPolicy Bypass -File "%ROOT%keep_usb_reverse.ps1" -Port 3000

echo [3/3] Running Flutter app on connected device...
flutter run

endlocal
