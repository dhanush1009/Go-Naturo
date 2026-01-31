# 🚀 READY TO RUN - Step-by-Step Guide

## ✅ What's Already Done

- ✅ Node.js v22.15.0 installed
- ✅ npm v11.5.2 installed
- ✅ Flutter 3.35.2 installed
- ✅ Backend dependencies installed (112 packages)
- ✅ Flutter dependencies installed
- ✅ Android emulators available (2 emulators)
- ✅ All code files created with NO errors

## 🎯 What You Need To Do (3 Simple Steps)

### ⚠️ MySQL Setup Required

**You need MySQL installed to proceed.** Choose one option:

#### Option A: Install MySQL (Recommended)
1. Download MySQL: https://dev.mysql.com/downloads/mysql/
2. Install with default settings
3. Remember your root password!
4. Come back here after installation

#### Option B: Use Alternative Database (Advanced)
- SQLite (lightweight, no server)
- PostgreSQL (similar to MySQL)
- MongoDB (NoSQL option)

---

## 📋 Three-Step Startup (After MySQL is installed)

### Step 1️⃣: Set Up Database (2 minutes)

**Open Command Prompt as Administrator:**

```powershell
# Start MySQL (adjust path if different)
cd "C:\Program Files\MySQL\MySQL Server 8.0\bin"
mysql -u root -p

# In MySQL prompt, run:
CREATE DATABASE gonaturo_foods;
exit;

# Import the schema
mysql -u root -p gonaturo_foods < "c:\ConsitencyProject\flutter_application_1\database\schema.sql"
```

**Or use MySQL Workbench:**
1. Open MySQL Workbench
2. Create connection to localhost
3. Run SQL: `CREATE DATABASE gonaturo_foods;`
4. File → Open SQL Script → Select `database/schema.sql`
5. Click ⚡ Execute

**Verify:**
```sql
USE gonaturo_foods;
SELECT COUNT(*) FROM products;
-- Should show: 24
```

---

### Step 2️⃣: Configure & Start Backend (1 minute)

**Terminal 1 (Backend Server):**

```powershell
cd c:\ConsitencyProject\flutter_application_1\backend

# Create .env file with your MySQL password
# Use notepad or any text editor:
notepad .env
```

**In .env file, paste this (replace with YOUR password):**
```
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=YOUR_MYSQL_PASSWORD_HERE
DB_NAME=gonaturo_foods
PORT=3000
```

**Save and close, then start server:**
```powershell
npm start
```

**Expected output:**
```
✓ MySQL Connected Successfully
Server running on port 3000
```

**Test it works:**
Open browser: http://localhost:3000/api/products
- Should show JSON with 24 products

---

### Step 3️⃣: Run Flutter App (1 minute)

**Terminal 2 (Flutter App) - Open NEW terminal:**

```powershell
cd c:\ConsitencyProject\flutter_application_1

# Option A: Run on Android Emulator (Recommended)
flutter emulators --launch Pixel_6_Pro
# Wait 30 seconds for emulator to start
flutter run

# Option B: Run on Windows (Desktop)
flutter run -d windows

# Option C: Run on Chrome (Web)
flutter run -d chrome
```

**Expected:**
- App launches with loading spinner
- Products load from MySQL database
- Shows 24 GoNaturo products
- Can filter by category
- Can tap product for details

---

## 🎉 Success Indicators

When everything works, you'll see:

**Terminal 1 (Backend):**
```
✓ MySQL Connected Successfully
Server running on port 3000
```

**Terminal 2 (Flutter):**
```
Launching lib/main.dart on Pixel 6 Pro in debug mode...
✓ Built build/app/outputs/flutter-apk/app-debug.apk
```

**In App:**
- Loading spinner shows briefly
- 24 products appear
- Images load correctly
- Can filter by: Oils, Flours, Beauty Products, Health Products, Snacks
- No error messages

---

## 🐛 Quick Troubleshooting

| Problem | Solution |
|---------|----------|
| **"MySQL not found"** | Install MySQL from link above, or add to PATH |
| **"Connection refused"** | MySQL not running - start MySQL service |
| **"Access denied"** | Wrong password in .env file |
| **Backend won't start** | Check .env file exists with correct credentials |
| **"Port 3000 in use"** | Another app using port 3000 - change PORT in .env to 3001 |
| **App shows error** | Backend not running - check Terminal 1 |
| **No products load** | Check browser: http://localhost:3000/api/products |

---

## 📱 Alternative: Run Without Database (Testing Only)

If you want to test the app WITHOUT setting up MySQL:

**The app has fallback hardcoded data!**

```powershell
# Just run the app - it will use offline data if backend fails
flutter run -d windows
```

App will show orange message: "Using offline data. Error: ..."
- Still shows all 24 products
- Still works fully
- Just doesn't sync to database

---

## 🎯 Recommended Flow

**First Time:**
1. Install MySQL (if not already installed)
2. Set up database (Step 1)
3. Start backend (Step 2)
4. Run app on Windows first (fastest): `flutter run -d windows`
5. Test filtering and details
6. Then try Android emulator

**Every Time After:**
```powershell
# Terminal 1
cd backend
npm start

# Terminal 2 (new terminal)
flutter run
```

---

## 📊 System Status

```
✅ Node.js & npm         - Ready
✅ Flutter SDK           - Ready
✅ Android Emulators     - Ready (Pixel_6_Pro, Medium_Phone_API_36.0)
✅ Windows Desktop       - Ready
✅ Chrome Web            - Ready
✅ Backend Code          - Ready (112 packages installed)
✅ Flutter App           - Ready (dependencies installed)
✅ Database Schema       - Ready (schema.sql exists)
⚠️  MySQL                - Needs installation/setup
⚠️  Backend .env         - Needs creation with password
```

---

## 🎬 Quick Start Commands

**Run everything (assuming MySQL is set up):**

```powershell
# Terminal 1: Start backend
cd c:\ConsitencyProject\flutter_application_1\backend
npm start

# Terminal 2: Start emulator and run app
cd c:\ConsitencyProject\flutter_application_1
flutter emulators --launch Pixel_6_Pro
timeout /t 30 /nobreak
flutter run
```

---

## 📞 Need Help?

**MySQL Installation:**
- Download: https://dev.mysql.com/downloads/mysql/
- Guide: https://dev.mysql.com/doc/refman/8.0/en/windows-installation.html

**Documentation:**
- Quick setup: [QUICK_START.md](QUICK_START.md)
- Detailed guide: [COMPLETE_SETUP_GUIDE.md](COMPLETE_SETUP_GUIDE.md)
- Commands reference: [QUICK_REFERENCE.md](QUICK_REFERENCE.md)

**Test Backend API:**
```
Browser: http://localhost:3000/api/products
Should return: JSON with 24 products
```

---

## ✨ You're Almost There!

**Your Options:**

🔥 **Option 1: Full Setup (with database)**
→ Install MySQL → Follow 3 steps above → Full functionality

⚡ **Option 2: Quick Test (no database)**
→ Just run: `flutter run -d windows` → Works with offline data

---

**Status:** 🟡 Waiting for MySQL installation to complete setup

**After MySQL is installed:** Follow the 3 steps above and you're done! 🎉
