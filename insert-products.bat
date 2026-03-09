@echo off
echo ========================================
echo Inserting 110 Products into Database
echo ========================================
echo.

set /p username="Enter MySQL username (default: root): "
if "%username%"=="" set username=root

echo.
echo Clearing old products...
"C:\Program Files\MySQL\MySQL Server 9.6\bin\mysql.exe" -u %username% -p gonaturo_foods -e "DELETE FROM product_benefits; DELETE FROM products;"

echo.
echo Inserting all 110 products...
"C:\Program Files\MySQL\MySQL Server 9.6\bin\mysql.exe" -u %username% -p gonaturo_foods < database\insert_all_products.sql

echo.
echo Verifying data...
"C:\Program Files\MySQL\MySQL Server 9.6\bin\mysql.exe" -u %username% -p gonaturo_foods -e "SELECT COUNT(*) as total_products FROM products;"
"C:\Program Files\MySQL\MySQL Server 9.6\bin\mysql.exe" -u %username% -p gonaturo_foods -e "SELECT COUNT(*) as total_benefits FROM product_benefits;"

echo.
echo ========================================
echo DONE! All products inserted.
echo ========================================
pause
