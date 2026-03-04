class Product {
  final int id;
  final String name;
  final String tamilName;
  final String category;
  final double price;
  final String image;
  final List<String> benefits;
  final String description;
  final String weight;
  final bool inStock;
  final String howToUse;
  final String ingredients;
  final String expiryDate;
  final String manufactureDate;
  final List<Map<String, dynamic>> sizeOptions;
  final String suitableFor;

  Product({
    required this.id,
    required this.name,
    required this.tamilName,
    required this.category,
    required this.price,
    required this.image,
    required this.benefits,
    this.description = '',
    this.weight = '',
    this.inStock = true,
    this.howToUse = '',
    this.ingredients = '',
    this.expiryDate = '12 months from manufacture',
    this.manufactureDate = '',
    this.sizeOptions = const [],
    this.suitableFor = 'All',
  });

  // Getter for backward compatibility
  String get imageUrl => image;

  // Factory constructor to create Product from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      tamilName: json['tamil_name'] as String? ?? '',
      category:
          json['category_name'] as String? ??
          json['category'] as String? ??
          'All Products',
      price: (json['price'] as num).toDouble(),
      image: json['image_url'] as String? ?? '',
      benefits:
          (json['benefits'] as List<dynamic>?)
              ?.map((benefit) => benefit as String)
              .toList() ??
          [],
      description: json['description'] as String? ?? '',
      weight: json['weight'] as String? ?? '',
      inStock: json['in_stock'] as bool? ?? true,
      howToUse: json['how_to_use'] as String? ?? '',
      ingredients: json['ingredients'] as String? ?? '',
      expiryDate:
          json['expiry_date'] as String? ?? '12 months from manufacture',
      manufactureDate: json['manufacture_date'] as String? ?? '',
      sizeOptions:
          (json['size_options'] as List<dynamic>?)
              ?.map((item) => item as Map<String, dynamic>)
              .toList() ??
          [],
      suitableFor: json['suitable_for'] as String? ?? 'All',
    );
  }

  // Convert Product to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'tamil_name': tamilName,
      'category': category,
      'price': price,
      'image_url': image,
      'benefits': benefits,
      'description': description,
      'weight': weight,
      'in_stock': inStock,
      'how_to_use': howToUse,
      'ingredients': ingredients,
      'expiry_date': expiryDate,
      'manufacture_date': manufactureDate,
      'size_options': sizeOptions,
      'suitable_for': suitableFor,
    };
  }
}
