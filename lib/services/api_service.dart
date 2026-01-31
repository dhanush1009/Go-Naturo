import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  // Update this URL to match your backend server
  // For Android emulator, use 10.0.2.2 instead of localhost
  static const String baseUrl = 'http://10.0.2.2:3000/api';

  // Fetch all products
  static Future<List<Product>> getProducts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        // Check if response has 'data' key (from the API)
        final List<dynamic> data = jsonData['data'] ?? jsonData;
        return data.map((json) => _convertToProduct(json)).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  // Fetch products by category ID
  static Future<List<Product>> getProductsByCategory(int categoryId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products?category_id=$categoryId'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> data = jsonData['data'] ?? jsonData;
        return data.map((json) => _convertToProduct(json)).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  // Fetch all categories
  static Future<List<String>> getCategories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/categories'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> data = jsonData['data'] ?? jsonData;
        return data.map((item) => item['name'] as String).toList();
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  // Convert API response to Product model
  static Product _convertToProduct(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      tamilName: json['name_tamil'] as String? ?? '',
      category: json['category_name'] as String? ?? 'All Products',
      price: (json['price'] as num).toDouble(),
      image: json['image_url'] as String? ?? '',
      benefits:
          (json['benefits'] as List<dynamic>?)
              ?.map((benefit) => benefit.toString())
              .toList() ??
          [],
      description: json['description'] as String? ?? '',
      weight: json['weight'] as String? ?? '',
    );
  }

  // Add item to cart
  static Future<bool> addToCart({
    required int productId,
    required int quantity,
    String? userId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/cart'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user_id': userId ?? 'default_user',
          'product_id': productId,
          'quantity': quantity,
        }),
      );

      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Get cart items
  static Future<List<Map<String, dynamic>>> getCartItems() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/cart'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> data = jsonData['data'] ?? jsonData;
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load cart: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching cart: $e');
    }
  }

  // Update cart item quantity
  static Future<bool> updateCartItem({
    required int cartId,
    required int quantity,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/cart/$cartId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'quantity': quantity}),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Remove item from cart
  static Future<bool> removeFromCart(int cartId) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/cart/$cartId'));

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
