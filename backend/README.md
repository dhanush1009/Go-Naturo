# GoNaturo Foods API Backend

## Setup Instructions

### 1. Install MySQL
Make sure you have MySQL installed and running on your system.

### 2. Create Database
Run the SQL schema file to create the database and tables:
```bash
mysql -u root -p < ../database/schema.sql
```

### 3. Install Dependencies
```bash
cd backend
npm install
```

### 4. Configure Environment
Copy `.env.example` to `.env` and update with your MySQL credentials:
```bash
cp .env.example .env
```

Edit `.env` file:
```
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_mysql_password
DB_NAME=gonaturo_foods
PORT=3000
```

### 5. Run the Server
```bash
# Development mode (with auto-reload)
npm run dev

# Production mode
npm start
```

The API will be available at `http://localhost:3000`

## API Endpoints

### Products
- `GET /api/products` - Get all products
- `GET /api/products?category_id=2` - Get products by category
- `GET /api/products/:id` - Get single product

### Categories
- `GET /api/categories` - Get all categories

### Cart
- `POST /api/cart` - Add to cart
- `GET /api/cart/:user_id` - Get cart items
- `DELETE /api/cart/:id` - Remove from cart

### Health Check
- `GET /health` - Check if API is running

## Example Requests

### Get all products
```bash
curl http://localhost:3000/api/products
```

### Get products by category (Oils)
```bash
curl http://localhost:3000/api/products?category_id=2
```

### Add to cart
```bash
curl -X POST http://localhost:3000/api/cart \
  -H "Content-Type: application/json" \
  -d '{"user_id":"guest","product_id":1,"quantity":1}'
```
