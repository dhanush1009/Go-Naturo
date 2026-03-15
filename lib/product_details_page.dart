import 'package:flutter/material.dart';
import 'models/product.dart';
import 'services/auth_manager.dart';
import 'services/cart_manager.dart';
import 'services/wishlist_manager.dart';
import 'services/user_state_service.dart';
import 'theme/app_colors.dart';
import 'login_page.dart';
import 'pages/checkout_page.dart';

class ProductDetailsPage extends StatefulWidget {
  final Product product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage>
    with SingleTickerProviderStateMixin {
  int quantity = 1;
  int selectedSizeIndex = 0;
  late TabController _tabController;
  final CartManager _cartManager = CartManager();
  final WishlistManager _wishlistManager = WishlistManager();
  Map<String, dynamic>? _savedAddress;
  bool _addressLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _cartManager.addListener(_updateState);
    _wishlistManager.addListener(_updateState);
    _loadSavedAddress();
  }

  Future<void> _loadSavedAddress() async {
    final userId = AuthManager().userId;
    if (userId == null) {
      if (mounted) {
        setState(() {
          _savedAddress = null;
        });
      }
      return;
    }

    setState(() => _addressLoading = true);
    try {
      final address = await UserStateService.fetchSavedAddress(userId);
      if (!mounted) return;
      setState(() {
        _savedAddress = address;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _savedAddress = null;
      });
    } finally {
      if (mounted) {
        setState(() => _addressLoading = false);
      }
    }
  }

  String _addressPreview() {
    if (_savedAddress == null) {
      return 'Location not set';
    }

    final house = (_savedAddress!['house'] ?? '').toString().trim();
    final area = (_savedAddress!['area'] ?? '').toString().trim();
    final city = (_savedAddress!['city'] ?? '').toString().trim();
    final pincode = (_savedAddress!['pincode'] ?? '').toString().trim();

    final segments = <String>[];
    if (house.isNotEmpty) segments.add(house);
    if (area.isNotEmpty) segments.add(area);
    if (city.isNotEmpty) segments.add(city);
    if (pincode.isNotEmpty) segments.add(pincode);

    if (segments.isEmpty) {
      return 'Location not set';
    }
    return segments.join(', ');
  }

