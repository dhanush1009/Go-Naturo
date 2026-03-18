@echo off
setlocal

set ROOT=%~dp0
cd /d "%ROOT%"

powershell -NoProfile -ExecutionPolicy Bypass -File "%ROOT%run_mobile_lan.ps1"

endlocal
