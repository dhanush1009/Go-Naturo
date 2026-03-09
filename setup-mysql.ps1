# Quick MySQL Setup Script for GoNaturo Foods
# Run this script after installing MySQL Server

Write-Host "========================================" -ForegroundColor Green
Write-Host "GoNaturo Foods - MySQL Setup Script" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

# Check if MySQL is installed
Write-Host "Checking MySQL installation..." -ForegroundColor Yellow
$mysqlPath = Get-Command mysql -ErrorAction SilentlyContinue
if (-not $mysqlPath) {
    Write-Host "ERROR: MySQL not found in PATH!" -ForegroundColor Red
    Write-Host "Please install MySQL Server or add it to your PATH" -ForegroundColor Red
    Write-Host "Download from: https://dev.mysql.com/downloads/installer/" -ForegroundColor Cyan
    exit 1
}

Write-Host "Successfully found MySQL!" -ForegroundColor Green
Write-Host ""

# Get MySQL credentials
Write-Host "Enter MySQL Credentials:" -ForegroundColor Yellow
$dbUser = Read-Host "MySQL Username (default: root)"
if ([string]::IsNullOrWhiteSpace($dbUser)) {
    $dbUser = "root"
}

$securePassword = Read-Host "MySQL Password" -AsSecureString
$dbPasswordPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
    [Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword)
)

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Step 1: Creating Database Schema" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Green

# Run schema.sql
$schemaFile = "database\schema.sql"
if (Test-Path $schemaFile) {
    Write-Host "Running schema.sql..." -ForegroundColor Cyan
    
    $env:MYSQL_PWD = $dbPasswordPlain
    $schemaPath = Resolve-Path $schemaFile
    mysql -u $dbUser -e "source $($schemaPath -replace '\\', '/')" 2>&1 | Out-Null
    $schemaResult = $LASTEXITCODE
    $env:MYSQL_PWD = $null
    
    if ($schemaResult -eq 0) {
        Write-Host "Successfully created database schema!" -ForegroundColor Green
    }
    else {
        Write-Host "Error creating schema!" -ForegroundColor Red
        exit 1
    }
}
else {
    Write-Host "schema.sql not found!" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Step 2: Inserting All Products" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Green

# Run insert_all_products.sql
$insertFile = "database\insert_all_products.sql"
if (Test-Path $insertFile) {
    Write-Host "Inserting 110 products into database..." -ForegroundColor Cyan
    Write-Host "This may take a minute..." -ForegroundColor Cyan
    
    $env:MYSQL_PWD = $dbPasswordPlain
    $insertPath = Resolve-Path $insertFile
    mysql -u $dbUser gonaturo_foods -e "source $($insertPath -replace '\\', '/')" 2>&1 | Out-Null
    $insertResult = $LASTEXITCODE
    $env:MYSQL_PWD = $null
    
    if ($insertResult -eq 0) {
        Write-Host "Successfully inserted all products!" -ForegroundColor Green
    }
    else {
        Write-Host "Error inserting products!" -ForegroundColor Red
        exit 1
    }
}
else {
    Write-Host "insert_all_products.sql not found!" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Step 3: Verifying Data" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Green

# Verify data
$env:MYSQL_PWD = $dbPasswordPlain
$productCount = mysql -u $dbUser gonaturo_foods -N -e "SELECT COUNT(*) FROM products;" 2>&1
$benefitCount = mysql -u $dbUser gonaturo_foods -N -e "SELECT COUNT(*) FROM product_benefits;" 2>&1
$env:MYSQL_PWD = $null

$productCount = $productCount.Trim()
$benefitCount = $benefitCount.Trim()

Write-Host "Total Products: $productCount / 110" -ForegroundColor Cyan
Write-Host "Total Benefits: $benefitCount" -ForegroundColor Cyan

if ($productCount -eq "110") {
    Write-Host "All products verified!" -ForegroundColor Green
}
else {
    Write-Host "Warning: Expected 110 products but found $productCount" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Step 4: Configuring Backend" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Green

# Create .env file for backend
$envFile = "backend\.env"
$envContent = @"
# GoNaturo Foods Backend Configuration
DB_HOST=localhost
DB_USER=$dbUser
DB_PASSWORD=$dbPasswordPlain
DB_NAME=gonaturo_foods
PORT=3000
"@

$envContent | Out-File -FilePath $envFile -Encoding UTF8
Write-Host "Backend .env file created" -ForegroundColor Green

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Step 5: Installing Backend Dependencies" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Green

# Check if node_modules exists
if (Test-Path "backend\node_modules") {
    Write-Host "Dependencies already installed" -ForegroundColor Green
}
else {
    Write-Host "Installing Node.js packages..." -ForegroundColor Cyan
    Push-Location backend
    npm install
    Pop-Location
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Dependencies installed successfully" -ForegroundColor Green
    }
    else {
        Write-Host "Warning: Some dependencies may have failed to install" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "SETUP COMPLETED SUCCESSFULLY!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "1. Start the backend server:" -ForegroundColor White
Write-Host "   cd backend" -ForegroundColor Cyan
Write-Host "   npm start" -ForegroundColor Cyan
Write-Host ""
Write-Host "2. Test the API:" -ForegroundColor White
Write-Host "   Open browser: http://localhost:3000/api/products" -ForegroundColor Cyan
Write-Host ""
Write-Host "3. Update Flutter app to use MySQL backend" -ForegroundColor White
Write-Host "   See MYSQL_SETUP_GUIDE.md for details" -ForegroundColor Cyan
Write-Host ""
Write-Host "Database Summary:" -ForegroundColor Yellow
Write-Host "  Database: gonaturo_foods" -ForegroundColor White
Write-Host "  Products: $productCount" -ForegroundColor White
Write-Host "  Categories: 6 (Oils, Flours, Beauty, Health, Snacks)" -ForegroundColor White
Write-Host ""
