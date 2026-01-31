# Quick Reference - URLs, Credentials & Commands

## 🔐 Default Credentials

```
MySQL Database
├── Database Name: gonaturo_foods
├── User: root
├── Password: [Your MySQL password]
└── Host: localhost

Backend Server
├── Port: 3000
├── Host: localhost (or 10.0.2.2 for Android emulator)
└── Base URL: http://10.0.2.2:3000/api

Flutter App
├── Target: Android Emulator / iOS Simulator / Physical Device
└── Auto-connects to backend on startup
```

---

## 🌐 API URLs

### Test Endpoints (Paste in Browser)

| Endpoint | URL |
|----------|-----|
| All Products | `http://localhost:3000/api/products` |
| All Categories | `http://localhost:3000/api/categories` |
| Cart Items | `http://localhost:3000/api/cart` |

### From Flutter App

| Endpoint | URL |
|----------|-----|
| All Products | `http://10.0.2.2:3000/api/products` |
| Single Product | `http://10.0.2.2:3000/api/products/1` |
| All Categories | `http://10.0.2.2:3000/api/categories` |
| Add to Cart | `http://10.0.2.2:3000/api/cart` (POST) |
| Get Cart | `http://10.0.2.2:3000/api/cart` (GET) |
| Update Cart | `http://10.0.2.2:3000/api/cart/:id` (PUT) |
| Delete from Cart | `http://10.0.2.2:3000/api/cart/:id` (DELETE) |

---

## 📁 Important Directories

```
Project Root: c:\ConsitencyProject\flutter_application_1\

├── backend/              # Node.js API server
│   ├── server.js        # Main server code
│   ├── package.json     # Dependencies
│   └── .env             # Configuration (create this)
│
├── database/            # MySQL files
│   └── schema.sql       # Create database schema
│
├── lib/                 # Flutter app code
│   ├── main.dart        # Main app
│   ├── product_details_page.dart
│   ├── models/
│   │   └── product.dart
│   └── services/
│       └── api_service.dart
│
└── pubspec.yaml         # Flutter dependencies
```

---

## ⚙️ Configuration Files

### MySQL Configuration (.env template)
Create file: `backend/.env`
```
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_password_here
DB_NAME=gonaturo_foods
PORT=3000
```

### Flutter API Configuration
File: `lib/services/api_service.dart` (line ~8)
```dart
// For Android Emulator:
static const String baseUrl = 'http://10.0.2.2:3000/api';

// For iOS Simulator:
static const String baseUrl = 'http://127.0.0.1:3000/api';

// For Physical Device (example):
static const String baseUrl = 'http://192.168.1.100:3000/api';
```

---

## 🚀 Startup Commands

### Terminal 1: Database
```powershell
# Verify MySQL is running
mysql --version

# Create database
mysql -u root -p -e "SOURCE c:\ConsitencyProject\flutter_application_1\database\schema.sql;"

# Verify data
mysql -u root -p -e "USE gonaturo_foods; SELECT COUNT(*) FROM products;"
```

### Terminal 2: Backend Server
```powershell
cd c:\ConsitencyProject\flutter_application_1\backend
npm install          # First time only
npm start           # Start server
```

**Expected Output:**
```
✓ MySQL Connected Successfully
Server running on port 3000
```

### Terminal 3: Flutter App
```powershell
cd c:\ConsitencyProject\flutter_application_1
flutter pub get     # First time only
flutter run         # Run app
```

---

## 📊 Sample API Responses

### GET /api/products
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "Coconut Oil / தேங்காய் எண்ணெய்",
      "category_name": "Oils",
      "price": 220.00,
      "image_url": "https://gonaturo.in/...",
      "description": "Pure cold-pressed coconut oil...",
      "weight": "1000ml",
      "benefits": ["100% Natural", "Cold Pressed", "No Preservatives"]
    },
    ...
  ]
}
```

### GET /api/categories
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "All Products",
      "name_tamil": "அனைத்து பொருட்கள்",
      "icon": "grid_view"
    },
    ...
  ]
}
```

---

## 📱 Platform-Specific URLs

### Android Emulator
```
API Base: http://10.0.2.2:3000/api
Reason: 10.0.2.2 is special alias for host machine's localhost
```

### iOS Simulator
```
API Base: http://127.0.0.1:3000/api
Reason: Can directly access localhost
```

