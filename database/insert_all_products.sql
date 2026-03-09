-- Insert All Products from Flutter App to MySQL Database
-- GoNaturo Foods - Complete Product Data Migration
-- Total: 110 Products

USE gonaturo_foods;

-- Clear existing data (optional - comment out if you want to keep existing data)
-- DELETE FROM product_benefits;
-- DELETE FROM products;

-- Map category names to IDs:
-- 1: All Products, 2: Oils, 3: Flours, 4: Beauty Products, 5: Health Products, 6: Snacks

-- ============================================
-- OILS CATEGORY (25 Products, IDs 1-25)
-- ============================================

INSERT INTO products (id, name, category_id, price, image_url, description, weight, in_stock) VALUES
(1, 'Coconut Oil / தேங்காய் எண்ணெய்', 2, 220.00, 'assets/images/oils/coconut_oil.jpg', 'Pure cold-pressed coconut oil extracted from fresh, mature coconuts using traditional methods. Rich in MCT (Medium Chain Triglycerides) and lauric acid, this versatile oil is perfect for cooking, hair care, and skin nourishment. No chemicals, no preservatives, just pure natural goodness.', '1000ml', TRUE),
(2, 'Sesame Oil / நல்லெண்ணெய்', 2, 360.00, 'assets/images/oils/sesame_oil.jpg', 'Traditional cold-pressed sesame oil (Gingelly oil)', '1000ml', TRUE),
(3, 'Groundnut Oil / கடலை எண்ணெய்', 2, 1100.00, 'assets/images/oils/groundnut_oil.jpg', 'Premium quality cold-pressed groundnut (peanut) oil extracted from finest quality groundnuts. With its high smoke point and neutral flavor, it is perfect for deep frying and everyday cooking. Rich in monounsaturated fats and vitamin E, supporting heart health and overall wellness.', '5000ml', TRUE),
(4, 'Mustard Oil / கடுகு எண்ணெய்', 2, 180.00, 'assets/images/oils/mustard_oil.jpg', 'Pure cold-pressed mustard oil with natural pungent aroma and rich golden color. Widely used in traditional Indian cooking and therapeutic applications. Contains natural antibacterial properties and is rich in omega-3 fatty acids, monounsaturated fats, and vitamin E.', '500ml', TRUE),
(5, 'Castor Oil / ஆமணக்கு எண்ணெய்', 2, 140.00, 'assets/images/oils/castor_oil.jpg', 'Premium quality cold-pressed castor oil extracted from finest castor seeds. Rich in ricinoleic acid, this thick, viscous oil is highly valued for promoting hair growth, strengthening hair roots, and nourishing dry skin. A traditional remedy used for centuries in Ayurvedic and natural beauty care.', '200ml', TRUE),
(6, 'Almond Oil / பாதாம் எண்ணெய்', 2, 450.00, 'assets/images/oils/avocado_oil.jpg', 'Premium sweet almond oil extracted from finest quality almonds. Rich in vitamin E, omega-9 fatty acids, and vital nutrients. Perfect for skin care, hair nourishment, and gentle massage. Its light texture absorbs easily, making it ideal for all skin types including sensitive skin.', '100ml', TRUE),
(7, 'Sunflower Oil / சூரியகாந்தி எண்ணெய்', 2, 180.00, 'assets/images/oils/safflower_oil.jpg', 'Light and healthy sunflower oil - cold pressed for maximum nutrition', '1000ml', TRUE),
(8, 'Olive Oil / ஆலிவ் எண்ணெய்', 2, 650.00, 'assets/images/oils/olive_oil.jpg', 'Extra virgin olive oil', '500ml', TRUE),
(9, 'Neem Oil / வேப்ப எண்ணெய்', 2, 120.00, 'assets/images/oils/neem_oil.jpg', 'Medicinal neem oil for skin care', '100ml', TRUE),
(10, 'Flaxseed Oil / ஆளி விதை எண்ணெய்', 2, 380.00, 'assets/images/oils/sesame_oil.jpg', 'Omega-3 rich flaxseed oil - nature''s best source of plant-based omega-3', '250ml', TRUE),
(11, 'Rice Bran Oil / அரிசி தவிடு எண்ணெய்', 2, 220.00, 'assets/images/oils/rice_bran_oil.jpg', 'Healthy rice bran cooking oil', '1000ml', TRUE),
(12, 'Palm Oil / பனை எண்ணெய்', 2, 150.00, 'assets/images/oils/palm_oil.jpg', 'Natural palm oil for cooking', '500ml', TRUE),
(13, 'Walnut Oil / அக்ரூட் எண்ணெய்', 2, 550.00, 'assets/images/oils/grape_seed_oil.jpg', 'Premium walnut oil for health and wellness - supports brain and heart health', '200ml', TRUE),
(14, 'Avocado Oil / வெண்ணெய் பழம் எண்ணெய்', 2, 720.00, 'assets/images/oils/avocado_oil.jpg', 'Nutritious avocado oil', '250ml', TRUE),
(15, 'Pumpkin Seed Oil / பூசணி விதை எண்ணெய்', 2, 480.00, 'assets/images/oils/corn_oil.jpg', 'Nutrient-dense pumpkin seed oil - rich in zinc and essential fatty acids', '200ml', TRUE),
(16, 'Safflower Oil / குசும்பா எண்ணெய்', 2, 280.00, 'assets/images/oils/safflower_oil.jpg', 'Light and healthy safflower oil', '500ml', TRUE),
(17, 'Peanut Oil / வேர்கடலை எண்ணெய்', 2, 200.00, 'assets/images/oils/groundnut_oil.jpg', 'Pure peanut oil for everyday cooking with natural flavor', '1000ml', TRUE),
(18, 'Soybean Oil / சோயா எண்ணெய்', 2, 160.00, 'assets/images/oils/soybean_oil.jpg', 'Refined soybean cooking oil', '1000ml', TRUE),
(19, 'Corn Oil / சோள எண்ணெய்', 2, 170.00, 'assets/images/oils/corn_oil.jpg', 'Light corn oil for cooking', '1000ml', TRUE),
(20, 'Grape Seed Oil / திராட்சை விதை எண்ணெய்', 2, 490.00, 'assets/images/oils/grape_seed_oil.jpg', 'Premium grape seed oil', '250ml', TRUE),
(21, 'Sesame Oil (Small) / நல்லெண்ணெய்', 2, 190.00, 'assets/images/oils/sesame_oil.jpg', 'Small pack cold-pressed sesame oil', '500ml', TRUE),
(22, 'Coconut Oil (Small) / தேங்காய் எண்ணெய்', 2, 115.00, 'assets/images/oils/coconut_oil.jpg', 'Small pack pure cold-pressed coconut oil for daily use', '500ml', TRUE),
(23, 'Groundnut Oil (Small) / கடலை எண்ணெய்', 2, 230.00, 'assets/images/oils/groundnut_oil.jpg', 'Small pack groundnut oil - perfect size for daily cooking', '1000ml', TRUE),
(24, 'Til Oil / எள் எண்ணெய்', 2, 340.00, 'assets/images/oils/sesame_oil.jpg', 'Pure til (sesame) oil - traditional cold-pressed goodness', '1000ml', TRUE),
(25, 'Hair Oil / தலை எண்ணெய்', 2, 95.00, 'assets/images/oils/hair_oil.jpg', 'Herbal hair oil for strong hair', '100ml', TRUE);

