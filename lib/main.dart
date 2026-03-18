import 'package:flutter/material.dart';
import 'dart:async';
import 'product_details_page.dart';
import 'models/product.dart';
import 'services/api_service.dart';
import 'services/auth_manager.dart';
import 'services/cart_manager.dart';
import 'services/wishlist_manager.dart';
import 'services/user_state_service.dart';
import 'data/product_data.dart';
import 'pages/shops_page.dart';
import 'pages/brands_page.dart';
import 'pages/about_page.dart';
import 'pages/contact_page.dart';
import 'pages/cart_page.dart';
import 'pages/profile_page.dart';
import 'pages/wishlist_page.dart';
import 'login_page.dart';
import 'theme/app_colors.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:video_player/video_player.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthManager.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GoNaturoFoods',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: kBrandGreen),
        useMaterial3: true,
        primaryColor: kBrandGreen,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 1,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kBrandGreen,
            foregroundColor: Colors.white,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: kBrandGreen,
            side: const BorderSide(color: kBrandGreen),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: kBrandGreen),
        ),
        chipTheme: ChipThemeData.fromDefaults(
          secondaryColor: kBrandGreen,
          brightness: Brightness.light,
          labelStyle: const TextStyle(color: Colors.black87),
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: kBrandGreen,
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      routes: {
        '/cart': (context) => const CartPage(),
        '/wishlist': (context) => const WishlistPage(),
      },
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  String selectedCategory = 'All Products';
  bool isLoading = true;
  late AnimationController _animationController;
  int _currentPageIndex = 0;
  final AuthManager _authManager = AuthManager();
  final CartManager _cartManager = CartManager();
  final WishlistManager _wishlistManager = WishlistManager();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<String> categories = [
    'All Products',
    'Oils',
    'Flours',
    'Beauty Products',
    'Health Products',
    'Snacks',
  ];

  // Products fetched from API or offline data
  List<Product> allProducts = [];

  List<Product> get filteredProducts {
    List<Product> products = allProducts;

    // Filter by category
    if (selectedCategory != 'All Products') {
      products = products.where((p) => p.category == selectedCategory).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      products = products.where((p) {
        final nameLower = p.name.toLowerCase();
        final categoryLower = p.category.toLowerCase();
        final descriptionLower = p.description.toLowerCase();
        final searchLower = _searchQuery.toLowerCase();

        return nameLower.contains(searchLower) ||
            categoryLower.contains(searchLower) ||
            descriptionLower.contains(searchLower);
      }).toList();
    }

    return products;
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _authManager.addListener(_updateCartState);
    _cartManager.addListener(_updateCartState);
    _wishlistManager.addListener(_updateCartState);
    _loadProducts();
  }

  void _updateCartState() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _animationController.dispose();
    _authManager.removeListener(_updateCartState);
    _cartManager.removeListener(_updateCartState);
    _wishlistManager.removeListener(_updateCartState);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    // Load offline data IMMEDIATELY for instant display
    setState(() {
      allProducts = ProductData.allProducts;
      isLoading = false;
    });
    _animationController.forward();

    // Try to fetch from API in the background (optional)
    try {
      final products = await ApiService.getProducts().timeout(
        const Duration(seconds: 3), // Short timeout to avoid long waits
      );
      if (mounted && products.isNotEmpty) {
        setState(() {
          allProducts = products;
        });
      }
    } catch (e) {
      // Silently fail - we're already showing offline products
      // No need to show error since offline data is already loaded
    }
  }

  void _onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
    });
    // Close drawer if it's open
    try {
      if (Scaffold.of(context).isDrawerOpen) {
        Navigator.pop(context);
      }
    } catch (e) {
      // Drawer not available in this context
    }
  }

  /// Shows login page if user is not logged in. After login, calls [action].
  void _requireLogin(VoidCallback action) {
    if (AuthManager().isLoggedIn) {
      action();
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => LoginPage(onLoginSuccess: action)),
    );
  }

  double? _getOriginalPrice(Product product) {
    if (product.sizeOptions.isEmpty) {
      return null;
    }

    Map<String, dynamic>? matchedOption;
    for (final option in product.sizeOptions) {
      final optionSize = (option['size'] ?? '').toString();
      if (optionSize == product.weight) {
        matchedOption = option;
        break;
      }
    }

    matchedOption ??= product.sizeOptions.first;
    final mrpValue = matchedOption['mrp'];
    if (mrpValue is num) {
      final mrp = mrpValue.toDouble();
      if (mrp > product.price) {
        return mrp;
      }
    }
    return null;
  }

  int _getDiscountPercent(double originalPrice, double salePrice) {
    if (originalPrice <= 0 || originalPrice <= salePrice) {
      return 0;
    }
    final discount = ((originalPrice - salePrice) / originalPrice) * 100;
    return discount.round();
  }

  Widget _buildCenteredStrikethroughPrice(String text, TextStyle style) {
    final lineColor = style.color ?? Colors.black54;
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Text(text, style: style.copyWith(decoration: TextDecoration.none)),
        Positioned.fill(
          child: IgnorePointer(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(height: 1, color: lineColor),
            ),
          ),
        ),
      ],
    );
  }

  List<Product> get _bestDeals {
    final sorted = [...ProductData.allProducts]
      ..sort((a, b) {
        final da = _getOriginalPrice(a);
        final db = _getOriginalPrice(b);
        final pa = da != null ? _getDiscountPercent(da, a.price) : 0;
        final pb = db != null ? _getDiscountPercent(db, b.price) : 0;
        return pb.compareTo(pa);
      });
    return sorted.take(8).toList();
  }

  List<Product> _categoryPicks(String category) => ProductData.allProducts
      .where((p) => p.category == category)
      .take(8)
      .toList();

  Widget _buildRecommendationRow(
    String title,
    String subtitle,
    List<Product> products,
    Color accentColor,
  ) {
    if (products.isEmpty) return const SizedBox.shrink();
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.only(top: 16, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 24,
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      if (subtitle.isNotEmpty)
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _searchQuery = '';
                      selectedCategory = 'All Products';
                    });
                  },
                  child: Text(
                    'View All',
                    style: TextStyle(
                      color: accentColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 248,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                final originalPrice = _getOriginalPrice(product);
                final discount = originalPrice != null
                    ? _getDiscountPercent(originalPrice, product.price)
                    : 0;
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailsPage(product: product),
                      ),
                    );
                  },
                  child: Container(
                    width: 140,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(10),
                              ),
                              child: Image.asset(
                                product.image,
                                width: 140,
                                height: 120,
                                fit: BoxFit.cover,
                                errorBuilder: (ctx, err, st) => Container(
                                  width: 140,
                                  height: 120,
                                  color: Colors.grey.shade100,
                                  child: Icon(
                                    Icons.image_not_supported,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              ),
                            ),
                            if (discount > 0)
                              Positioned(
                                top: 6,
                                left: 6,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: accentColor,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '$discount% OFF',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '₹${product.price.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: accentColor,
                                  ),
                                ),
                                if (originalPrice != null)
                                  _buildCenteredStrikethroughPrice(
                                    '₹${originalPrice.toStringAsFixed(0)}',
                                    TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                if (originalPrice != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 5,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE8F5E9),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        'SAVE ₹${(originalPrice - product.price).toStringAsFixed(0)}',
                                        style: const TextStyle(
                                          fontSize: 9,
                                          color: Color(0xFF2E7D32),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                const Spacer(),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: InkWell(
                                    onTap: () {
                                      _requireLogin(() {
                                        final selectedSize =
                                            product.weight.isNotEmpty
                                            ? product.weight
                                            : (product.sizeOptions.isNotEmpty
                                                  ? product.sizeOptions[0]['size'] ??
                                                        ''
                                                  : 'Standard');
                                        final selectedPrice = product.price;

                                        _cartManager.addToCart(
                                          product,
                                          1,
                                          selectedSize,
                                          selectedPrice,
                                        );

                                        final userId = _authManager.userId;
                                        if (userId != null) {
                                          UserStateService.persistCart(
                                            userId,
                                            _cartManager.items,
                                          ).catchError((_) {});
                                        }

                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              '${product.name} added to cart',
                                            ),
                                            duration: const Duration(
                                              seconds: 1,
                                            ),
                                            backgroundColor: const Color(
                                              0xFF4CAF50,
                                            ),
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: accentColor,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Icon(
                                        Icons.add_shopping_cart,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  AppBar? _buildAppBar() {
    switch (_currentPageIndex) {
      case 0: // Home
        return AppBar(
          title: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF00C853),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.eco, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 8),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'GoNaturoFoods',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'பசுமை அங்காடி',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CartPage()),
                    );
                  },
                ),
                if (_cartManager.itemCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${_cartManager.itemCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.favorite_border),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WishlistPage()),
                );
              },
            ),
          ],
        );
      case 1: // Shop
        return AppBar(
          title: const Text(
            'Shop by Category',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          elevation: 0,
        );
      case 2: // Brands
        return AppBar(
          title: const Text(
            'Our Brands',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          elevation: 0,
        );
      case 3: // About
        return AppBar(
          title: const Text(
            'About Us',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          elevation: 0,
        );
      case 4: // Contact
        return AppBar(
          title: const Text(
            'Contact Us',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          elevation: 0,
        );
      case 5: // Profile
        return AppBar(
          title: const Text(
            'My Profile',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          elevation: 0,
        );
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: _currentPageIndex == 0
          ? Drawer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: DrawerHeader(
                      decoration: const BoxDecoration(color: Color(0xFF4CAF50)),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Icon(
                              Icons.eco,
                              color: Colors.white,
                              size: 40,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _authManager.isLoggedIn
                                  ? _authManager.userName
                                  : 'Category',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (_authManager.isLoggedIn)
                              Text(
                                _authManager.userEmail,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              )
                            else
                              const Text(
                                'Explore organic products',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        ...categories.map(
                          (category) => ListTile(
                            leading: const Icon(Icons.category),
                            title: Text(category),
                            selected: selectedCategory == category,
                            selectedTileColor: Colors.green.shade50,
                            onTap: () => _onCategorySelected(category),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!_authManager.isLoggedIn)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginPage(),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color(0xFF2E7D32),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                          ),
                          child: const Text('Login'),
                        ),
                      ),
                    ),
                ],
              ),
            )
          : null,
      body: IndexedStack(
        index: _currentPageIndex,
        children: [
          _buildHomePage(),
          const ShopsPage(),
          const BrandsPage(),
          const AboutPage(),
          const ContactPage(),
          const ProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF4CAF50),
        unselectedItemColor: Colors.grey,
        currentIndex: _currentPageIndex,
        onTap: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Shop'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Brands'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'About'),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_mail),
            label: 'Contact',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildHomePage() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    onSubmitted: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search for Product',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  _searchController.clear();
                                  _searchQuery = '';
                                });
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _searchQuery = _searchController.text;
                    });
                    // Hide keyboard
                    FocusScope.of(context).unfocus();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF1744),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Search',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Hero Slideshow Section
          const HeroSlideshow(),

          // Recommendation: Best Deals
          if (_searchQuery.isEmpty && selectedCategory == 'All Products')
            _buildRecommendationRow(
              'Best Deals for You',
              'Top discounts on organic products',
              _bestDeals,
              const Color(0xFFFF6F00),
            ),

          // Recommendation: Oils
          if (_searchQuery.isEmpty && selectedCategory == 'All Products')
            _buildRecommendationRow(
              'Our Top Picks — Oils',
              'Pure & cold-pressed varieties',
              _categoryPicks('Oils'),
              const Color(0xFF2E7D32),
            ),

          // Recommendation: Flours
          if (_searchQuery.isEmpty && selectedCategory == 'All Products')
            _buildRecommendationRow(
              'Wholesome Flours',
              'Stone-ground & natural varieties',
              _categoryPicks('Flours'),
              const Color(0xFF6D4C41),
            ),

          // Recommendation: Health & Beauty
          if (_searchQuery.isEmpty && selectedCategory == 'All Products')
            _buildRecommendationRow(
              'Trending in Health & Beauty',
              'Top picks for your wellness',
              [
                ..._categoryPicks('Health Products'),
                ..._categoryPicks('Beauty Products'),
              ].take(8).toList(),
              const Color(0xFF7B1FA2),
            ),

          // Recommendation: Snacks
          if (_searchQuery.isEmpty && selectedCategory == 'All Products')
            _buildRecommendationRow(
              'Guilt-Free Snacks',
              'Healthy snacking made delicious',
              _categoryPicks('Snacks'),
              const Color(0xFFE53935),
            ),

          // Products Grid
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Results Header
                if (_searchQuery.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Search results for "$_searchQuery"',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _searchQuery = '';
                            });
                          },
                          icon: const Icon(Icons.close, size: 18),
                          label: const Text('Clear'),
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFFFF1744),
                          ),
                        ),
                      ],
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedCategory == 'All Products'
                          ? 'Featured Products'
                          : selectedCategory,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${filteredProducts.length} items',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (filteredProducts.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(48.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No products found',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _searchQuery.isNotEmpty
                                ? 'Try different keywords'
                                : 'No products in this category',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          if (_searchQuery.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _searchController.clear();
                                    _searchQuery = '';
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4CAF50),
                                ),
                                child: const Text('Clear Search'),
                              ),
                            ),
                        ],
                      ),
                    ),
                  )
                else
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: GridView.builder(
                      key: ValueKey(selectedCategory + _searchQuery),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.66,
                          ),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        return _buildProductCard(
                          filteredProducts[index],
                          index,
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),

          // Footer Section
          Container(
            padding: const EdgeInsets.all(24),
            color: Colors.grey.shade100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Contact Directly',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.phone, size: 20, color: Colors.grey.shade700),
                    const SizedBox(width: 8),
                    const Text('+91 73737 00200'),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.phone_in_talk,
                      size: 20,
                      color: Colors.grey.shade700,
                    ),
                    const SizedBox(width: 8),
                    const Text('04294 224446'),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.email, size: 20, color: Colors.grey.shade700),
                    const SizedBox(width: 8),
                    const Text('gonaturofoods@gmail.com'),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Visit Our Shop',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 20,
                      color: Colors.grey.shade700,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        '177, VRV Complex, Bhavani Road,\nPerundurai, Erode - 638 052',
                        style: TextStyle(height: 1.5),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Center(
                  child: Text(
                    '© GoNaturo Foods',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Product product, int index) {
    final originalPrice = _getOriginalPrice(product);
    final discountPercent = originalPrice != null
        ? _getDiscountPercent(originalPrice, product.price)
        : 0;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsPage(product: product),
          ),
        );
      },
      child: TweenAnimationBuilder<double>(
        duration: Duration(milliseconds: 300 + (index * 50)),
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: Opacity(opacity: value, child: child),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Hero(
                  tag: 'product_${product.id}',
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: product.imageUrl.startsWith('assets/')
                          ? Image.asset(
                              product.imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey.shade200,
                                  child: Center(
                                    child: Icon(
                                      Icons.shopping_basket,
                                      size: 50,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                );
                              },
                            )
                          : Image.network(
                              product.imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey.shade200,
                                  child: Center(
                                    child: Icon(
                                      Icons.shopping_basket,
                                      size: 50,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                );
                              },
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value:
                                            loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                            : null,
                                        strokeWidth: 2,
                                      ),
                                    );
                                  },
                            ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.weight,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '₹${product.price.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    color: Color(0xFF4CAF50),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                if (originalPrice != null)
                                  const SizedBox(height: 3),
                                if (originalPrice != null)
                                  Wrap(
                                    spacing: 6,
                                    runSpacing: 4,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      _buildCenteredStrikethroughPrice(
                                        '₹${originalPrice.toStringAsFixed(0)}',
                                        TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        '$discountPercent% OFF',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFFE53935),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFE8F5E9),
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: Text(
                                          'SAVE ₹${(originalPrice - product.price).toStringAsFixed(0)}',
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: Color(0xFF2E7D32),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () {
                              _requireLogin(() {
                                // Add to cart functionality
                                String selectedSize = product.weight.isNotEmpty
                                    ? product.weight
                                    : (product.sizeOptions.isNotEmpty
                                          ? product.sizeOptions[0]['size'] ?? ''
                                          : 'Standard');
                                double selectedPrice = product.price;

                                _cartManager.addToCart(
                                  product,
                                  1, // quantity
                                  selectedSize,
                                  selectedPrice,
                                );

                                final userId = _authManager.userId;
                                if (userId != null) {
                                  UserStateService.persistCart(
                                    userId,
                                    _cartManager.items,
                                  ).catchError((_) {});
                                }

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '${product.name} added to cart',
                                    ),
                                    duration: const Duration(seconds: 1),
                                    backgroundColor: const Color(0xFF4CAF50),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4CAF50),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(
                                Icons.add_shopping_cart,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Hero Slideshow Widget
class HeroSlideshow extends StatefulWidget {
  const HeroSlideshow({super.key});

  @override
  State<HeroSlideshow> createState() => _HeroSlideshowState();
}

class _HeroSlideshowState extends State<HeroSlideshow> {
  int _currentIndex = 0;
  static const Duration _videoPlayBeforeSlide = Duration(seconds: 8);
  Timer? _slideTimer;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  // List of slide items (video-only)
  final List<SlideItem> slideItems = [
    SlideItem(
      type: SlideType.video,
      url: 'assets/videos/video1.mp4',
      title: 'Fresh From Source',
      subtitle: 'Watch Quality Process',
      description: 'Trusted sourcing for every product',
    ),
    SlideItem(
      type: SlideType.video,
      url: 'assets/videos/video2.mp4',
      title: 'Packed With Care',
      subtitle: 'Hygiene First',
      description: 'Safe and clean handling from start to finish',
    ),
    SlideItem(
      type: SlideType.video,
      url: 'assets/videos/video3.mp4',
      title: 'Delivered To Home',
      subtitle: 'Fast And Fresh',
      description: 'Natural products at your doorstep',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startSlideTimer();
  }

  void _startSlideTimer() {
    _slideTimer?.cancel();
    _slideTimer = Timer(_videoPlayBeforeSlide, () {
      if (!mounted || slideItems.isEmpty) {
        return;
      }
      final nextIndex = (_currentIndex + 1) % slideItems.length;
      _carouselController.animateToPage(nextIndex);
    });
  }

  @override
  void dispose() {
    _slideTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          carouselController: _carouselController,
          itemCount: slideItems.length,
          options: CarouselOptions(
            height: 300,
            viewportFraction: 1.0,
            autoPlay: false,
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            enlargeCenterPage: false,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
              _startSlideTimer();
            },
          ),
          itemBuilder: (context, index, realIndex) {
            final item = slideItems[index];
            return SlideItemWidget(
              item: item,
              isActive: index == _currentIndex,
            );
          },
        ),
        const SizedBox(height: 12),
        // Slide indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: slideItems.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _carouselController.animateToPage(entry.key),
              child: Container(
                width: _currentIndex == entry.key ? 24 : 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: _currentIndex == entry.key
                      ? const Color(0xFF4CAF50)
                      : Colors.grey.shade300,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

// Slide Item Model
enum SlideType { image, video }

class SlideItem {
  final SlideType type;
  final String url;
  final String title;
  final String subtitle;
  final String description;

  SlideItem({
    required this.type,
    required this.url,
    required this.title,
    required this.subtitle,
    required this.description,
  });
}

// Slide Item Widget
class SlideItemWidget extends StatefulWidget {
  final SlideItem item;
  final bool isActive;

  const SlideItemWidget({
    super.key,
    required this.item,
    required this.isActive,
  });

  @override
  State<SlideItemWidget> createState() => _SlideItemWidgetState();
}

class _SlideItemWidgetState extends State<SlideItemWidget> {
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    if (widget.item.type == SlideType.video) {
      _initializeVideo();
    }
  }

  void _initializeVideo() async {
    _videoController = widget.item.url.startsWith('http')
        ? VideoPlayerController.networkUrl(Uri.parse(widget.item.url))
        : VideoPlayerController.asset(widget.item.url);
    await _videoController!.initialize();
    await _videoController!.setLooping(true);
    if (mounted) {
      setState(() {
        _isVideoInitialized = true;
      });
      _syncVideoPlayback();
    }
  }

  void _syncVideoPlayback() {
    if (_videoController == null || !_isVideoInitialized) {
      return;
    }

    if (widget.isActive) {
      _videoController!.play();
    } else {
      _videoController!.pause();
    }
  }

  @override
  void didUpdateWidget(covariant SlideItemWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.item.type == SlideType.video &&
        oldWidget.isActive != widget.isActive) {
      _syncVideoPlayback();
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A237E), Color(0xFF311B92)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image or Video
          if (widget.item.type == SlideType.image)
            Image.network(
              widget.item.url,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(color: const Color(0xFF1A237E));
              },
            )
          else if (_isVideoInitialized && _videoController != null)
            FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _videoController!.value.size.width,
                height: _videoController!.value.size.height,
                child: VideoPlayer(_videoController!),
              ),
            )
          else
            Container(
              color: const Color(0xFF1A237E),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),

          // Video play/pause button
          if (widget.item.type == SlideType.video && _isVideoInitialized)
            Positioned(
              top: 16,
              right: 16,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (_videoController!.value.isPlaying) {
                      _videoController!.pause();
                    } else {
                      _videoController!.play();
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _videoController!.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
