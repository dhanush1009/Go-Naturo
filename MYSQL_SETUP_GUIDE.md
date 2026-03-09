# MySQL Database Setup Guide for GoNaturo Foods

This guide will help you set up MySQL database with all 110 products from your Flutter app.

## Prerequisites

- MySQL Server installed (version 5.7 or higher)
- MySQL credentials (username and password)
- Access to command line or MySQL Workbench

## Setup Steps

### Step 1: Start MySQL Server

**Windows:**
```powershell
# Start MySQL service
net start MySQL

# Or use MySQL Workbench to connect
```

**Check if MySQL is running:**
```powershell
mysql --version
```

### Step 2: Create Database and Tables

Open MySQL command line or MySQL Workbench and run:

```bash
# Login to MySQL
mysql -u root -p

# Enter your MySQL root password when prompted
```

Then execute the schema file:

```sql
-- Run the schema file
source C:/ConsitencyProject/flutter_application_1/database/schema.sql

-- Or in MySQL Workbench, File > Run SQL Script and select schema.sql
```

### Step 3: Insert All Products

After creating the database structure, insert all 110 products:

```sql
-- Run the insert script
source C:/ConsitencyProject/flutter_application_1/database/insert_all_products.sql

-- Or in MySQL Workbench, File > Run SQL Script and select insert_all_products.sql
```

### Step 4: Verify Data

Check if all data was inserted correctly:

```sql
USE gonaturo_foods;

-- Count total products
SELECT COUNT(*) as total_products FROM products;
-- Expected: 110

-- Count products by category
SELECT 
    c.name as category, 
    COUNT(p.id) as product_count 
FROM categories c
LEFT JOIN products p ON c.id = p.category_id
GROUP BY c.name;

-- Expected output:
-- Oils: 25
-- Flours: 22
-- Beauty Products: 23
-- Health Products: 20
-- Snacks: 20

-- Count total benefits
SELECT COUNT(*) as total_benefits FROM product_benefits;
```

### Step 5: Configure Backend Connection

Update your backend `.env` file with MySQL credentials:

```env
# Create or edit backend/.env file
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_mysql_password
DB_NAME=gonaturo_foods
PORT=3000
```

### Step 6: Install Backend Dependencies

```powershell
# Navigate to backend folder
cd backend

# Install Node.js dependencies
npm install

# Start the backend server
npm start
```

The server should start on `http://localhost:3000`

### Step 7: Test the API

Test if products are being served correctly:

```powershell
# Get all products
curl http://localhost:3000/api/products

# Get products by category (category_id=2 for Oils)
curl "http://localhost:3000/api/products?category_id=2"

# Get all categories
curl http://localhost:3000/api/categories
```

## Troubleshooting

### MySQL Connection Error

If you get "Access denied" error:

1. Reset MySQL root password:
```sql
ALTER USER 'root'@'localhost' IDENTIFIED BY 'new_password';
FLUSH PRIVILEGES;
```

2. Create a new user for the application:
```sql
CREATE USER 'gonaturo_user'@'localhost' IDENTIFIED BY 'secure_password';
GRANT ALL PRIVILEGES ON gonaturo_foods.* TO 'gonaturo_user'@'localhost';
FLUSH PRIVILEGES;
```

Then update your `.env` file with the new credentials.

### Port Already in Use

If port 3000 is already in use, change it in `.env`:
```env
PORT=3001
```

### Products Not Showing

Check backend logs for errors:
```powershell
# In backend folder
npm start
```

Look for any error messages in the console.

## Database Backup

To backup your database:

```powershell
# Backup database
mysqldump -u root -p gonaturo_foods > backup_$(Get-Date -Format 'yyyy-MM-dd').sql

# Restore from backup
mysql -u root -p gonaturo_foods < backup_2026-03-09.sql
```

## Update Flutter App

Update your Flutter app's `lib/services/api_service.dart` to point to your local MySQL backend:

```dart
class ApiService {
  static const String baseUrl = 'http://localhost:3000/api';
  // or use your computer's IP address: 'http://192.168.1.x:3000/api'
  
  // ... rest of the code
}
```

For testing on mobile device, use your computer's local IP address instead of `localhost`.

## Next Steps

1. ✅ Database created with all tables
2. ✅ All 110 products inserted
3. ✅ Categories configured (6 categories)
4. ✅ Product benefits added
5. 🔄 Backend server running
6. 🔄 Flutter app connected to backend

Your GoNaturo Foods app is now fully connected to MySQL database with all 110 products! 🎉