-- ============================================
-- FLOURS CATEGORY (22 Products, IDs 26-47)
-- ============================================

INSERT INTO products (id, name, category_id, price, image_url, description, weight, in_stock) VALUES
(26, 'Wheat Flour / கோதுமை மாவு', 3, 63.00, 'assets/images/flours/quinoa_flour.jpg', 'Fresh stone-ground wheat flour - perfect for chapatis and traditional breads', '1000g', TRUE),
(27, 'Rice Flour / அரிசி மாவு', 3, 49.00, 'assets/images/flours/ragi_flour.jpg', 'Fine quality rice flour for dosas, idlis, and traditional recipes', '500g', TRUE),
(28, 'Foxtail Millet Flour / தினை மாவு', 3, 30.00, 'assets/images/flours/little_millet_flour.jpg', 'Nutritious foxtail millet flour - diabetic friendly and high in fiber', '250g', TRUE),
(29, 'Greengram Flour / பாசிப்பயிறு மாவு', 3, 46.00, 'assets/images/flours/bajra_flour.jpg', 'Premium greengram (moong dal) flour - protein rich and easily digestible', '500g', TRUE),
(30, 'Corn Flour / சோள மாவு', 3, 40.00, 'assets/images/flours/kodo_millet_flour.jpg', 'Fine corn flour - gluten-free and versatile for cooking and baking', '250g', TRUE),
(31, 'Peanut Flour / கடலை மாவு', 3, 76.00, 'assets/images/flours/quinoa_flour.jpg', 'Roasted peanut flour - protein-packed with rich, nutty flavor', '500g', TRUE),
(32, 'Atta Flour / ஆட்டா', 3, 390.00, 'assets/images/flours/bajra_flour.jpg', 'Premium whole wheat atta flour - fresh milled for maximum nutrition', '5000g', TRUE),
(33, 'Ragi Flour / கேழ்வரகு மாவு', 3, 55.00, 'assets/images/flours/ragi_flour.jpg', 'Nutritious finger millet flour', '500g', TRUE),
(34, 'Bajra Flour / கம்பு மாவு', 3, 48.00, 'assets/images/flours/bajra_flour.jpg', 'Pearl millet flour', '500g', TRUE),
(35, 'Jowar Flour / சோளம் மாவு', 3, 52.00, 'assets/images/flours/bajra_flour.jpg', 'Sorghum (jowar) flour for healthy living - gluten-free ancient grain', '500g', TRUE),
(36, 'Barley Flour / வாற்கோதுமை மாவு', 3, 68.00, 'assets/images/flours/kodo_millet_flour.jpg', 'Healthy barley flour - excellent for cholesterol management', '500g', TRUE),
(37, 'Gram Flour / கடலை மாவு', 3, 58.00, 'assets/images/flours/quinoa_flour.jpg', 'Besan gram flour (chana dal flour) - protein-rich and versatile', '500g', TRUE),
(38, 'Maida Flour / மைதா மாவு', 3, 42.00, 'assets/images/flours/ragi_flour.jpg', 'Refined wheat flour - fine texture, perfect for baking', '500g', TRUE),
(39, 'Oats Flour / ஓட்ஸ் மாவு', 3, 85.00, 'assets/images/flours/little_millet_flour.jpg', 'Healthy oats flour - heart-healthy and fiber-rich superfood', '500g', TRUE),
(40, 'Amaranth Flour / அரக்கீரை மாவு', 3, 72.00, 'assets/images/flours/bajra_flour.jpg', 'Nutritious amaranth flour - ancient grain superfood', '250g', TRUE),
(41, 'Quinoa Flour / கினோவா மாவு', 3, 180.00, 'assets/images/flours/quinoa_flour.jpg', 'Premium quinoa flour', '250g', TRUE),
(42, 'Buckwheat Flour / பீட்ரூட் மாவு', 3, 95.00, 'assets/images/flours/kodo_millet_flour.jpg', 'Healthy buckwheat flour - rich in nutrients and gluten-free', '500g', TRUE),
(43, 'Soya Flour / சோயா மாவு', 3, 65.00, 'assets/images/flours/quinoa_flour.jpg', 'Protein-rich soya flour - complete plant protein source', '500g', TRUE),
(44, 'Little Millet Flour / சாமை மாவு', 3, 45.00, 'assets/images/flours/little_millet_flour.jpg', 'Little millet flour', '250g', TRUE),
(45, 'Kodo Millet Flour / வரகு மாவு', 3, 48.00, 'assets/images/flours/kodo_millet_flour.jpg', 'Kodo millet flour', '250g', TRUE),
(46, 'Barnyard Millet Flour / குதிரைவாலி மாவு', 3, 50.00, 'assets/images/flours/little_millet_flour.jpg', 'Barnyard millet flour - lowest glycemic index among all grains', '250g', TRUE),
(47, 'Multi Grain Flour / பல தானிய மாவு', 3, 88.00, 'assets/images/flours/bajra_flour.jpg', 'Healthy multi grain flour mix - perfect blend of nutrition', '1000g', TRUE);