  void _updateState() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    _cartManager.removeListener(_updateState);
    _wishlistManager.removeListener(_updateState);
    super.dispose();
  }

  double get selectedPrice {
    if (widget.product.sizeOptions.isNotEmpty) {
      return widget.product.sizeOptions[selectedSizeIndex]['price'];
    }
    return widget.product.price;
  }

  double get selectedMrp {
    if (widget.product.sizeOptions.isNotEmpty &&
        widget.product.sizeOptions[selectedSizeIndex].containsKey('mrp')) {
      return widget.product.sizeOptions[selectedSizeIndex]['mrp'];
    }
    return widget.product.price * 1.3;
  }

  int get discountPercent {
    return (((selectedMrp - selectedPrice) / selectedMrp) * 100).round();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              _wishlistManager.isInWishlist(widget.product)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: _wishlistManager.isInWishlist(widget.product)
                  ? Colors.red
                  : Colors.black,
            ),
            onPressed: () {
              _requireLogin(() {
                setState(() {
                  _wishlistManager.toggleWishlist(widget.product);
                });
                final userId = AuthManager().userId;
                if (userId != null) {
                  UserStateService.persistWishlist(
                    userId,
                    _wishlistManager.items,
                  ).catchError((_) {});
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      _wishlistManager.isInWishlist(widget.product)
                          ? 'Added to wishlist'
                          : 'Removed from wishlist',
                    ),
                    backgroundColor:
                        _wishlistManager.isInWishlist(widget.product)
                        ? const Color(0xFF4CAF50)
                        : Colors.grey[700],
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 2),
                  ),
                );
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  _buildProductImage(),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Size Options
                        if (widget.product.sizeOptions.isNotEmpty)
                          _buildSizeOptions(),

                        const SizedBox(height: 16),

                        // Brand and Product Name
                        Text(
                          'Go-Naturo',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.product.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Hot Deal Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00C853),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Hot Deal',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Price Section
                        Row(
                          children: [
                            const Icon(
                              Icons.arrow_downward,
                              color: Color(0xFF00C853),
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$discountPercent%',
                              style: const TextStyle(
                                color: Color(0xFF00C853),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '₹${selectedMrp.toStringAsFixed(0)}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '₹${selectedPrice.toStringAsFixed(0)}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Delivery Details
                        _buildDeliveryDetails(),

                        const SizedBox(height: 16),
                        const Divider(),

                        // Product Highlights
                        _buildProductHighlights(),

                        const SizedBox(height: 16),
                        const Divider(),

                        // Tabbed Details Section
                        _buildTabbedDetails(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Action Bar
          _buildBottomActionBar(),
        ],
      ),
    );
  }

  Widget _buildProductImage() {
    return Container(
      height: 300,
      width: double.infinity,
      color: Colors.grey[100],
      child: Hero(
        tag: 'product_${widget.product.id}',
        child: widget.product.image.startsWith('http')
            ? Image.network(
                widget.product.imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image, size: 100, color: Colors.grey);
                },
              )
            : Image.asset(
                widget.product.image,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image, size: 100, color: Colors.grey);
                },
              ),
      ),
    );
  }

  Widget _buildSizeOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selected Quantity: ${widget.product.sizeOptions[selectedSizeIndex]['size']}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          children: List.generate(widget.product.sizeOptions.length, (index) {
            final option = widget.product.sizeOptions[index];
            final isSelected = index == selectedSizeIndex;
            return InkWell(
              onTap: () {
                setState(() {
                  selectedSizeIndex = index;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.black : Colors.white,
                  border: Border.all(
                    color: isSelected ? Colors.black : Colors.grey[300]!,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      option['size'],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '(₹${option['price'].toStringAsFixed(0)}/${option['size'].substring(option['size'].length > 4 ? option['size'].length - 4 : 0)})',
                      style: TextStyle(
                        fontSize: 11,
                        color: isSelected ? Colors.white70 : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildDeliveryDetails() {
    final hasAddress = _savedAddress != null;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Delivery details',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _addressLoading ? 'Loading address...' : _addressPreview(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: hasAddress ? FontWeight.w500 : FontWeight.w400,
                  ),
                ),
              ),
              Text(
                hasAddress ? 'Saved address' : 'Select delivery location',
                style: TextStyle(
                  color: Colors.blue[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.local_shipping_outlined, size: 20),
              const SizedBox(width: 8),
              Text(
                'Delivery by ${_getDeliveryDate()}',
                style: TextStyle(color: Colors.grey[700]),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.verified_outlined,
                size: 20,
                color: Colors.green,
              ),
              const SizedBox(width: 8),
              const Text(
                'Fulfilled by Go-Naturo',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductHighlights() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Product highlights',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.keyboard_arrow_up),
              onPressed: () {},
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildHighlightRow('Product Type', _getProductType()),
        const SizedBox(height: 8),
        _buildHighlightRow('Applied For', widget.product.suitableFor),
        const SizedBox(height: 8),
        _buildHighlightRow('Category', widget.product.category),
        const SizedBox(height: 8),
        _buildHighlightRow('Net Quantity', widget.product.weight),
        const SizedBox(height: 8),
        _buildHighlightRow('Expiry Date', widget.product.expiryDate),
      ],
    );
  }

  Widget _buildHighlightRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Widget _buildTabbedDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'All details',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF4CAF50),
          tabs: const [
            Tab(text: 'Showcase'),
            Tab(text: 'How to Use'),
            Tab(text: 'Ingredients'),
            Tab(text: 'Benefits'),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildShowcaseTab(),
              _buildHowToUseTab(),
              _buildIngredientsTab(),
              _buildBenefitsTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildShowcaseTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.product.description,
            style: const TextStyle(fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 12),
          if (widget.product.inStock)
            const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 18),
                SizedBox(width: 8),
                Text(
                  'In Stock - Ready to Ship',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            )
          else
            const Row(
              children: [
                Icon(Icons.cancel, color: Colors.red, size: 18),
                SizedBox(width: 8),
                Text(
                  'Currently Out of Stock',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildHowToUseTab() {
    return SingleChildScrollView(
      child: widget.product.howToUse.isNotEmpty
          ? Text(
              widget.product.howToUse,
              style: const TextStyle(fontSize: 14, height: 1.5),
            )
          : const Text(
              'Usage instructions coming soon.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
    );
  }

  Widget _buildIngredientsTab() {
    return SingleChildScrollView(
      child: widget.product.ingredients.isNotEmpty
          ? Text(
              widget.product.ingredients,
              style: const TextStyle(fontSize: 14, height: 1.5),
            )
          : const Text(
              'Ingredient information coming soon.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
    );
  }

  Widget _buildBenefitsTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.product.benefits
            .map(
              (benefit) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Color(0xFF4CAF50),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        benefit,
                        style: const TextStyle(fontSize: 14, height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: widget.product.inStock
                  ? () {
                      _requireLogin(() {
                        final sizeLabel = widget.product.sizeOptions.isNotEmpty
                            ? widget
                                  .product
                                  .sizeOptions[selectedSizeIndex]['size']
                            : widget.product.weight;

                        _cartManager.addToCart(
                          widget.product,
                          quantity,
                          sizeLabel,
                          selectedPrice,
                        );

                        final userId = AuthManager().userId;
                        if (userId != null) {
                          UserStateService.persistCart(
                            userId,
                            _cartManager.items,
                          ).catchError((_) {});
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Added ${widget.product.name} ($sizeLabel) to cart',
                            ),
                            backgroundColor: const Color(0xFF4CAF50),
                            behavior: SnackBarBehavior.floating,
                            action: SnackBarAction(
                              label: 'VIEW CART',
                              textColor: Colors.white,
                              onPressed: () {
                                Navigator.pushNamed(context, '/cart');
                              },
                            ),
                          ),
                        );
                      });
                    }
                  : null,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: BorderSide(color: Colors.grey[400]!),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: const Text(
                'Add to cart',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: widget.product.inStock
                  ? () {
                      _requireLogin(() {
                        final sizeLabel = widget.product.sizeOptions.isNotEmpty
                            ? widget
                                  .product
                                  .sizeOptions[selectedSizeIndex]['size']
                            : widget.product.weight;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CheckoutPage(
                              saveOrderedItemsToCart: true,
                              items: [
                                CheckoutItem(
                                  productId: widget.product.id.toString(),
                                  name: widget.product.name,
                                  image: widget.product.image,
                                  size: sizeLabel,
                                  quantity: quantity,
                                  unitPrice: selectedPrice,
                                ),
                              ],
                            ),
                          ),
                        ).then((_) {
                          _loadSavedAddress();
                        });
                      });
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: kBrandGreen,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: Text(
                'Buy at ₹${selectedPrice.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getDeliveryDate() {
    final now = DateTime.now();
    final deliveryDate = now.add(const Duration(days: 4));
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${deliveryDate.day} ${months[deliveryDate.month - 1]}, ${weekdays[deliveryDate.weekday - 1]}';
  }

  String _getProductType() {
    if (widget.product.category.contains('Oil')) return 'Oil';
    if (widget.product.category.contains('Flour')) return 'Flour/Powder';
    if (widget.product.category.contains('Beauty')) return 'Beauty Product';
    if (widget.product.category.contains('Health')) return 'Health Supplement';
    if (widget.product.category.contains('Snack')) return 'Food/Snack Mix';
    return 'Natural Product';
  }
}
