@echo off
REM GoNaturo Foods - Complete Setup Script
REM Run this script to set up everything automatically

echo ========================================
echo GoNaturo Foods - Automated Setup
echo ========================================
echo.

REM Step 1: Install Backend Dependencies
echo [1/4] Installing backend dependencies...
cd backend
call npm install
if errorlevel 1 (
    echo ERROR: npm install failed!
    pause
    exit /b 1
)
echo ✓ Backend dependencies installed
echo.

REM Step 2: Check for .env file
if not exist .env (
    echo [2/4] Creating .env file from template...
    copy .env.example .env
    echo.
    echo ⚠️  IMPORTANT: Edit backend/.env and add your MySQL password!
    echo    Open backend/.env in a text editor and update:
    echo    DB_PASSWORD=your_mysql_password_here
    echo.
    pause
) else (
    echo [2/4] .env file already exists
)
echo.

REM Step 3: Install Flutter Dependencies
echo [3/4] Installing Flutter dependencies...
cd ..
call flutter pub get
if errorlevel 1 (
    echo ERROR: flutter pub get failed!
    pause
    exit /b 1
)
echo ✓ Flutter dependencies installed
echo.

REM Step 4: Instructions
echo [4/4] Setup complete! Next steps:
echo.
echo ========================================
echo MANUAL STEPS REQUIRED:
echo ========================================
echo.
echo 1. Set up MySQL Database:
echo    - Open MySQL Workbench or MySQL Command Line
echo    - Run: CREATE DATABASE gonaturo_foods;
echo    - Import: database/schema.sql
echo.
echo 2. Configure Backend:
echo    - Edit backend/.env
echo    - Set DB_PASSWORD to your MySQL root password
echo.
echo 3. Start Backend Server:
echo    - Open new terminal
echo    - cd backend
echo    - npm start
echo.
echo 4. Run Flutter App:
echo    - Open new terminal
echo    - flutter run
echo.
echo ========================================
echo See QUICK_START.md for detailed instructions
echo ========================================
echo.
pause