-- ============================================
-- BEAUTY PRODUCTS CATEGORY (23 Products, IDs 48-70)
-- ============================================

INSERT INTO products (id, name, category_id, price, image_url, description, weight, in_stock) VALUES
(48, 'Aloe Vera Gel / கற்றாழை ஜெல்', 4, 70.00, 'assets/images/beauty/cucumber_powder.jpg', 'Pure aloe vera gel for skin and hair care - natural moisturizer', '100g', TRUE),
(49, 'Arappu Powder / அரப்பு பவுடர்', 4, 50.00, 'assets/images/beauty/shikakai_powder.jpg', 'Natural hair wash powder - chemical-free alternative to shampoo', '250g', TRUE),
(50, 'Curcuma Aromatica / கஸ்தூரி மஞ்சள்', 4, 50.00, 'assets/images/beauty/curcuma_aromatica.jpg', 'Wild turmeric powder', '100g', TRUE),
(51, 'Fullers Earth / முல்தானி மிட்டி', 4, 30.00, 'assets/images/beauty/sandalwood_powder.jpg', 'Multani mitti powder - natural clay for oil control and skin cooling', '100g', TRUE),
(52, 'Face Beauty Powder / முக அழகு பவுடர்', 4, 50.00, 'assets/images/beauty/papaya_powder.jpg', 'Herbal face powder blend - natural glow enhancer', '100g', TRUE),
(53, 'Bath Powder / குளியல் பொடி', 4, 70.00, 'assets/images/beauty/amla_powder.jpg', 'Traditional bathing powder - herbal body cleanser', '250g', TRUE),
(54, 'Kumkumadi Thailam', 4, 115.00, 'assets/images/beauty/lemon_peel_powder.jpg', 'Ayurvedic facial oil - saffron-based luxury face oil', '8ml', TRUE),
(55, 'Face Wash Aloe Vera', 4, 90.00, 'assets/images/beauty/cucumber_powder.jpg', 'Aloe vera face wash - gentle cleanser for all skin types', '200ml', TRUE),
(56, 'Neem Face Pack / வேம்பு முக பூச்சு', 4, 45.00, 'assets/images/beauty/neem_face_pack.jpg', 'Neem face pack powder', '100g', TRUE),
(57, 'Sandalwood Powder / சந்தன பவுடர்', 4, 120.00, 'assets/images/beauty/sandalwood_powder.jpg', 'Pure sandalwood powder', '50g', TRUE),
(58, 'Rose Water / பன்னீர்', 4, 55.00, 'assets/images/beauty/orange_peel_powder.jpg', 'Pure rose water - natural toner and refresher', '200ml', TRUE),
(59, 'Hibiscus Powder / செம்பருத்தி பவுடர்', 4, 48.00, 'assets/images/beauty/fenugreek_powder.jpg', 'Hibiscus powder for hair - promotes growth and natural conditioning', '100g', TRUE),
(60, 'Shikakai Powder / சீயக்காய் பவுடர்', 4, 52.00, 'assets/images/beauty/shikakai_powder.jpg', 'Natural hair cleanser', '200g', TRUE),
(61, 'Amla Powder / நெல்லிக்காய் பவுடர்', 4, 45.00, 'assets/images/beauty/amla_powder.jpg', 'Amla powder for hair', '100g', TRUE),
(62, 'Reetha Powder / கொட்டை பவுடர்', 4, 48.00, 'assets/images/beauty/reetha_powder.jpg', 'Soapnut powder', '200g', TRUE),
(63, 'Henna Powder / மருதாணி பவுடர்', 4, 38.00, 'assets/images/beauty/henna_powder.jpg', 'Natural henna powder', '100g', TRUE),
(64, 'Fenugreek Powder / வெந்தய பவுடர்', 4, 42.00, 'assets/images/beauty/fenugreek_powder.jpg', 'Fenugreek for hair', '100g', TRUE),
(65, 'Orange Peel Powder / ஆரஞ்சு தோல் பவுடர்', 4, 40.00, 'assets/images/beauty/orange_peel_powder.jpg', 'Orange peel face pack', '100g', TRUE),
(66, 'Lemon Peel Powder / எலுமிச்சை தோல் பவுடர்', 4, 38.00, 'assets/images/beauty/lemon_peel_powder.jpg', 'Lemon peel powder', '100g', TRUE),
(67, 'Cucumber Powder / வெள்ளரிக்காய் பவுடர்', 4, 45.00, 'assets/images/beauty/cucumber_powder.jpg', 'Cucumber face pack', '100g', TRUE),
(68, 'Tomato Powder / தக்காளி பவுடர்', 4, 42.00, 'assets/images/beauty/papaya_powder.jpg', 'Tomato face pack powder - tan removal and skin brightening', '100g', TRUE),
(69, 'Papaya Powder / பப்பாளி பவுடர்', 4, 55.00, 'assets/images/beauty/papaya_powder.jpg', 'Papaya face pack', '100g', TRUE),
(70, 'Beetroot Powder / பீட்ரூட் பவுடர்', 4, 48.00, 'assets/images/beauty/henna_powder.jpg', 'Beetroot lip balm powder - natural lip color and nourishment', '50g', TRUE);

