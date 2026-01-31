# Quick Start Guide - 5 Minutes Setup

## Prerequisites Check
- ✓ MySQL installed and running
- ✓ Node.js 18+ installed
- ✓ Flutter SDK installed
- ✓ Android Emulator or device

## Step 1: Database (2 min)

```powershell
# Open MySQL and create database
mysql -u root -p

-- In MySQL:
CREATE DATABASE gonaturo_foods;
USE gonaturo_foods;
SOURCE c:/ConsitencyProject/flutter_application_1/database/schema.sql;
EXIT;
```

## Step 2: Backend Server (1 min)

```powershell
cd c:\ConsitencyProject\flutter_application_1\backend

# Create .env file with:
# DB_HOST=localhost
# DB_USER=root
# DB_PASSWORD=<your_password>
# DB_NAME=gonaturo_foods
# PORT=3000

npm install
npm start

# Should see: "✓ MySQL Connected Successfully"
# and "Server running on port 3000"
```

## Step 3: Flutter App (2 min)

```powershell
cd c:\ConsitencyProject\flutter_application_1

flutter pub get
flutter run

# App will load products from database automatically
```

## ✅ Done!

The app is now connected to your MySQL database via the Node.js API.

---

## Verify Everything Works

1. **Backend API Test**
   - Visit: http://localhost:3000/api/products
   - Should see JSON with 24 products

2. **Flutter App**
   - Should load products automatically
   - Can filter by category
   - Can view product details

3. **Database Test**
   ```sql
   USE gonaturo_foods;
   SELECT COUNT(*) FROM products;  -- Should show 24
   ```

---

## Common Issues

| Problem | Solution |
|---------|----------|
| MySQL won't connect | Verify password in `.env`, restart MySQL service |
| Port 3000 in use | Change PORT in `.env` to 3001 |
| App can't connect to API | Verify backend is running: `npm start` |
| Products not loading | Check browser: http://localhost:3000/api/products |

## Default Credentials

- **Database:** `gonaturo_foods`
- **DB User:** `root`
- **Backend Port:** `3000`
- **API Base:** `http://10.0.2.2:3000/api` (Android emulator)

---

See `COMPLETE_SETUP_GUIDE.md` for detailed troubleshooting.
