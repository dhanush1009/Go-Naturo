import 'package:flutter/foundation.dart';
import '../models/product.dart';

class CartItem {
  final Product product;
  int quantity;
  final String selectedSize;
  final double selectedPrice;

  CartItem({
    required this.product,
    required this.quantity,
    required this.selectedSize,
    required this.selectedPrice,
  });

  double get totalPrice => selectedPrice * quantity;

  Map<String, dynamic> toJson() => {
    'product': product.toJson(),
    'quantity': quantity,
    'selectedSize': selectedSize,
    'selectedPrice': selectedPrice,
  };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    product: Product.fromJson(json['product']),
    quantity: json['quantity'] ?? 1,
    selectedSize: json['selectedSize'] ?? '',
    selectedPrice: json['selectedPrice']?.toDouble() ?? 0.0,
  );
}

class CartManager extends ChangeNotifier {
  static final CartManager _instance = CartManager._internal();
  factory CartManager() => _instance;
  CartManager._internal();

  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  bool isInCart(Product product, String? selectedSize) {
    return _items.any(
      (item) =>
          item.product.id == product.id &&
          (selectedSize == null || item.selectedSize == selectedSize),
    );
  }

  void addToCart(
    Product product,
    int quantity,
    String selectedSize,
    double selectedPrice,
  ) {
    final existingIndex = _items.indexWhere(
      (item) =>
          item.product.id == product.id && item.selectedSize == selectedSize,
    );

    if (existingIndex != -1) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(
        CartItem(
          product: product,
          quantity: quantity,
          selectedSize: selectedSize,
          selectedPrice: selectedPrice,
        ),
      );
    }

    notifyListeners();
  }

  void updateQuantity(int index, int quantity) {
    if (index >= 0 && index < _items.length) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = quantity;
      }
      notifyListeners();
    }
  }

  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