-- ============================================
-- HEALTH PRODUCTS CATEGORY (20 Products, IDs 71-90)
-- ============================================

INSERT INTO products (id, name, category_id, price, image_url, description, weight, in_stock) VALUES
(71, 'Vibhoothi / விபூதி', 5, 10.00, 'assets/images/health/turmeric_powder.jpg', 'Sacred ash (vibhuti) - pure and traditional', '100g', TRUE),
(72, 'Nalangu Powder / நலங்கு மாவு', 5, 40.00, 'assets/images/health/turmeric_powder.jpg', 'Traditional herbal bath powder - wedding and ceremonial use', '100g', TRUE),
(73, 'Turmeric Powder / மஞ்சள் பவுடர்', 5, 65.00, 'assets/images/health/turmeric_powder.jpg', 'Pure turmeric powder', '500g', TRUE),
(74, 'Ginger Powder / இஞ்சி பவுடர்', 5, 58.00, 'assets/images/health/ginger_powder.jpg', 'Dried ginger powder', '250g', TRUE),
(75, 'Ashwagandha Powder / அஸ்வகந்தா பவுடர்', 5, 180.00, 'assets/images/health/ashwagandha_powder.jpg', 'Ayurvedic ashwagandha', '100g', TRUE),
(76, 'Moringa Powder / முருங்கை இலை பவுடர்', 5, 95.00, 'assets/images/health/moringa_powder.jpg', 'Nutrient-rich moringa', '100g', TRUE),
(77, 'Spirulina Powder / ஸ்பிருலினா பவுடர்', 5, 320.00, 'assets/images/health/spirulina_powder.jpg', 'Premium spirulina', '100g', TRUE),
(78, 'Wheatgrass Powder / கோதுமை புல் பவுடர்', 5, 150.00, 'assets/images/health/wheatgrass_powder.jpg', 'Organic wheatgrass', '100g', TRUE),
(79, 'Giloy Powder / சீந்தில் பவுடர்', 5, 140.00, 'assets/images/health/giloy_powder.jpg', 'Immunity booster giloy', '100g', TRUE),
(80, 'Tulsi Powder / துளசி பவுடர்', 5, 68.00, 'assets/images/health/moringa_powder.jpg', 'Holy basil powder - immunity booster and respiratory support', '100g', TRUE),
(81, 'Triphala Powder / திரிபலா பவுடர்', 5, 95.00, 'assets/images/health/triphala_powder.jpg', 'Three fruit powder', '100g', TRUE),
(82, 'Neem Powder / வேப்ப இலை பவுடர்', 5, 72.00, 'assets/images/health/neem_powder.jpg', 'Neem leaf powder', '100g', TRUE),
(83, 'Brahmi Powder / பிரம்மி பவுடர்', 5, 110.00, 'assets/images/health/brahmi_powder.jpg', 'Memory enhancer brahmi', '100g', TRUE),
(84, 'Shatavari Powder / சதாவரி பவுடர்', 5, 165.00, 'assets/images/health/shatavari_powder.jpg', 'Women wellness herb', '100g', TRUE),
(85, 'Guggul Powder / குக்குல் பவுடர்', 5, 145.00, 'assets/images/health/guggul_powder.jpg', 'Cholesterol management', '100g', TRUE),
(86, 'Arjuna Powder / அர்ஜுன பவுடர்', 5, 125.00, 'assets/images/health/arjuna_powder.jpg', 'Heart health herb', '100g', TRUE),
(87, 'Punarnava Powder / முகுட்கீரை பவுடர்', 5, 135.00, 'assets/images/health/punarnava_powder.jpg', 'Kidney health herb', '100g', TRUE),
(88, 'Manjistha Powder / மஞ்சிஷ்டா பவுடர்', 5, 155.00, 'assets/images/health/manjistha_powder.jpg', 'Blood purifier', '100g', TRUE),
(89, 'Bhringraj Powder / பிருங்கராஜ் பவுடர்', 5, 88.00, 'assets/images/health/bhringraj_powder.jpg', 'Hair wellness herb', '100g', TRUE),
(90, 'Haritaki Powder / கடுக்காய் பவுடர்', 5, 75.00, 'assets/images/health/haritaki_powder.jpg', 'Digestive herb', '100g', TRUE);

