const express = require('express');
const mysql = require('mysql2/promise');
const cors = require('cors');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// MySQL Connection Pool
const pool = mysql.createPool({
  host: process.env.DB_HOST || 'localhost',
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || '',
  database: process.env.DB_NAME || 'gonaturo_foods',
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

// Test database connection
pool.getConnection()
  .then(connection => {
    console.log('✓ MySQL Connected Successfully');
    connection.release();
  })
  .catch(err => {
    console.error('✗ MySQL Connection Error:', err.message);
  });

// =======================
// API Routes
// =======================

// Get all categories
app.get('/api/categories', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM categories ORDER BY id');
    res.json({
      success: true,
      data: rows
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

// Get all products
app.get('/api/products', async (req, res) => {
  try {
    const { category_id } = req.query;
    
    let query = `
      SELECT 
        p.*,
        c.name as category_name,
        c.name_tamil as category_name_tamil
      FROM products p
      JOIN categories c ON p.category_id = c.id
      WHERE p.in_stock = TRUE
    `;
    
    const params = [];
    
    if (category_id && category_id != '1') {
      query += ' AND p.category_id = ?';
      params.push(category_id);
    }
    
    query += ' ORDER BY p.created_at DESC';
    
    const [products] = await pool.query(query, params);
    
    // Get benefits for each product
    for (let product of products) {
      const [benefits] = await pool.query(
        'SELECT benefit FROM product_benefits WHERE product_id = ?',
        [product.id]
      );
      product.benefits = benefits.map(b => b.benefit);
    }
    
    res.json({
      success: true,
      data: products
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

// Get single product by ID
app.get('/api/products/:id', async (req, res) => {
  try {
    const { id } = req.params;
    
    const [products] = await pool.query(`
      SELECT 
        p.*,
        c.name as category_name,
        c.name_tamil as category_name_tamil
      FROM products p
      JOIN categories c ON p.category_id = c.id
      WHERE p.id = ?
    `, [id]);
    
    if (products.length === 0) {
      return res.status(404).json({
        success: false,
        error: 'Product not found'
      });
    }
    
    const product = products[0];
    
    // Get benefits
    const [benefits] = await pool.query(
      'SELECT benefit FROM product_benefits WHERE product_id = ?',
      [id]
    );
    product.benefits = benefits.map(b => b.benefit);
    
    res.json({
      success: true,
      data: product
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

// Add to cart
app.post('/api/cart', async (req, res) => {
  try {
    const { user_id, product_id, quantity } = req.body;
    
    // Check if product exists
    const [products] = await pool.query(
      'SELECT * FROM products WHERE id = ?',
      [product_id]
    );
    
    if (products.length === 0) {
      return res.status(404).json({
        success: false,
        error: 'Product not found'
      });
    }
    
    // Check if already in cart
    const [existing] = await pool.query(
      'SELECT * FROM cart WHERE user_id = ? AND product_id = ?',
      [user_id || 'guest', product_id]
    );
    
    if (existing.length > 0) {
      // Update quantity
      await pool.query(
        'UPDATE cart SET quantity = quantity + ? WHERE id = ?',
        [quantity || 1, existing[0].id]
      );
    } else {
      // Insert new
      await pool.query(
        'INSERT INTO cart (user_id, product_id, quantity) VALUES (?, ?, ?)',
        [user_id || 'guest', product_id, quantity || 1]
      );
    }
    
    res.json({
      success: true,
      message: 'Product added to cart'
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

// Get cart items
app.get('/api/cart/:user_id', async (req, res) => {
  try {
    const { user_id } = req.params;
    
    const [items] = await pool.query(`
      SELECT 
        c.*,
        p.name,
        p.price,
        p.image_url,
        p.weight
      FROM cart c
      JOIN products p ON c.product_id = p.id
      WHERE c.user_id = ?
    `, [user_id || 'guest']);
    
    const total = items.reduce((sum, item) => sum + (item.price * item.quantity), 0);
    
    res.json({
      success: true,
      data: {
        items,
        total,
        count: items.length
      }
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

// Remove from cart
app.delete('/api/cart/:id', async (req, res) => {
  try {
    const { id } = req.params;
    
    await pool.query('DELETE FROM cart WHERE id = ?', [id]);
    
    res.json({
      success: true,
      message: 'Item removed from cart'
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

// Health check
app.get('/health', (req, res) => {
  res.json({
    success: true,
    message: 'GoNaturo Foods API is running',
    timestamp: new Date().toISOString()
  });
});

// Start server
app.listen(PORT, () => {
  console.log(`
  ╔════════════════════════════════════════╗
  ║   GoNaturo Foods API Server Running   ║
  ║   Port: ${PORT}                           ║
  ╚════════════════════════════════════════╝
  `);
});

module.exports = app;
