-- GoNaturo Foods Database Schema

-- Create Database
CREATE DATABASE IF NOT EXISTS gonaturo_foods;
USE gonaturo_foods;

-- Categories Table
CREATE TABLE IF NOT EXISTS categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    name_tamil VARCHAR(100),
    icon VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Products Table
CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    category_id INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    image_url VARCHAR(500),
    description TEXT,
    weight VARCHAR(50),
    in_stock BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE
);

-- Product Benefits Table
CREATE TABLE IF NOT EXISTS product_benefits (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    benefit VARCHAR(200) NOT NULL,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- Cart Table
CREATE TABLE IF NOT EXISTS cart (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id VARCHAR(50),
    product_id INT NOT NULL,
    quantity INT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- Insert Categories
INSERT INTO categories (name, name_tamil, icon) VALUES
('All Products', 'அனைத்து பொருட்கள்', 'grid_view'),
('Oils', 'எண்ணெய்', 'water_drop'),
('Flours', 'மாவு வகைகள்', 'grain'),
('Beauty Products', 'அழகு சாதனங்கள்', 'face'),
('Health Products', 'உடல்நலம்', 'health_and_safety'),
('Snacks', 'தின்பண்டங்கள்', 'restaurant');

-- Insert Products
INSERT INTO products (name, category_id, price, image_url, description, weight) VALUES
-- Oils
('Coconut Oil / தேங்காய் எண்ணெய்', 2, 220.00, 'https://gonaturo.in/wp-content/uploads/2020/10/gonaturo-coconut-oil.jpg', 'Pure cold-pressed coconut oil extracted from fresh coconuts', '1000ml'),
('Sesame Oil / நல்லெண்ணெய்', 2, 360.00, 'https://gonaturo.in/wp-content/uploads/2020/10/gonaturo-sesame-nallennai-oil.jpg', 'Traditional cold-pressed sesame oil (Gingelly oil)', '1000ml'),
('Groundnut Oil / கடலை எண்ணெய்', 2, 1100.00, 'https://gonaturo.in/wp-content/uploads/2020/10/gonaturo-groundnut-oil.jpg', 'Pure groundnut oil for healthy cooking', '5000ml'),

-- Flours
('Wheat Flour / கோதுமை மாவு', 3, 63.00, 'https://gonaturo.in/wp-content/uploads/2020/10/gonaturo-wheat-flour.jpg', 'Fresh stone-ground wheat flour', '1000g'),
('Rice Flour / அரிசி மாவு', 3, 49.00, 'https://gonaturo.in/wp-content/uploads/2020/10/gonaturo-rice-flour.jpg', 'Fine quality rice flour for various dishes', '500g'),
('Foxtail Millet Flour / தினை மாவு', 3, 30.00, 'https://gonaturo.in/wp-content/uploads/2020/10/gonaturo-foxtail-millet-flour.jpg', 'Nutritious foxtail millet flour', '250g'),
('Greengram Flour / பாசிப்பயிறு மாவு', 3, 46.00, 'https://gonaturo.in/wp-content/uploads/2020/10/gonaturo-greengram-flour.jpg', 'Premium quality greengram (moong dal) flour', '500g'),
('Corn Flour / சோள மாவு', 3, 40.00, 'https://gonaturo.in/wp-content/uploads/2020/10/gonaturo-corn-flour.jpg', 'Fine corn flour for cooking and baking', '250g'),
('Peanut Flour / கடலை மாவு', 3, 76.00, 'https://gonaturo.in/wp-content/uploads/2020/10/gonaturo-peanut-flour.jpg', 'Roasted peanut flour for traditional recipes', '500g'),

-- Beauty Products
('Aloe Vera Gel / கற்றாழை ஜெல்', 4, 70.00, 'https://gonaturo.in/wp-content/uploads/2020/10/marutham-herbal-aloe-vera-gel.jpg', 'Pure aloe vera gel for skin and hair', '100g'),
('Arappu Powder / அரப்பு பவுடர்', 4, 50.00, 'https://gonaturo.in/wp-content/uploads/2020/10/haiocare-arappu-Albizia-amara-powder.jpg', 'Natural hair wash powder (Albizia amara)', '250g'),
('Curcuma Aromatica / கஸ்தூரி மஞ்சள்', 4, 50.00, 'https://gonaturo.in/wp-content/uploads/2020/10/kasturi-manjal.jpg', 'Wild turmeric powder for skin care', '100g'),
('Fullers Earth / முல்தானி மிட்டி', 4, 30.00, 'https://gonaturo.in/wp-content/uploads/2020/10/marutham-multani-mitti-powder.jpg', 'Multani mitti face pack powder', '100g'),
('Face Beauty Powder / முக அழகு பவுடர்', 4, 50.00, 'https://gonaturo.in/wp-content/uploads/2020/10/magil-herbal-facebeauty-powder.jpg', 'Herbal face beauty powder', '100g'),
('Bath Powder / குளியல் பொடி', 4, 70.00, 'https://gonaturo.in/wp-content/uploads/2020/10/marutham-herbal-bathing-powder.jpg', 'Traditional herbal bathing powder', '250g'),
('Kumkumadi Thailam', 4, 115.00, 'https://gonaturo.in/wp-content/uploads/2020/10/kumkumadi-thailam.jpg', 'Ayurvedic facial oil for glowing skin', '8ml'),
('Face Wash Soundarya Aloe Vera', 4, 90.00, 'https://gonaturo.in/wp-content/uploads/2020/10/patanjali-saundarya-aloe-vera-face-wash-gel.jpg', 'Natural aloe vera face wash gel', '200ml'),

-- Health Products
('Vibhoothi / விபூதி', 5, 10.00, 'https://gonaturo.in/wp-content/uploads/2020/10/vibhooothi-thiruneeru.jpg', 'Sacred ash for religious purposes', '100g'),
('Nalangu Flour / நலங்கு மாவு', 5, 40.00, 'https://gonaturo.in/wp-content/uploads/2020/10/magil-herbal-nalangu-powder.jpg', 'Traditional herbal bath powder for ceremonies', '100g'),
('Paneer / பன்னீர்', 5, 20.00, 'https://gonaturo.in/wp-content/uploads/2020/10/paneer.jpg', 'Natural rose water (Paneer)', '200ml'),

-- Snacks
('Navathaaniya Dosai Mix / நவதானிய தோசை மிக்ஸ்', 6, 85.00, 'https://gonaturo.in/wp-content/uploads/2020/10/gonaturo-navathaaniya-dosai-mix.jpg', 'Nine millet dosai/paniyara ready mix', '500g'),
('Millet Bajji Mix / சிறுதானிய பஜ்ஜி மிக்ஸ்', 6, 60.00, 'https://gonaturo.in/wp-content/uploads/2020/10/sibre-rich-minor-millets-bajji-mix.jpg', 'Millet bajji instant mix', '250g'),
('Urad Mush Mix / உளுத்தங்கஞ்சி மிக்ஸ்', 6, 60.00, 'https://gonaturo.in/wp-content/uploads/2020/10/ulutham-kanji-readymix-urad-mush-mix.jpg', 'Traditional urad kanji ready mix', '200g'),
('Atta Flour / ஆட்டா', 3, 390.00, 'https://gonaturo.in/wp-content/uploads/2020/10/patanjali-atta.jpg', 'Premium quality wheat atta', '5000g');

-- Insert Product Benefits
INSERT INTO product_benefits (product_id, benefit) VALUES
-- Coconut Oil
(1, '100% Natural'), (1, 'Cold Pressed'), (1, 'No Preservatives'),
-- Sesame Oil
(2, 'Rich in antioxidants'), (2, 'Ayurvedic benefits'), (2, 'Cold pressed'),
-- Groundnut Oil
(3, 'Heart healthy'), (3, 'High smoke point'), (3, 'Natural'),
-- Wheat Flour
(4, 'Fiber rich'), (4, 'No additives'), (4, 'Fresh ground'),
-- Rice Flour
(5, 'Gluten-free'), (5, 'Pure'), (5, 'Fine texture'),
-- Foxtail Millet
(6, 'Diabetic friendly'), (6, 'High fiber'), (6, 'Rich in minerals'),
-- Greengram Flour
(7, 'Protein rich'), (7, 'Easy to digest'), (7, 'Fresh'),
-- Corn Flour
(8, 'Gluten-free'), (8, 'Versatile'), (8, 'Natural'),
-- Peanut Flour
(9, 'Protein rich'), (9, 'Natural flavor'), (9, 'No additives'),
-- Aloe Vera Gel
(10, 'Moisturizing'), (10, 'Soothing'), (10, 'Natural'),
-- Arappu Powder
(11, 'Chemical-free'), (11, 'Prevents hair fall'), (11, 'Traditional'),
-- Curcuma Aromatica
(12, 'Skin brightening'), (12, 'Anti-bacterial'), (12, 'Natural'),
-- Fullers Earth
(13, 'Oil control'), (13, 'Cooling'), (13, 'Deep cleansing'),
-- Face Beauty Powder
(14, 'Natural glow'), (14, 'Herbal ingredients'), (14, 'Safe'),
-- Bath Powder
(15, 'Natural fragrance'), (15, 'Skin softening'), (15, 'Chemical-free'),
-- Kumkumadi Thailam
(16, 'Anti-aging'), (16, 'Brightening'), (16, 'Ayurvedic'),
-- Face Wash
(17, 'Gentle cleansing'), (17, 'Moisturizing'), (17, 'Natural'),
-- Vibhoothi
(18, 'Pure'), (18, 'Traditional'), (18, 'Sacred'),
-- Nalangu Flour
(19, 'Herbal blend'), (19, 'Skin nourishing'), (19, 'Traditional'),
-- Paneer
(20, 'Cooling'), (20, 'Refreshing'), (20, 'Natural'),
-- Navathaaniya Dosai Mix
(21, 'Healthy'), (21, 'Instant'), (21, 'Nutritious'),
-- Millet Bajji Mix
(22, 'Healthy snack'), (22, 'Easy to make'), (22, 'Millet based'),
-- Urad Mush Mix
(23, 'Nutritious'), (23, 'Traditional'), (23, 'Easy'),
-- Atta Flour
(24, 'Whole wheat'), (24, 'Fiber rich'), (24, 'Fresh');
