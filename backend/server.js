const express = require('express');
const mysql = require('mysql2/promise');
const cors = require('cors');
const bcrypt = require('bcryptjs');
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

async function ensureUserStateTables() {
  await pool.query(`
    CREATE TABLE IF NOT EXISTS user_addresses (
      user_id INT PRIMARY KEY,
      full_name VARCHAR(200) NOT NULL,
      phone VARCHAR(20) NOT NULL,
      pincode VARCHAR(10) NOT NULL,
      city VARCHAR(100) NOT NULL,
      state VARCHAR(100) NOT NULL,
      house VARCHAR(255) NOT NULL,
      area VARCHAR(255) NOT NULL,
      landmark VARCHAR(255),
      address_type VARCHAR(20) DEFAULT 'Home',
      updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
    )
  `);

  await pool.query(`
    CREATE TABLE IF NOT EXISTS user_wishlist (
      id INT AUTO_INCREMENT PRIMARY KEY,
      user_id INT NOT NULL,
      product_id INT NOT NULL,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      UNIQUE KEY unique_user_wishlist (user_id, product_id),
      FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
      FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
    )
  `);

  await pool.query(`
    CREATE TABLE IF NOT EXISTS user_cart (
      id INT AUTO_INCREMENT PRIMARY KEY,
      user_id INT NOT NULL,
      product_id INT NOT NULL,
      quantity INT NOT NULL DEFAULT 1,
      size_label VARCHAR(100),
      selected_price DECIMAL(10, 2),
      updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      UNIQUE KEY unique_user_cart_item (user_id, product_id, size_label),
      FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
      FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
    )
  `);

  await pool.query(`
    CREATE TABLE IF NOT EXISTS user_orders (
      id INT AUTO_INCREMENT PRIMARY KEY,
      user_id INT NOT NULL,
      order_code VARCHAR(50) NOT NULL,
      customer_name VARCHAR(200) NOT NULL,
      phone VARCHAR(20) NOT NULL,
      address TEXT NOT NULL,
      address_type VARCHAR(20) DEFAULT 'Home',
      delivery_option VARCHAR(100),
      payment_method VARCHAR(100),
      items_total DECIMAL(10, 2) NOT NULL DEFAULT 0,
      delivery_charge DECIMAL(10, 2) NOT NULL DEFAULT 0,
      total_payable DECIMAL(10, 2) NOT NULL DEFAULT 0,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
    )
  `);

  await pool.query(`
    CREATE TABLE IF NOT EXISTS user_order_items (
      id INT AUTO_INCREMENT PRIMARY KEY,
      order_id INT NOT NULL,
      product_id INT,
      product_name VARCHAR(255) NOT NULL,
      image VARCHAR(500),
      size_label VARCHAR(100),
      quantity INT NOT NULL DEFAULT 1,
      unit_price DECIMAL(10, 2) NOT NULL DEFAULT 0,
      FOREIGN KEY (order_id) REFERENCES user_orders(id) ON DELETE CASCADE,
      FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE SET NULL
    )
  `);
}

ensureUserStateTables()
  .then(() => {
    console.log('✓ User state tables ensured');
  })
  .catch(err => {
    console.error('✗ Failed to ensure user state tables:', err.message);
  });

// =======================
// API Routes
// =======================

