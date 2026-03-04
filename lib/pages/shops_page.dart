import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../product_details_page.dart';
import '../data/product_data.dart';

class ShopsPage extends StatefulWidget {
  final String? initialCategory;
  const ShopsPage({super.key, this.initialCategory});

  @override
  State<ShopsPage> createState() => _ShopsPageState();
}

class _ShopsPageState extends State<ShopsPage> {
  late String selectedCategory;
  bool isLoading = true;
  List<Product> allProducts = [];
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  // Filter variables
  String sortBy =
      'Relevance'; // Relevance, Price: Low to High, Price: High to Low
  double minPrice = 0;
  double maxPrice = 5000;
  bool showInStockOnly = false;
  RangeValues priceRange = const RangeValues(0, 5000);

  final List<Map<String, dynamic>> categories = [
    {'name': 'All Products', 'icon': Icons.apps, 'color': Colors.purple},
    {'name': 'Oils', 'icon': Icons.water_drop, 'color': Colors.amber},
    {'name': 'Flours', 'icon': Icons.grain, 'color': Colors.brown},
    {'name': 'Beauty Products', 'icon': Icons.face, 'color': Colors.pink},
    {
      'name': 'Health Products',
      'icon': Icons.health_and_safety,
      'color': Colors.teal,
    },
    {'name': 'Snacks', 'icon': Icons.fastfood, 'color': Colors.orange},
  ];

  List<Product> get filteredProducts {
    var products = selectedCategory == 'All Products'
        ? allProducts
        : allProducts
              .where((p) => p.category.contains(selectedCategory))
              .toList();

    if (searchQuery.isNotEmpty) {
      products = products
          .where(
            (p) =>
                p.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
                p.tamilName.toLowerCase().contains(searchQuery.toLowerCase()),
          )
          .toList();
    }

    // Apply price filter
    products = products
        .where((p) => p.price >= priceRange.start && p.price <= priceRange.end)
        .toList();

    // Apply stock filter
    if (showInStockOnly) {
      products = products.where((p) => p.inStock).toList();
    }

    // Apply sorting
    if (sortBy == 'Price: Low to High') {
      products.sort((a, b) => a.price.compareTo(b.price));
    } else if (sortBy == 'Price: High to Low') {
      products.sort((a, b) => b.price.compareTo(a.price));
    }

    return products;
  }

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.initialCategory ?? 'All Products';
    _loadProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    // Load offline data IMMEDIATELY for instant display
    setState(() {
      allProducts = ProductData.allProducts;
      isLoading = false;
    });

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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                searchQuery = '';
                              });
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                  ),
                  onChanged: (value) {
                    setState(() => searchQuery = value);
                  },
                ),
              ),
              const SizedBox(width: 8),
              // Filter button
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () => _showFilterBottomSheet(context),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),

        // Category Chips
        Container(
          height: 60,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = selectedCategory == category['name'];
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  selected: isSelected,
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        category['icon'] as IconData,
                        size: 18,
                        color: isSelected
                            ? Colors.white
                            : category['color'] as Color,
                      ),
                      const SizedBox(width: 4),
                      Text(category['name'] as String),
                    ],
                  ),
                  onSelected: (selected) {
                    setState(() {
                      selectedCategory = category['name'] as String;
                    });
                  },
                  selectedColor: const Color(0xFF4CAF50),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              );
            },
          ),
        ),

        // Sort and Filter Bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.grey[100],
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${filteredProducts.length} Products',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.sort, size: 16, color: Colors.grey[700]),
                    const SizedBox(width: 4),
                    Text(
                      sortBy,
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Products Grid
        Expanded(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : filteredProducts.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox, size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(
                        'No products found',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    return _buildProductCard(filteredProducts[index]);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsPage(product: product),
          ),
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
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
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
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.weight,
                      style: TextStyle(
                        fontSize: 10,
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
                            fontSize: 14,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(4),
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
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height * 0.75,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filters & Sort',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      setModalState(() {
                        sortBy = 'Relevance';
                        priceRange = const RangeValues(0, 5000);
                        showInStockOnly = false;
                      });
                    },
                    child: const Text('Clear All'),
                  ),
                ],
              ),
              const Divider(),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Sort By Section
                      const Text(
                        'Sort By',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children:
                            [
                              'Relevance',
                              'Price: Low to High',
                              'Price: High to Low',
                            ].map((sort) {
                              return ChoiceChip(
                                label: Text(sort),
                                selected: sortBy == sort,
                                onSelected: (selected) {
                                  setModalState(() {
                                    sortBy = sort;
                                  });
                                },
                                selectedColor: const Color(0xFF4CAF50),
                                labelStyle: TextStyle(
                                  color: sortBy == sort
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              );
                            }).toList(),
                      ),

                      const SizedBox(height: 24),

                      // Price Range Section
                      const Text(
                        'Price Range',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('₹${priceRange.start.toInt()}'),
                          Text('₹${priceRange.end.toInt()}'),
                        ],
                      ),
                      RangeSlider(
                        values: priceRange,
                        min: 0,
                        max: 5000,
                        divisions: 50,
                        activeColor: const Color(0xFF4CAF50),
                        labels: RangeLabels(
                          '₹${priceRange.start.toInt()}',
                          '₹${priceRange.end.toInt()}',
                        ),
                        onChanged: (values) {
                          setModalState(() {
                            priceRange = values;
                          });
                        },
                      ),

                      const SizedBox(height: 24),

                      // Availability Filter
                      const Text(
                        'Availability',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CheckboxListTile(
                        value: showInStockOnly,
                        onChanged: (value) {
                          setModalState(() {
                            showInStockOnly = value ?? false;
                          });
                        },
                        title: const Text('Show only in-stock items'),
                        activeColor: const Color(0xFF4CAF50),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
              ),

              // Apply Button
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      // Apply filters to main state
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Apply Filters (${filteredProducts.length} Products)',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
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
