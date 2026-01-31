# GoNaturo Foods - Complete Setup Guide

This guide provides step-by-step instructions to set up and run the GoNaturo Foods Flutter app with MySQL database backend.

## System Architecture

```
Flutter Mobile App
       ↓ (HTTP Requests)
Node.js Backend API (Express)
       ↓ (SQL Queries)
MySQL Database (gonaturo_foods)
```

---

## Step 1: MySQL Database Setup

### Prerequisites
- MySQL Server 8.0 or later installed
- MySQL running and accessible

### Setup Instructions

1. **Create Database**
   - Open MySQL command line or MySQL Workbench
   - Run:
     ```sql
     CREATE DATABASE gonaturo_foods;
     USE gonaturo_foods;
     ```

2. **Import Schema**
   - Run the schema file located at: `database/schema.sql`
   
   **Option A: Using MySQL CLI**
   ```bash
   mysql -u root -p gonaturo_foods < "c:\ConsitencyProject\flutter_application_1\database\schema.sql"
   ```
   
   **Option B: Using MySQL Workbench**
   - File → Open SQL Script → Select `database/schema.sql`
   - Execute the script

3. **Verify Database**
   ```sql
   USE gonaturo_foods;
   SHOW TABLES;
   -- Should show: categories, products, product_benefits, cart
   
   SELECT COUNT(*) FROM products;
   -- Should show: 24 products
   ```

---

## Step 2: Backend Server Setup

### Prerequisites
- Node.js 18.x or later installed
- npm (included with Node.js)

### Installation Steps

1. **Navigate to Backend Directory**
   ```powershell
   cd c:\ConsitencyProject\flutter_application_1\backend
   ```

2. **Create .env Configuration File**
   Create a file named `.env` in the backend directory with your MySQL credentials:
   ```
   DB_HOST=localhost
   DB_USER=root
   DB_PASSWORD=your_mysql_password
   DB_NAME=gonaturo_foods
   PORT=3000
   ```
   
   Replace `your_mysql_password` with your actual MySQL root password.

3. **Install Dependencies**
   ```powershell
   npm install
   ```
   
   This installs:
   - `express` - Web framework
   - `mysql2/promise` - MySQL database driver
   - `cors` - Cross-Origin Resource Sharing
   - `dotenv` - Environment variable management

4. **Start Backend Server**
   ```powershell
   npm start
   ```
   
   **Expected Output:**
   ```
   ✓ MySQL Connected Successfully
   Server running on port 3000
   ```

5. **Test API Endpoints**
   Open your browser and visit:
   
   - http://localhost:3000/api/products
   - http://localhost:3000/api/categories
   - http://localhost:3000/api/cart
   
   You should see JSON responses from the database.

---

## Step 3: Flutter App Setup

### Prerequisites
- Flutter SDK 3.9.0 or later
- Android emulator or physical device
- Backend server running (from Step 2)

### Installation Steps

1. **Install Flutter Dependencies**
   ```powershell
   cd c:\ConsitencyProject\flutter_application_1
   flutter pub get
   ```
   
   This installs the `http` package and all other dependencies.

2. **Configure Backend URL (if needed)**
   - Default URL for Android Emulator: `http://10.0.2.2:3000/api`
   - Edit `lib/services/api_service.dart` if you need to change the URL
   
   **Platform-specific URLs:**
   - Android Emulator: `http://10.0.2.2:3000`
   - iOS Simulator: `http://127.0.0.1:3000`
   - Physical Device: `http://<your-computer-ip>:3000`
   
   To find your computer IP:
   ```powershell
   ipconfig  # Look for "IPv4 Address"
   ```

3. **Start Android Emulator** (if using emulator)
   ```powershell
   flutter emulators --launch android_emulator_name
   # or open from Android Studio
   ```

4. **Run Flutter App**
   ```powershell
   flutter run
   ```
   
   **First run may take 2-3 minutes to build.**
   
   Expected output:
   ```
   ✓ Built build/app/outputs/flutter-apk/app-debug.apk
   Launching lib/main.dart on Android device...
   ```

---

## Features

### Current Functionality
- ✅ Load all products from MySQL database
- ✅ Display 24 products across 6 categories
- ✅ Filter products by category
- ✅ Product details with benefits
- ✅ Hero animations on product cards
- ✅ Shopping cart functionality
- ✅ Bilingual support (English + Tamil)
- ✅ Beautiful Material Design 3 UI

