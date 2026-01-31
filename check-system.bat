@echo off
REM GoNaturo Foods - System Check Script
REM Verifies all prerequisites are installed

echo ========================================
echo GoNaturo Foods - System Check
echo ========================================
echo.

REM Check Node.js
echo [1/5] Checking Node.js...
node --version >nul 2>&1
if errorlevel 1 (
    echo ✗ Node.js is NOT installed
    echo    Download from: https://nodejs.org/
) else (
    for /f "tokens=*" %%i in ('node --version') do set NODE_VER=%%i
    echo ✓ Node.js installed: %NODE_VER%
)
echo.

REM Check npm
echo [2/5] Checking npm...
npm --version >nul 2>&1
if errorlevel 1 (
    echo ✗ npm is NOT installed
) else (
    for /f "tokens=*" %%i in ('npm --version') do set NPM_VER=%%i
    echo ✓ npm installed: %NPM_VER%
)
echo.

REM Check Flutter
echo [3/5] Checking Flutter...
flutter --version >nul 2>&1
if errorlevel 1 (
    echo ✗ Flutter is NOT installed
    echo    Download from: https://flutter.dev/
) else (
    echo ✓ Flutter is installed
    flutter --version | findstr "Flutter"
)
echo.

REM Check MySQL
echo [4/5] Checking MySQL...
mysql --version >nul 2>&1
if errorlevel 1 (
    echo ✗ MySQL command line is NOT in PATH
    echo    Install MySQL: https://dev.mysql.com/downloads/mysql/
    echo    OR add MySQL bin directory to PATH
) else (
    for /f "tokens=*" %%i in ('mysql --version') do set MYSQL_VER=%%i
    echo ✓ MySQL installed: %MYSQL_VER%
)
echo.

REM Check Android Emulator or Device
echo [5/5] Checking Flutter devices...
flutter devices >nul 2>&1
if errorlevel 1 (
    echo ✗ No Flutter devices found
    echo    Start an Android emulator or connect a device
) else (
    echo ✓ Checking available devices:
    flutter devices | findstr /V "device connected"
)
echo.

echo ========================================
echo Summary
echo ========================================
echo.
echo If any items show ✗, please install them first.
echo Then run: setup.bat
echo.
echo See QUICK_START.md for instructions.
echo ========================================
echo.
pause
