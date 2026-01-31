# Database Setup Instructions

Follow these steps to set up the MySQL database and backend server for the GoNaturo Foods Flutter app.

## Prerequisites

- MySQL Server 8.0 or higher
- Node.js 18.x or higher
- npm (comes with Node.js)

## Step 1: Create MySQL Database

1. Open MySQL command line or MySQL Workbench
2. Create the database:
```sql
CREATE DATABASE gonaturo_foods;
USE gonaturo_foods;
```

3. Run the schema file:
```sql
SOURCE c:/ConsitencyProject/flutter_application_1/database/schema.sql;
```

Or copy and paste the entire contents of `database/schema.sql` into MySQL Workbench and execute it.

## Step 2: Configure Backend

1. Navigate to the backend directory:
```powershell
cd c:\ConsitencyProject\flutter_application_1\backend
```

2. Create a `.env` file with your MySQL credentials:
```
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=yourpassword
DB_NAME=gonaturo_foods
PORT=3000
```

Replace `yourpassword` with your MySQL root password.

## Step 3: Install Dependencies

```powershell
npm install
```

## Step 4: Start the Backend Server

```powershell
npm start
```

You should see: `Server running on port 3000`

## Step 5: Test the API

Open a browser and visit:
- http://localhost:3000/api/products - Should return all products
- http://localhost:3000/api/categories - Should return all categories

## Step 6: Run the Flutter App

1. Make sure the backend server is running
2. Open an Android emulator or connect a device
3. Run the Flutter app:
```powershell
flutter run
```

The app will connect to the backend at `http://10.0.2.2:3000` (Android emulator default)

## Troubleshooting

### MySQL Connection Errors
- Verify MySQL service is running
- Check credentials in `.env` file
- Ensure database `gonaturo_foods` exists

### Backend Connection Errors
- Ensure backend server is running on port 3000
- Check console for any error messages
- Verify `.env` file exists and is configured correctly

### Flutter App Can't Connect
- For Android emulator, use `10.0.2.2` instead of `localhost`
- For iOS simulator, use `localhost` or `127.0.0.1`
- For physical device, use your computer's IP address (e.g., `192.168.1.100`)

To change the backend URL in Flutter, edit `lib/services/api_service.dart` and update the `baseUrl` constant.