-- ============================================
-- SNACKS CATEGORY (20 Products, IDs 91-110)
-- ============================================

INSERT INTO products (id, name, category_id, price, image_url, description, weight, in_stock) VALUES
(91, 'Navathaaniya Dosai Mix / நவதானிய தோசை மிக்ஸ்', 6, 85.00, 'assets/images/snacks/idli_dosa_batter.jpg', 'Nine millet dosai mix - healthy and nutritious instant mix', '500g', TRUE),
(92, 'Millet Bajji Mix / சிறுதானிய பஜ்ஜி மிக்ஸ்', 6, 60.00, 'assets/images/snacks/murukku_mix.jpg', 'Millet bajji mix - healthy alternative to regular pakoda mix', '250g', TRUE),
(93, 'Urad Mush Mix / உளுத்தங்கஞ்சி மிக்ஸ்', 6, 60.00, 'assets/images/snacks/pongal_mix.jpg', 'Urad kanji mix - traditional South Indian porridge', '200g', TRUE),
(94, 'Ragi Malt / கேழ்வரகு மால்ட்', 6, 75.00, 'assets/images/snacks/ragi_malt.jpg', 'Nutritious ragi malt', '500g', TRUE),
(95, 'Health Mix / ஹெல்த் மிக்ஸ்', 6, 95.00, 'assets/images/snacks/ragi_malt.jpg', 'Multi grain health mix - complete nutrition in one mix', '500g', TRUE),
(96, 'Sathu Maavu / சத்து மாவு', 6, 88.00, 'assets/images/snacks/halwa_mix.jpg', 'Traditional sathu maavu - energy-packed multi-grain mix', '500g', TRUE),
(97, 'Puttu Podi / புட்டு பொடி', 6, 45.00, 'assets/images/snacks/puttu_podi.jpg', 'Ready puttu powder', '500g', TRUE),
(98, 'Idli Dosa Batter / இட்லி தோசை மாவு', 6, 42.00, 'assets/images/snacks/idli_dosa_batter.jpg', 'Fresh idli dosa batter', '1000g', TRUE),
(99, 'Adai Mix / அடை மிக்ஸ்', 6, 65.00, 'assets/images/snacks/idli_dosa_batter.jpg', 'Protein-rich adai mix - healthy lentil pancake', '500g', TRUE),
(100, 'Rava Upma Mix / ரவா உப்புமா மிக்ஸ்', 6, 55.00, 'assets/images/snacks/puttu_podi.jpg', 'Instant upma mix - quick breakfast solution', '200g', TRUE),
(101, 'Pongal Mix / பொங்கல் மிக்ஸ்', 6, 58.00, 'assets/images/snacks/pongal_mix.jpg', 'Instant pongal mix', '250g', TRUE),
(102, 'Payasam Mix / பாயசம் மிக்ஸ்', 6, 68.00, 'assets/images/snacks/laddu_mix.jpg', 'Sweet payasam mix - festive dessert made easy', '200g', TRUE),
(103, 'Halwa Mix / ஹல்வா மிக்ஸ்', 6, 72.00, 'assets/images/snacks/halwa_mix.jpg', 'Instant halwa mix', '250g', TRUE),
(104, 'Murukku Mix / முறுக்கு மாவு', 6, 48.00, 'assets/images/snacks/murukku_mix.jpg', 'Crispy murukku flour', '500g', TRUE),
(105, 'Seedai Mix / சீடை மாவு', 6, 52.00, 'assets/images/snacks/murukku_mix.jpg', 'Traditional seedai flour - festive crunchy snack', '500g', TRUE),
(106, 'Laddu Mix / லட்டு மிக்ஸ்', 6, 78.00, 'assets/images/snacks/laddu_mix.jpg', 'Sweet laddu mix', '250g', TRUE),
(107, 'Appalam / அப்பளம்', 6, 38.00, 'assets/images/snacks/vadam.jpg', 'Handmade pappad - traditional sun-dried crisp', '200g', TRUE),
(108, 'Vadam / வடகம்', 6, 42.00, 'assets/images/snacks/vadam.jpg', 'Sun-dried vadam', '200g', TRUE),
(109, 'Vadagam / வத்தல்', 6, 45.00, 'assets/images/snacks/vadam.jpg', 'Spiced vadagam - traditional seasoning balls', '100g', TRUE),
(110, 'Pickle Powder / ஊறுகாய் பவுடர்', 6, 62.00, 'assets/images/snacks/pickle_powder.jpg', 'Spicy pickle powder', '200g', TRUE);

