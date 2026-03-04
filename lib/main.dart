import 'package:flutter/material.dart';
import 'product_details_page.dart';
import 'models/product.dart';
import 'services/api_service.dart';
import 'services/cart_manager.dart';
import 'services/wishlist_manager.dart';
import 'data/product_data.dart';
import 'pages/shops_page.dart';
import 'pages/brands_page.dart';
import 'pages/about_page.dart';
import 'pages/contact_page.dart';
import 'pages/cart_page.dart';
import 'pages/wishlist_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:video_player/video_player.dart';

void main() {
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
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4CAF50)),
        useMaterial3: true,
        primaryColor: const Color(0xFF4CAF50),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 1,
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
      isLoading = true;
    });
    Navigator.pop(context);
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() => isLoading = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentPageIndex == 0
          ? AppBar(
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
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
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
                          MaterialPageRoute(
                            builder: (context) => const CartPage(),
                          ),
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
                      MaterialPageRoute(
                        builder: (context) => const WishlistPage(),
                      ),
                    );
                  },
                ),
              ],
            )
          : null,
      drawer: _currentPageIndex == 0
          ? Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: const BoxDecoration(color: Color(0xFF4CAF50)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Icon(Icons.eco, color: Colors.white, size: 48),
                        const SizedBox(height: 8),
                        const Text(
                          'Category',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
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

          // Categories Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Shop by Category',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (selectedCategory != 'All Category')
                      TextButton(
                        onPressed: () => _onCategorySelected('All Category'),
                        child: const Text('Clear Filter'),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildCategoryCard(
                        'Soaps',
                        Icons.soap,
                        Colors.blue.shade100,
                      ),
                      _buildCategoryCard(
                        'Oils',
                        Icons.water_drop,
                        Colors.green.shade100,
                      ),
                      _buildCategoryCard(
                        'Cosmetics',
                        Icons.face,
                        Colors.pink.shade100,
                      ),
                      _buildCategoryCard(
                        'Shampoos',
                        Icons.local_drink,
                        Colors.purple.shade100,
                      ),
                      _buildCategoryCard(
                        'Cleaners',
                        Icons.cleaning_services,
                        Colors.orange.shade100,
                      ),
                      _buildCategoryCard(
                        'Health Products',
                        Icons.health_and_safety,
                        Colors.teal.shade100,
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
                            childAspectRatio: 0.7,
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

  Widget _buildCategoryCard(String name, IconData icon, Color color) {
    final bool isSelected = selectedCategory == name;
    return GestureDetector(
      onTap: () => _onCategorySelected(name),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 120,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4CAF50) : color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF4CAF50).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? Colors.white : Colors.black87,
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product, int index) {
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
                    children: [
                      Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '₹${product.price.toStringAsFixed(0)}',
                            style: const TextStyle(
                              color: Color(0xFF4CAF50),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              // Add to cart functionality
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
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  // List of slide items with images and videos
  final List<SlideItem> slideItems = [
    SlideItem(
      type: SlideType.image,
      url:
          'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=800&q=80',
      title: 'Why you Purchase',
      subtitle: 'in GoNaturo Foods?',
      description: 'Natural • Organic • Traditional',
    ),
    SlideItem(
      type: SlideType.image,
      url:
          'https://images.unsplash.com/photo-1498579809087-ef1e558fd1da?w=800&q=80',
      title: '100% Organic',
      subtitle: 'Farm Fresh Products',
      description: 'Direct from Farm to Your Home',
    ),
    SlideItem(
      type: SlideType.image,
      url:
          'https://images.unsplash.com/photo-1542838132-92c53300491e?w=800&q=80',
      title: 'Traditional Foods',
      subtitle: 'Authentic Taste',
      description: 'Preserving Heritage Recipes',
    ),
    SlideItem(
      type: SlideType.video,
      url:
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
      title: 'Our Story',
      subtitle: 'Discover GoNaturo',
      description: 'Quality You Can Trust',
    ),
  ];

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
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            enlargeCenterPage: false,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          itemBuilder: (context, index, realIndex) {
            final item = slideItems[index];
            return SlideItemWidget(item: item);
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

  const SlideItemWidget({super.key, required this.item});

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
    _videoController = VideoPlayerController.networkUrl(
      Uri.parse(widget.item.url),
    );
    await _videoController!.initialize();
    await _videoController!.setLooping(true);
    await _videoController!.play();
    if (mounted) {
      setState(() {
        _isVideoInitialized = true;
      });
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

          // Dark overlay for better text visibility
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.6),
                  Colors.black.withOpacity(0.3),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),

          // Text Content
          Positioned(
            left: 24,
            bottom: 24,
            right: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.item.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 2),
                        blurRadius: 4,
                        color: Colors.black45,
                      ),
                    ],
                  ),
                ),
                Text(
                  widget.item.subtitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 2),
                        blurRadius: 4,
                        color: Colors.black45,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.item.description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 1),
                        blurRadius: 3,
                        color: Colors.black45,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Text(
                    'SHOP NOW',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
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
                    color: Colors.black.withOpacity(0.5),
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
