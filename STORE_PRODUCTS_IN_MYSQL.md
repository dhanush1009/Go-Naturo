# Store All Products in MySQL Database

This guide helps you migrate all 110 products from your Flutter app to MySQL database.

## 📋 What's Included

- **110 Products** across 6 categories:
  - 🛢️ Oils (25 products)
  - 🌾 Flours (22 products)  
  - 💄 Beauty Products (23 products)
  - 💊 Health Products (20 products)
  - 🍪 Snacks (20 products)

## 🚀 Quick Setup (Automated)

### Option 1: Run PowerShell Script (Easiest!)

```powershell
# Make sure you're in the project root directory
cd C:\ConsitencyProject\flutter_application_1

# Run the automated setup script
.\setup-mysql.ps1
```

The script will:
1. ✅ Create database schema
2. ✅ Insert all 110 products
3. ✅ Insert all product benefits
4. ✅ Configure backend `.env` file
5. ✅ Install backend dependencies
6. ✅ Verify data integrity

### Option 2: Manual Setup

Follow the detailed guide: [MYSQL_SETUP_GUIDE.md](MYSQL_SETUP_GUIDE.md)

## 🗄️ Database Files

| File | Description |
|------|-------------|
| `database/schema.sql` | Database structure with categories, products, benefits tables |
| `database/insert_all_products.sql` | All 110 products with benefits (ready to import) |

## 🔧 Backend Configuration

After setup, your backend will be configured with:

```env
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=gonaturo_foods
PORT=3000
```

## 🏃 Running the Backend

```powershell
# Navigate to backend folder
cd backend

# Start the server
npm start
```

Server will run at: `http://localhost:3000`

## 🧪 Test the API

```powershell
# Get all products
curl http://localhost:3000/api/products

# Get products by category
curl "http://localhost:3000/api/products?category_id=2"

# Get all categories
curl http://localhost:3000/api/categories
```

## 📱 Connect Flutter App

Update `lib/services/api_service.dart`:

```dart
class ApiService {
  static const String baseUrl = 'http://localhost:3000/api';
  // For mobile testing, use your PC's IP: 'http://192.168.1.x:3000/api'
}
```

## ✅ Verification

After setup, verify in MySQL:

```sql
USE gonaturo_foods;

-- Check product count
SELECT COUNT(*) FROM products;  -- Should be 110

-- View products by category
SELECT 
    c.name as category,
    COUNT(p.id) as count
FROM categories c
LEFT JOIN products p ON c.id = p.category_id
GROUP BY c.id
ORDER BY c.id;

-- Sample products
SELECT id, name, category_id, price, weight 
FROM products 
LIMIT 10;
```

Expected output:
```
Category          | Count
------------------|------
All Products      | 0
Oils              | 25
Flours            | 22
Beauty Products   | 23
Health Products   | 20
Snacks            | 20
```

## 🛠️ Troubleshooting

### MySQL Not Found
```powershell
# Install MySQL Server from:
# https://dev.mysql.com/downloads/installer/

# Add MySQL to PATH (Windows):
# System Properties > Environment Variables > Path
# Add: C:\Program Files\MySQL\MySQL Server 8.0\bin
```

### Access Denied Error
```sql
-- Reset MySQL root password
ALTER USER 'root'@'localhost' IDENTIFIED BY 'new_password';
FLUSH PRIVILEGES;
```

### Port 3000 Already in Use
Edit `backend/.env`:
```env
PORT=3001
```

### Products Not Showing in App
1. Check backend is running: `npm start`
2. Check API endpoint: `http://localhost:3000/api/products`
3. Update Flutter API URL to match backend
4. For mobile testing, use PC IP instead of localhost

## 📊 Database Schema

```
gonaturo_foods
├── categories (6 categories)
│   ├── id
│   ├── name
│   ├── name_tamil
│   └── icon
│
├── products (110 products)
│   ├── id
│   ├── name
│   ├── category_id (FK)
│   ├── price
│   ├── image_url
│   ├── description
│   ├── weight
│   ├── tamil_name
│   ├── how_to_use
│   ├── ingredients
│   ├── expiry_date
│   ├── suitable_for
│   └── in_stock
│
└── product_benefits (multiple per product)
    ├── id
    ├── product_id (FK)
    └── benefit
```

## 🎉 Success!

Once setup is complete, you'll have:
- ✅ MySQL database with all 110 products
- ✅ Backend API serving product data
- ✅ Cart functionality storing items
- ✅ Products can be managed via database
- ✅ Ready for production deployment

## 📚 Additional Resources

- [MySQL Documentation](https://dev.mysql.com/doc/)
- [Express.js Guide](https://expressjs.com/)
- [Flutter HTTP Package](https://pub.dev/packages/http)

## Need Help?

Check these files for more details:
- `MYSQL_SETUP_GUIDE.md` - Detailed setup instructions
- `database/schema.sql` - Database structure
- `database/insert_all_products.sql` - Product data
- `backend/server.js` - API endpoints

---

**Note:** Make sure MySQL Server is installed and running before starting the setup process.