-- ============================================
-- INSERT PRODUCT BENEFITS
-- ============================================
-- Benefits for Oils  
INSERT INTO product_benefits (product_id, benefit) VALUES
-- Product 1: Coconut Oil
(1, '100% Natural'), (1, 'Cold Pressed'), (1, 'No Preservatives'), (1, 'MCT Rich'), (1, 'Multipurpose'),
-- Product 2: Sesame Oil
(2, 'Rich in antioxidants'), (2, 'Ayurvedic benefits'), (2, 'Cold pressed'),
-- Product 3: Groundnut Oil
(3, 'Heart healthy'), (3, 'High smoke point'), (3, 'Natural'), (3, 'Vitamin E Rich'), (3, 'Light Flavor'),
-- Product 4: Mustard Oil
(4, 'Antibacterial'), (4, 'Rich in omega-3'), (4, 'Traditional'), (4, 'Immune Boost'), (4, 'Warming'),
-- Product 5: Castor Oil
(5, 'Hair growth'), (5, 'Skin nourishing'), (5, 'Pure'), (5, 'Eyebrow/Eyelash Growth'), (5, 'Anti-inflammatory'),
-- Product 6: Almond Oil
(6, 'Vitamin E rich'), (6, 'Skin softening'), (6, 'Natural'), (6, 'Anti-aging'), (6, 'Hypoallergenic'),
-- Product 7: Sunflower Oil
(7, 'Low cholesterol'), (7, 'Heart healthy'), (7, 'Light'), (7, 'Vitamin E'),
-- Product 8: Olive Oil
(8, 'Mediterranean'), (8, 'Antioxidant'), (8, 'Premium'),
-- Product 9: Neem Oil
(9, 'Antibacterial'), (9, 'Skin healing'), (9, 'Natural'),
-- Product 10: Flaxseed Oil
(10, 'Omega-3'), (10, 'Heart health'), (10, 'Cold pressed'), (10, 'Anti-inflammatory'),
-- Product 11: Rice Bran Oil
(11, 'High smoke point'), (11, 'Vitamin E'), (11, 'Light'),
-- Product 12: Palm Oil
(12, 'Traditional'), (12, 'Natural'), (12, 'Pure'),
-- Product 13: Walnut Oil
(13, 'Brain health'), (13, 'Omega-3'), (13, 'Antioxidant'), (13, 'Heart healthy'),
-- Product 14: Avocado Oil
(14, 'Nutrient rich'), (14, 'Healthy fats'), (14, 'Premium'),
-- Product 15: Pumpkin Seed Oil
(15, 'Zinc rich'), (15, 'Hair health'), (15, 'Antioxidant'), (15, 'Prostate health'),
-- Product 16: Safflower Oil
(16, 'Heart healthy'), (16, 'Low saturated fat'), (16, 'Light'),
-- Product 17: Peanut Oil
(17, 'High smoke point'), (17, 'Flavorful'), (17, 'Natural'), (17, 'Versatile'),
-- Product 18: Soybean Oil
(18, 'Omega-3'), (18, 'Vitamin E'), (18, 'Light'),
-- Product 19: Corn Oil
(19, 'Light'), (19, 'Neutral flavor'), (19, 'Versatile'),
-- Product 20: Grape Seed Oil
(20, 'Light'), (20, 'High smoke point'), (20, 'Antioxidant'),
-- Product 21-25: Other Oils (simplified)
(21, 'Ayurvedic'), (21, 'Traditional'), (21, 'Cold pressed'),
(22, 'Natural'), (22, 'Cold pressed'), (22, 'Multipurpose'), (22, '100% Pure'),
(23, 'Heart healthy'), (23, 'Natural'), (23, 'Pure'), (23, 'High smoke point'),
(24, 'Traditional'), (24, 'Aromatic'), (24, 'Natural'), (24, 'Ayurvedic'),
(25, 'Hair growth'), (25, 'Herbal'), (25, 'Nourishing');