### Physical Android Device
```
API Base: http://<YOUR_COMPUTER_IP>:3000/api
Example: http://192.168.1.100:3000/api

To find your IP:
- Windows: ipconfig
- Mac: ifconfig
- Linux: ip addr
```

### Physical iOS Device
```
API Base: http://<YOUR_COMPUTER_IP>:3000/api
Same as Android device
```

---

## 🔄 Testing Workflow

### 1. Verify Database
```powershell
mysql -u root -p
USE gonaturo_foods;
SHOW TABLES;
SELECT COUNT(*) FROM products;  -- Should show 24
```

### 2. Verify Backend
```powershell
# Browser: http://localhost:3000/api/products
# Or PowerShell:
curl http://localhost:3000/api/products
```

### 3. Verify Flutter App
```powershell
flutter run
# App should show loading spinner, then load all 24 products
```

---

## 🛠️ Troubleshooting Commands

### Kill Process on Port 3000
```powershell
# Windows
netstat -ano | findstr :3000     # Find PID
taskkill /PID <PID> /F           # Kill it

# Mac/Linux
lsof -ti:3000 | xargs kill -9
```

### Reset Everything
```powershell
# Remove and reinstall packages
cd backend
rm -r node_modules package-lock.json
npm install

# Flutter clean build
cd ..
flutter clean
flutter pub get
```

### Check Port Availability
```powershell
# Port 3000
netstat -ano | findstr :3000

# Port 3306 (MySQL)
netstat -ano | findstr :3306
```

### View Database Content
```sql
-- Count products
SELECT COUNT(*) FROM products;

-- List all products
SELECT id, name, price FROM products;

-- List categories
SELECT * FROM categories;

-- Count benefits
SELECT product_id, COUNT(*) FROM product_benefits GROUP BY product_id;

-- View cart items
SELECT * FROM cart;
```

---

## 📋 Verification Checklist

Use this to verify everything is working:

- [ ] MySQL running: `mysql --version` shows version number
- [ ] Database created: `SELECT DATABASE();` returns `gonaturo_foods`
- [ ] Tables exist: `SHOW TABLES;` shows 4 tables
- [ ] Products exist: `SELECT COUNT(*) FROM products;` returns 24
- [ ] Backend starts: `npm start` shows "Server running on port 3000"
- [ ] API responds: Browser shows JSON at `http://localhost:3000/api/products`
- [ ] Flutter builds: `flutter run` shows "Launching..."
- [ ] App loads products: App shows 24 products without error

---

## 📞 Quick Support

| Issue | Solution |
|-------|----------|
| Can't connect to MySQL | Check MySQL is running, verify credentials |
| Backend won't start | Check Node.js installed, run `npm install` |
| Port 3000 in use | Kill process or change PORT in `.env` |
| API returns error | Check browser: `http://localhost:3000/api/products` |
| App shows error spinner | Verify backend running, check Flutter logs |
| Products not loading | Kill app, rebuild: `flutter clean && flutter run` |

---

## 📚 Documentation Map

| Document | Content |
|----------|---------|
| README_DATABASE_EDITION.md | Overview & features |
| QUICK_START.md | 5-minute setup |
| COMPLETE_SETUP_GUIDE.md | Detailed instructions |
| INTEGRATION_CHECKLIST.md | Completion status |
| This file | URLs, credentials, commands |
| backend/README.md | API documentation |

---

## 🔗 File Locations

```
Configuration Files:
├── backend/.env              (Create this with your credentials)
├── pubspec.yaml              (Already has http package)
└── lib/services/api_service.dart (Base URL defined here)

Source Code:
├── backend/server.js         (Node.js API server)
├── lib/main.dart            (Flutter app entry point)
├── lib/models/product.dart  (Data model)
└── lib/services/api_service.dart (API client)

Database:
└── database/schema.sql       (Import this to create schema)

Documentation:
├── QUICK_START.md
├── COMPLETE_SETUP_GUIDE.md
└── INTEGRATION_CHECKLIST.md
```

---

## 🎯 Success Indicators

✅ When everything works:

1. **MySQL:**
   ```
   Output: 24 rows from SELECT COUNT(*) FROM products;
   ```

2. **Backend:**
   ```
   Output: Server running on port 3000
   ```

3. **Browser:**
   ```
   URL: http://localhost:3000/api/products
   Output: JSON with 24 products
   ```

4. **Flutter App:**
   ```
   Shows loading spinner briefly, then displays all 24 products
   ```

---

**Print this page and keep it handy while setting up!**

Last Updated: January 30, 2026
