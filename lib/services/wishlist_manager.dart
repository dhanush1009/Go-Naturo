import 'package:flutter/foundation.dart';
import '../models/product.dart';

class WishlistManager extends ChangeNotifier {
  static final WishlistManager _instance = WishlistManager._internal();
  factory WishlistManager() => _instance;
  WishlistManager._internal();

  final List<Product> _items = [];

  List<Product> get items => List.unmodifiable(_items);

  int get itemCount => _items.length;

  bool isInWishlist(Product product) {
    return _items.any((item) => item.id == product.id);
  }

  void toggleWishlist(Product product) {
    final existingIndex = _items.indexWhere((item) => item.id == product.id);

    if (existingIndex != -1) {
      _items.removeAt(existingIndex);
    } else {
      _items.add(product);
    }

    notifyListeners();
  }

  void addToWishlist(Product product) {
    if (!isInWishlist(product)) {
      _items.add(product);
      notifyListeners();
    }
  }

  void removeFromWishlist(Product product) {
    _items.removeWhere((item) => item.id == product.id);
    notifyListeners();
  }

  void replaceItems(List<Product> items) {
    _items
      ..clear()
      ..addAll(items);
    notifyListeners();
  }

  void clearWishlist({bool notify = true}) {
    _items.clear();
    if (notify) {
      notifyListeners();
    }
  }
}