-- Benefits for Flours
INSERT INTO product_benefits (product_id, benefit) VALUES
(26, 'Fiber rich'), (26, 'No additives'), (26, 'Fresh ground'), (26, 'Whole grain'),
(27, 'Gluten-free'), (27, 'Pure'), (27, 'Fine texture'), (27, 'Easily digestible'),
(28, 'Diabetic friendly'), (28, 'High fiber'), (28, 'Minerals'), (28, 'Gluten-free'),
(29, 'Protein rich'), (29, 'Digestible'), (29, 'Fresh'), (29, 'Low GI'),
(30, 'Gluten-free'), (30, 'Versatile'), (30, 'Natural'), (30, 'Light texture'),
(31, 'Protein rich'), (31, 'Flavorful'), (31, 'Pure'), (31, 'Energy boost'),
(32, 'Whole wheat'), (32, 'Fiber rich'), (32, 'Fresh'), (32, 'No additives'),
(33, 'Calcium rich'), (33, 'Iron'), (33, 'Healthy'),
(34, 'High protein'), (34, 'Gluten-free'), (34, 'Energy'),
(35, 'Gluten-free'), (35, 'Fiber'), (35, 'Protein'), (35, 'Diabetic friendly'),
(36, 'Cholesterol'), (36, 'Fiber rich'), (36, 'Healthy'), (36, 'Heart friendly'),
(37, 'Protein'), (37, 'Gluten-free'), (37, 'Versatile'), (37, 'Skin care'),
(38, 'Fine'), (38, 'Baking'), (38, 'Smooth'), (38, 'White bread'),
(39, 'Heart health'), (39, 'Fiber'), (39, 'Protein'), (39, 'Weight management'),
(40, 'Protein'), (40, 'Gluten-free'), (40, 'Ancient grain'), (40, 'Calcium rich'),
(41, 'Complete protein'), (41, 'Gluten-free'), (41, 'Superfood'),
(42, 'Gluten-free'), (42, 'Protein'), (42, 'Fiber'), (42, 'Minerals'),
(43, 'High protein'), (43, 'Gluten-free'), (43, 'Healthy'), (43, 'Vegan protein'),
(44, 'Gluten-free'), (44, 'Fiber'), (44, 'Minerals'),
(45, 'Diabetic friendly'), (45, 'Fiber'), (45, 'Healthy'),
(46, 'Low GI'), (46, 'Fiber'), (46, 'Minerals'), (46, 'Weight management'),
(47, 'Nutrient rich'), (47, 'Fiber'), (47, 'Balanced'), (47, 'Complete nutrition');

-- Benefits for Beauty Products
INSERT INTO product_benefits (product_id, benefit) VALUES
(48, 'Moisturizing'), (48, 'Soothing'), (48, 'Natural'), (48, 'Healing'),
(49, 'Chemical-free'), (49, 'Hair fall control'), (49, 'Traditional'), (49, 'Conditioning'),
(50, 'Brightening'), (50, 'Anti-bacterial'), (50, 'Natural'),
(51, 'Oil control'), (51, 'Cooling'), (51, 'Cleansing'), (51, 'Skin brightening'),
(52, 'Glow'), (52, 'Herbal'), (52, 'Safe'), (52, 'Brightening'),
(53, 'Fragrance'), (53, 'Softening'), (53, 'Chemical-free'), (53, 'Skin nourishing'),
(54, 'Anti-aging'), (54, 'Brightening'), (54, 'Ayurvedic'), (54, 'Radiant skin'),
(55, 'Gentle'), (55, 'Moisturizing'), (55, 'Natural'), (55, 'pH balanced'),
(56, 'Acne control'), (56, 'Purifying'), (56, 'Natural'),
(57, 'Cooling'), (57, 'Brightening'), (57, 'Fragrant'),
(58, 'Toner'), (58, 'Refreshing'), (58, 'Natural'), (58, 'Soothing'),
(59, 'Hair growth'), (59, 'Conditioning'), (59, 'Natural'), (59, 'Prevents graying'),
(60, 'Gentle'), (60, 'Shine'), (60, 'Traditional'),
(61, 'Vitamin C'), (61, 'Hair health'), (61, 'Natural'),
(62, 'Natural cleanser'), (62, 'Shine'), (62, 'Gentle'),
(63, 'Hair color'), (63, 'Conditioning'), (63, 'Natural'),
(64, 'Hair growth'), (64, 'Dandruff'), (64, 'Natural'),
(65, 'Brightening'), (65, 'Vitamin C'), (65, 'Natural'),
(66, 'Brightening'), (66, 'Oil control'), (66, 'Natural'),
(67, 'Cooling'), (67, 'Hydrating'), (67, 'Soothing'),
(68, 'Tan removal'), (68, 'Brightening'), (68, 'Natural'), (68, 'Oil control'),
(69, 'Exfoliation'), (69, 'Brightening'), (69, 'Enzyme'),
(70, 'Natural color'), (70, 'Nourishing'), (70, 'Healthy'), (70, 'Lip tint');

