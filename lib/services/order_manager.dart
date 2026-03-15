import 'package:flutter/foundation.dart';

class OrderItem {
  final String productId;
  final String name;
  final String image;
  final String size;
  final int quantity;
  final double unitPrice;

  const OrderItem({
    required this.productId,
    required this.name,
    required this.image,
    required this.size,
    required this.quantity,
    required this.unitPrice,
  });

  double get total => unitPrice * quantity;
}

class OrderRecord {
  final String orderId;
  final DateTime createdAt;
  final List<OrderItem> items;
  final String customerName;
  final String phone;
  final String address;
  final String addressType;
  final String deliveryOption;
  final String paymentMethod;
  final double itemsTotal;
  final double deliveryCharge;
  final double totalPayable;

  const OrderRecord({
    required this.orderId,
    required this.createdAt,
    required this.items,
    required this.customerName,
    required this.phone,
    required this.address,
    required this.addressType,
    required this.deliveryOption,
    required this.paymentMethod,
    required this.itemsTotal,
    required this.deliveryCharge,
    required this.totalPayable,
  });
}

class OrderManager extends ChangeNotifier {
  static final OrderManager _instance = OrderManager._internal();
  factory OrderManager() => _instance;
  OrderManager._internal();

  final List<OrderRecord> _orders = [];

  List<OrderRecord> get orders => List.unmodifiable(_orders);

  int get orderCount => _orders.length;

  List<OrderItem> get orderedItems =>
      _orders.expand((order) => order.items).toList(growable: false);

  void addOrder(OrderRecord order) {
    _orders.insert(0, order);
    notifyListeners();
  }

  void replaceOrders(List<OrderRecord> orders) {
    _orders
      ..clear()
      ..addAll(orders);
    notifyListeners();
  }

  void clearOrders({bool notify = true}) {
    _orders.clear();
    if (notify) {
      notifyListeners();
    }
  }
}