// ── Auth: Register ──────────────────────────────────────────
app.post('/api/auth/register', async (req, res) => {
  try {
    const { name, email, phone, password } = req.body;

    if (!name || !email || !password) {
      return res.status(400).json({ success: false, error: 'Name, email and password are required' });
    }

    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      return res.status(400).json({ success: false, error: 'Invalid email format' });
    }

    if (password.length < 6) {
      return res.status(400).json({ success: false, error: 'Password must be at least 6 characters' });
    }

    const [existing] = await pool.query('SELECT id FROM users WHERE email = ?', [email.toLowerCase()]);
    if (existing.length > 0) {
      return res.status(409).json({ success: false, error: 'Email already registered' });
    }

    const passwordHash = await bcrypt.hash(password, 10);
    const [result] = await pool.query(
      'INSERT INTO users (name, email, phone, password_hash) VALUES (?, ?, ?, ?)',
      [name.trim(), email.toLowerCase(), phone || null, passwordHash]
    );

    res.status(201).json({
      success: true,
      message: 'Account created successfully',
      data: { id: result.insertId, name: name.trim(), email: email.toLowerCase(), phone: phone || null }
    });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

// ── Auth: Login ─────────────────────────────────────────────
app.post('/api/auth/login', async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({ success: false, error: 'Email and password are required' });
    }

    const [users] = await pool.query('SELECT * FROM users WHERE email = ? AND is_active = TRUE', [email.toLowerCase()]);
    if (users.length === 0) {
      return res.status(401).json({ success: false, error: 'Invalid email or password' });
    }

    const user = users[0];
    const isMatch = await bcrypt.compare(password, user.password_hash);
    if (!isMatch) {
      return res.status(401).json({ success: false, error: 'Invalid email or password' });
    }

    res.json({
      success: true,
      message: 'Login successful',
      data: { id: user.id, name: user.name, email: user.email, phone: user.phone }
    });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

// ── Auth: Check email availability ──────────────────────────
app.get('/api/auth/check-email', async (req, res) => {
  try {
    const { email } = req.query;
    const [rows] = await pool.query('SELECT id FROM users WHERE email = ?', [email?.toLowerCase()]);
    res.json({ success: true, available: rows.length === 0 });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

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

// =======================
// Persistent User State APIs
// =======================

app.get('/api/user-state/:userId', async (req, res) => {
  try {
    const userId = Number.parseInt(req.params.userId, 10);
    if (!Number.isFinite(userId)) {
      return res.status(400).json({ success: false, error: 'Invalid user id' });
    }

    const [cartRows] = await pool.query(
      `SELECT product_id, quantity, size_label, selected_price
       FROM user_cart
       WHERE user_id = ?
       ORDER BY id DESC`,
      [userId]
    );

    const [wishlistRows] = await pool.query(
      `SELECT product_id
       FROM user_wishlist
       WHERE user_id = ?
       ORDER BY id DESC`,
      [userId]
    );

    const [addressRows] = await pool.query(
      `SELECT full_name, phone, pincode, city, state, house, area, landmark, address_type
       FROM user_addresses
       WHERE user_id = ?
       LIMIT 1`,
      [userId]
    );

    const [orderRows] = await pool.query(
      `SELECT id, order_code, customer_name, phone, address, address_type,
              delivery_option, payment_method, items_total, delivery_charge,
              total_payable, created_at
       FROM user_orders
       WHERE user_id = ?
       ORDER BY created_at DESC`,
      [userId]
    );

    const orderIds = orderRows.map(order => order.id);
    let orderItemsRows = [];
    if (orderIds.length > 0) {
      const [items] = await pool.query(
        `SELECT order_id, product_id, product_name, image, size_label, quantity, unit_price
         FROM user_order_items
         WHERE order_id IN (?)
         ORDER BY id ASC`,
        [orderIds]
      );
      orderItemsRows = items;
    }

    const ordersWithItems = orderRows.map(order => ({
      ...order,
      items: orderItemsRows.filter(item => item.order_id === order.id)
    }));

    res.json({
      success: true,
      data: {
        cart: cartRows,
        wishlist: wishlistRows,
        address: addressRows[0] || null,
        orders: ordersWithItems
      }
    });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

app.put('/api/user-state/:userId/cart', async (req, res) => {
  const connection = await pool.getConnection();
  try {
    const userId = Number.parseInt(req.params.userId, 10);
    if (!Number.isFinite(userId)) {
      return res.status(400).json({ success: false, error: 'Invalid user id' });
    }

    const items = Array.isArray(req.body?.items) ? req.body.items : [];

    await connection.beginTransaction();
    await connection.query('DELETE FROM user_cart WHERE user_id = ?', [userId]);

    for (const item of items) {
      const productId = Number.parseInt(item.product_id, 10);
      if (!Number.isFinite(productId)) continue;
      const quantity = Number.parseInt(item.quantity, 10) || 1;
      const sizeLabel = (item.size_label || '').toString();
      const selectedPrice = Number(item.selected_price || 0);

      await connection.query(
        `INSERT INTO user_cart (user_id, product_id, quantity, size_label, selected_price)
         VALUES (?, ?, ?, ?, ?)`,
        [userId, productId, quantity, sizeLabel, selectedPrice]
      );
    }

    await connection.commit();
    res.json({ success: true, message: 'Cart state saved' });
  } catch (error) {
    await connection.rollback();
    res.status(500).json({ success: false, error: error.message });
  } finally {
    connection.release();
  }
});

app.put('/api/user-state/:userId/wishlist', async (req, res) => {
  const connection = await pool.getConnection();
  try {
    const userId = Number.parseInt(req.params.userId, 10);
    if (!Number.isFinite(userId)) {
      return res.status(400).json({ success: false, error: 'Invalid user id' });
    }

    const productIds = Array.isArray(req.body?.product_ids) ? req.body.product_ids : [];

    await connection.beginTransaction();
    await connection.query('DELETE FROM user_wishlist WHERE user_id = ?', [userId]);

    for (const value of productIds) {
      const productId = Number.parseInt(value, 10);
      if (!Number.isFinite(productId)) continue;

      await connection.query(
        'INSERT INTO user_wishlist (user_id, product_id) VALUES (?, ?)',
        [userId, productId]
      );
    }

    await connection.commit();
    res.json({ success: true, message: 'Wishlist state saved' });
  } catch (error) {
    await connection.rollback();
    res.status(500).json({ success: false, error: error.message });
  } finally {
    connection.release();
  }
});

app.put('/api/user-state/:userId/address', async (req, res) => {
  try {
    const userId = Number.parseInt(req.params.userId, 10);
    if (!Number.isFinite(userId)) {
      return res.status(400).json({ success: false, error: 'Invalid user id' });
    }

    const {
      full_name,
      phone,
      pincode,
      city,
      state,
      house,
      area,
      landmark,
      address_type
    } = req.body || {};

    await pool.query(
      `INSERT INTO user_addresses
       (user_id, full_name, phone, pincode, city, state, house, area, landmark, address_type)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
       ON DUPLICATE KEY UPDATE
       full_name = VALUES(full_name),
       phone = VALUES(phone),
       pincode = VALUES(pincode),
       city = VALUES(city),
       state = VALUES(state),
       house = VALUES(house),
       area = VALUES(area),
       landmark = VALUES(landmark),
       address_type = VALUES(address_type)`,
      [
        userId,
        (full_name || '').toString(),
        (phone || '').toString(),
        (pincode || '').toString(),
        (city || '').toString(),
        (state || '').toString(),
        (house || '').toString(),
        (area || '').toString(),
        (landmark || '').toString(),
        (address_type || 'Home').toString()
      ]
    );

    res.json({ success: true, message: 'Address saved' });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

app.post('/api/user-state/:userId/orders', async (req, res) => {
  const connection = await pool.getConnection();
  try {
    const userId = Number.parseInt(req.params.userId, 10);
    if (!Number.isFinite(userId)) {
      return res.status(400).json({ success: false, error: 'Invalid user id' });
    }

    const {
      order_code,
      customer_name,
      phone,
      address,
      address_type,
      delivery_option,
      payment_method,
      items_total,
      delivery_charge,
      total_payable,
      items
    } = req.body || {};

    const orderItems = Array.isArray(items) ? items : [];

    await connection.beginTransaction();

    const [orderResult] = await connection.query(
      `INSERT INTO user_orders
       (user_id, order_code, customer_name, phone, address, address_type,
        delivery_option, payment_method, items_total, delivery_charge, total_payable)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        userId,
        (order_code || '').toString(),
        (customer_name || '').toString(),
        (phone || '').toString(),
        (address || '').toString(),
        (address_type || 'Home').toString(),
        (delivery_option || '').toString(),
        (payment_method || '').toString(),
        Number(items_total || 0),
        Number(delivery_charge || 0),
        Number(total_payable || 0)
      ]
    );

    const orderId = orderResult.insertId;

    for (const row of orderItems) {
      const productId = Number.parseInt(row.product_id, 10);
      const nullableProductId = Number.isFinite(productId) ? productId : null;

      await connection.query(
        `INSERT INTO user_order_items
         (order_id, product_id, product_name, image, size_label, quantity, unit_price)
         VALUES (?, ?, ?, ?, ?, ?, ?)`,
        [
          orderId,
          nullableProductId,
          (row.product_name || '').toString(),
          (row.image || '').toString(),
          (row.size_label || '').toString(),
          Number.parseInt(row.quantity, 10) || 1,
          Number(row.unit_price || 0)
        ]
      );
    }

    // Save/update the latest address for this user.
    const textAddress = (address || '').toString();
    const parts = textAddress.split(',').map(value => value.trim());
    const house = parts[0] || '';
    const area = parts[1] || '';
    const city = parts[2] || '';
    const stateAndPin = parts[3] || '';
    const statePinParts = stateAndPin.split('-').map(value => value.trim());
    const state = statePinParts[0] || '';
    const pincode = statePinParts[1] || '';

    await connection.query(
      `INSERT INTO user_addresses
       (user_id, full_name, phone, pincode, city, state, house, area, landmark, address_type)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
       ON DUPLICATE KEY UPDATE
       full_name = VALUES(full_name),
       phone = VALUES(phone),
       pincode = VALUES(pincode),
       city = VALUES(city),
       state = VALUES(state),
       house = VALUES(house),
       area = VALUES(area),
       landmark = VALUES(landmark),
       address_type = VALUES(address_type)`,
      [
        userId,
        (customer_name || '').toString(),
        (phone || '').toString(),
        pincode,
        city,
        state,
        house,
        area,
        '',
        (address_type || 'Home').toString()
      ]
    );

    await connection.commit();
    res.status(201).json({ success: true, message: 'Order saved', order_id: orderId });
  } catch (error) {
    await connection.rollback();
    res.status(500).json({ success: false, error: error.message });
  } finally {
    connection.release();
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