-- Benefits for Health Products
INSERT INTO product_benefits (product_id, benefit) VALUES
(71, 'Pure'), (71, 'Traditional'), (71, 'Sacred'), (71, 'Spiritual'),
(72, 'Herbal'), (72, 'Nourishing'), (72, 'Traditional'), (72, 'Skin glow'),
(73, 'Anti-inflammatory'), (73, 'Immunity'), (73, 'Antioxidant'),
(74, 'Digestion'), (74, 'Immunity'), (74, 'Natural'),
(75, 'Stress relief'), (75, 'Energy'), (75, 'Adaptogen'),
(76, 'Vitamins'), (76, 'Minerals'), (76, 'Superfood'),
(77, 'Protein'), (77, 'Antioxidant'), (77, 'Energy'),
(78, 'Detox'), (78, 'Chlorophyll'), (78, 'Alkaline'),
(79, 'Immunity'), (79, 'Fever'), (79, 'Ayurvedic'),
(80, 'Immunity'), (80, 'Respiratory'), (80, 'Sacred'), (80, 'Adaptogen'),
(81, 'Digestion'), (81, 'Detox'), (81, 'Ayurvedic'),
(82, 'Blood purifier'), (82, 'Immunity'), (82, 'Natural'),
(83, 'Memory'), (83, 'Brain health'), (83, 'Ayurvedic'),
(84, 'Hormonal'), (84, 'Energy'), (84, 'Ayurvedic'),
(85, 'Cholesterol'), (85, 'Joints'), (85, 'Ayurvedic'),
(86, 'Heart'), (86, 'BP'), (86, 'Ayurvedic'),
(87, 'Kidney'), (87, 'Diuretic'), (87, 'Ayurvedic'),
(88, 'Skin'), (88, 'Blood'), (88, 'Ayurvedic'),
(89, 'Hair'), (89, 'Liver'), (89, 'Ayurvedic'),
(90, 'Digestion'), (90, 'Detox'), (90, 'Ayurvedic');

-- Benefits for Snacks
INSERT INTO product_benefits (product_id, benefit) VALUES
(91, 'Healthy'), (91, 'Instant'), (91, 'Nutritious'), (91, 'Multi-grain'),
(92, 'Healthy'), (92, 'Easy'), (92, 'Millet'), (92, 'Instant'),
(93, 'Nutritious'), (93, 'Traditional'), (93, 'Easy'), (93, 'Protein rich'),
(94, 'Calcium'), (94, 'Energy'), (94, 'Healthy'),
(95, 'Nutritious'), (95, 'Balanced'), (95, 'Energy'), (95, 'All ages'),
(96, 'Protein'), (96, 'Energy'), (96, 'Traditional'), (96, 'Baby food'),
(97, 'Instant'), (97, 'Traditional'), (97, 'Easy'),
(98, 'Fresh'), (98, 'Traditional'), (98, 'Fermented'),
(99, 'Protein'), (99, 'Healthy'), (99, 'Traditional'), (99, 'Filling'),
(100, 'Quick'), (100, 'Easy'), (100, 'Tasty'), (100, 'Ready in minutes'),
(101, 'Traditional'), (101, 'Easy'), (101, 'Nutritious'),
(102, 'Festive'), (102, 'Sweet'), (102, 'Traditional'), (102, 'Easy'),
(103, 'Sweet'), (103, 'Easy'), (103, 'Tasty'),
(104, 'Traditional'), (104, 'Festive'), (104, 'Crispy'),
(105, 'Festive'), (105, 'Traditional'), (105, 'Crispy'), (105, 'Diwali special'),
(106, 'Energy'), (106, 'Sweet'), (106, 'Festive'),
(107, 'Traditional'), (107, 'Crispy'), (107, 'Handmade'), (107, 'Side dish'),
(108, 'Traditional'), (108, 'Crunchy'), (108, 'Natural'),
(109, 'Flavor'), (109, 'Traditional'), (109, 'Digestive'), (109, 'Aromatic'),
(110, 'Spicy'), (110, 'Traditional'), (110, 'Flavorful');

-- ============================================
-- COMPLETION MESSAGE
-- ============================================
SELECT '============================================' AS '';
SELECT 'DATA MIGRATION COMPLETED SUCCESSFULLY!' AS '';
SELECT '============================================' AS '';
SELECT 'Total Products Inserted: 110' AS '';
SELECT 'Total Benefits Inserted: Check count in product_benefits table' AS '';
SELECT '============================================' AS '';
SELECT 'Categories Breakdown:' AS '';
SELECT '  - Oils: 25 products' AS '';
SELECT '  - Flours: 22 products' AS '';
SELECT '  - Beauty Products: 23 products' AS '';
SELECT '  - Health Products: 20 products' AS '';
SELECT '  - Snacks: 20 products' AS '';
SELECT '============================================' AS '';