### API Endpoints

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/api/products` | Get all products |
| GET | `/api/products/:id` | Get single product |
| GET | `/api/categories` | Get all categories |
| POST | `/api/cart` | Add item to cart |
| GET | `/api/cart` | Get cart items |
| PUT | `/api/cart/:id` | Update cart item |
| DELETE | `/api/cart/:id` | Remove from cart |

---

## Troubleshooting

### MySQL Connection Issues

**Error: "connect ECONNREFUSED 127.0.0.1:3306"**
- Verify MySQL is running: `mysql --version`
- Start MySQL service:
  ```powershell
  # Windows
  net start MySQL80
  ```
- Check `.env` credentials match your MySQL setup

**Error: "Access denied for user 'root'@'localhost'"**
- Verify DB_PASSWORD in `.env` is correct
- Test manually: `mysql -u root -p`

### Backend Server Issues

**Error: "Cannot find module 'express'"**
- Solution: Run `npm install` in backend directory
- Verify `package.json` exists with dependencies

**Error: "Port 3000 already in use"**
- Change PORT in `.env` to an available port (e.g., 3001)
- Or kill process on port 3000:
  ```powershell
  lsof -ti:3000 | xargs kill -9  # macOS/Linux
  netstat -ano | findstr :3000  # Windows (find PID, then taskkill)
  ```

### Flutter App Issues

**Error: "Connection timeout when loading products"**
- Verify backend server is running on correct port
- Check API URL in `lib/services/api_service.dart`
- Test API manually in browser: `http://localhost:3000/api/products`

**Error: "Failed to resolve 'http://10.0.2.2:3000'"**
- Using device instead of emulator? Use your computer's IP:
  - Edit `lib/services/api_service.dart`
  - Change `10.0.2.2` to your IP (e.g., `192.168.1.100`)

**App crashes on startup**
- Check Flutter console for error messages
- Run `flutter clean` then `flutter pub get`
- Rebuild and run: `flutter run`

### Database Issues

**Error: "Table 'gonaturo_foods.products' doesn't exist"**
- Run schema.sql again to create tables
- Verify: `USE gonaturo_foods; SHOW TABLES;`

**Products not showing in app**
- Verify products were inserted: `SELECT COUNT(*) FROM products;`
- Check backend logs for query errors
- Verify API response: Visit http://localhost:3000/api/products in browser

---

## File Structure

```
flutter_application_1/
├── lib/
│   ├── main.dart                      # Main app with product listing
│   ├── product_details_page.dart      # Product detail view
│   ├── models/
│   │   └── product.dart              # Product data model
│   └── services/
│       └── api_service.dart          # API communication layer
├── backend/
│   ├── server.js                      # Express API server
│   ├── package.json                   # Node dependencies
│   ├── .env.example                  # Environment template
│   └── README.md                      # Backend documentation
├── database/
│   └── schema.sql                     # MySQL schema & sample data
├── pubspec.yaml                       # Flutter dependencies
└── DATABASE_SETUP.md                  # This file
```

---

## Development Workflow

### Making Changes

1. **To modify products in database:**
   - Edit `database/schema.sql`
   - Run: `mysql -u root -p gonaturo_foods < schema.sql`
   - App will automatically show updated products

2. **To update app UI:**
   - Edit files in `lib/`
   - Save file (hot reload enabled in Flutter)
   - View changes immediately in emulator

3. **To modify API:**
   - Edit `backend/server.js`
   - Restart server (Ctrl+C, then `npm start`)
   - Refresh app

### Testing

```powershell
# Run Flutter tests
flutter test

# Check for compilation errors
flutter analyze

# Build release APK
flutter build apk --release
```

---

## Performance Tips

1. **Database Queries:**
   - Products are fetched once on app startup
   - Category filtering happens in-app (no additional queries)
   - Implement pagination for large product lists (future enhancement)

2. **Image Loading:**
   - Images are loaded from `gonaturo.in` (external URLs)
   - Implement caching for offline support (future enhancement)

3. **Network:**
   - Use mock data if backend unavailable
   - Implement retry logic for failed requests

---

## Next Steps

1. ✅ Set up MySQL database
2. ✅ Configure and run backend server
3. ✅ Install Flutter dependencies
4. ✅ Run app on emulator/device
5. 🔄 Add user authentication
6. 🔄 Implement payment gateway
7. 🔄 Add order history
8. 🔄 Push notifications

---

## Support

For issues or questions:
1. Check the Troubleshooting section above
2. Review error messages in console
3. Verify all prerequisites are installed
4. Check API responses in browser

**API Test URL:** http://localhost:3000/api/products

---

## License

GoNaturo Foods Mobile App - All Rights Reserved
