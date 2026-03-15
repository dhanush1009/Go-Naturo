import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../data/product_data.dart';
import '../models/product.dart';
import 'cart_manager.dart';
import 'order_manager.dart';
import 'wishlist_manager.dart';

class UserStateService {
  static const String _baseUrl = '${AppConfig.apiBaseUrl}/api/user-state';

  static Future<Map<String, dynamic>> fetchUserState(int userId) async {
    final response = await http
        .get(Uri.parse('$_baseUrl/$userId'))
        .timeout(const Duration(seconds: 10));

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200 && body['success'] == true) {
      return (body['data'] as Map<String, dynamic>? ?? <String, dynamic>{});
    }

    throw Exception(body['error'] ?? 'Failed to fetch user state');
  }

  static Future<void> applyUserStateToManagers(int userId) async {
    final state = await fetchUserState(userId);

    final productsById = {
      for (final product in ProductData.allProducts) product.id: product,
    };

    final cartRaw = (state['cart'] as List<dynamic>? ?? const <dynamic>[]);
    final cartItems = <CartItem>[];
    for (final entry in cartRaw) {
      final item = entry as Map<String, dynamic>;
      final productId = item['product_id'] as int?;
      if (productId == null) continue;
      final product = productsById[productId];
      if (product == null) continue;

      final quantity = (item['quantity'] as num?)?.toInt() ?? 1;
      final selectedSize = (item['size_label'] ?? product.weight).toString();
      final selectedPrice =
          (item['selected_price'] as num?)?.toDouble() ?? product.price;

      cartItems.add(
        CartItem(
          product: product,
          quantity: quantity,
          selectedSize: selectedSize,
          selectedPrice: selectedPrice,
        ),
      );
    }

    final wishlistRaw =
        (state['wishlist'] as List<dynamic>? ?? const <dynamic>[]);
    final wishlistItems = <Product>[];
    for (final entry in wishlistRaw) {
      final map = entry as Map<String, dynamic>;
      final productId = map['product_id'] as int?;
      if (productId == null) continue;
      final product = productsById[productId];
      if (product != null) wishlistItems.add(product);
    }

    final ordersRaw = (state['orders'] as List<dynamic>? ?? const <dynamic>[]);
    final orders = <OrderRecord>[];
    for (final entry in ordersRaw) {
      final map = entry as Map<String, dynamic>;
      final itemRaw = (map['items'] as List<dynamic>? ?? const <dynamic>[]);
      final orderItems = itemRaw
          .map((item) {
            final row = item as Map<String, dynamic>;
            return OrderItem(
              productId: (row['product_id'] ?? '').toString(),
              name: (row['product_name'] ?? '').toString(),
              image: (row['image'] ?? '').toString(),
              size: (row['size_label'] ?? '').toString(),
              quantity: (row['quantity'] as num?)?.toInt() ?? 1,
              unitPrice: (row['unit_price'] as num?)?.toDouble() ?? 0,
            );
          })
          .toList(growable: false);

      orders.add(
        OrderRecord(
          orderId: (map['order_code'] ?? '').toString(),
          createdAt:
              DateTime.tryParse((map['created_at'] ?? '').toString()) ??
              DateTime.now(),
          items: orderItems,
          customerName: (map['customer_name'] ?? '').toString(),
          phone: (map['phone'] ?? '').toString(),
          address: (map['address'] ?? '').toString(),
          addressType: (map['address_type'] ?? '').toString(),
          deliveryOption: (map['delivery_option'] ?? '').toString(),
          paymentMethod: (map['payment_method'] ?? '').toString(),
          itemsTotal: (map['items_total'] as num?)?.toDouble() ?? 0,
          deliveryCharge: (map['delivery_charge'] as num?)?.toDouble() ?? 0,
          totalPayable: (map['total_payable'] as num?)?.toDouble() ?? 0,
        ),
      );
    }

    CartManager().replaceItems(cartItems);
    WishlistManager().replaceItems(wishlistItems);
    OrderManager().replaceOrders(orders);
  }

  static Future<void> persistCart(int userId, List<CartItem> items) async {
    final body = {
      'items': items
          .map(
            (item) => {
              'product_id': item.product.id,
              'quantity': item.quantity,
              'size_label': item.selectedSize,
              'selected_price': item.selectedPrice,
            },
          )
          .toList(growable: false),
    };

    final response = await http
        .put(
          Uri.parse('$_baseUrl/$userId/cart'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode >= 300) {
      final map = jsonDecode(response.body) as Map<String, dynamic>;
      throw Exception(map['error'] ?? 'Failed to persist cart');
    }
  }

  static Future<void> persistWishlist(int userId, List<Product> items) async {
    final body = {
      'product_ids': items.map((item) => item.id).toList(growable: false),
    };

    final response = await http
        .put(
          Uri.parse('$_baseUrl/$userId/wishlist'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode >= 300) {
      final map = jsonDecode(response.body) as Map<String, dynamic>;
      throw Exception(map['error'] ?? 'Failed to persist wishlist');
    }
  }

  static Future<void> persistOrder(int userId, OrderRecord order) async {
    final body = {
      'order_code': order.orderId,
      'customer_name': order.customerName,
      'phone': order.phone,
      'address': order.address,
      'address_type': order.addressType,
      'delivery_option': order.deliveryOption,
      'payment_method': order.paymentMethod,
      'items_total': order.itemsTotal,
      'delivery_charge': order.deliveryCharge,
      'total_payable': order.totalPayable,
      'items': order.items
          .map(
            (item) => {
              'product_id': int.tryParse(item.productId),
              'product_name': item.name,
              'image': item.image,
              'size_label': item.size,
              'quantity': item.quantity,
              'unit_price': item.unitPrice,
            },
          )
          .toList(growable: false),
    };

    final response = await http
        .post(
          Uri.parse('$_baseUrl/$userId/orders'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode >= 300) {
      final map = jsonDecode(response.body) as Map<String, dynamic>;
      throw Exception(map['error'] ?? 'Failed to persist order');
    }
  }

  static Future<void> persistAddress(
    int userId, {
    required String fullName,
    required String phone,
    required String pincode,
    required String city,
    required String state,
    required String house,
    required String area,
    String? landmark,
    required String addressType,
  }) async {
    final body = {
      'full_name': fullName,
      'phone': phone,
      'pincode': pincode,
      'city': city,
      'state': state,
      'house': house,
      'area': area,
      'landmark': landmark ?? '',
      'address_type': addressType,
    };

    final response = await http
        .put(
          Uri.parse('$_baseUrl/$userId/address'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode >= 300) {
      final map = jsonDecode(response.body) as Map<String, dynamic>;
      throw Exception(map['error'] ?? 'Failed to persist address');
    }
  }

  static Future<Map<String, dynamic>?> fetchSavedAddress(int userId) async {
    final state = await fetchUserState(userId);
    final address = state['address'];
    if (address is Map<String, dynamic>) return address;
    return null;
  }

  static void clearLocalState() {
    CartManager().clearCart();
    WishlistManager().clearWishlist();
    OrderManager().clearOrders();
  }
}
