import 'package:flutter/material.dart';
import '../data/product_data.dart';
import '../services/auth_manager.dart';
import '../services/cart_manager.dart';
import '../services/order_manager.dart';
import '../services/user_state_service.dart';
import '../theme/app_colors.dart';

class CheckoutItem {
  final String productId;
  final String name;
  final String image;
  final String size;
  final int quantity;
  final double unitPrice;

  const CheckoutItem({
    required this.productId,
    required this.name,
    required this.image,
    required this.size,
    required this.quantity,
    required this.unitPrice,
  });

  double get total => unitPrice * quantity;
}

class CheckoutPage extends StatefulWidget {
  final List<CheckoutItem> items;
  final VoidCallback? onOrderPlaced;
  final bool saveOrderedItemsToCart;

  const CheckoutPage({
    super.key,
    required this.items,
    this.onOrderPlaced,
    this.saveOrderedItemsToCart = false,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _addressFormKey = GlobalKey<FormState>();
  final _paymentFormKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _houseController = TextEditingController();
  final _areaController = TextEditingController();
  final _landmarkController = TextEditingController();

  final _upiController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _cardNameController = TextEditingController();
  final _cardExpiryController = TextEditingController();
  final _cardCvvController = TextEditingController();

  int _currentStep = 0;
  String _addressType = 'Home';
  String _deliveryOption = 'Standard Delivery';
  String _paymentMethod = 'Cash on Delivery';
  bool _isPlacingOrder = false;

  @override
  void initState() {
    super.initState();
    _loadSavedAddress();
  }

  Future<void> _loadSavedAddress() async {
    final auth = AuthManager();
    final userId = auth.userId;

    if (_fullNameController.text.trim().isEmpty && auth.userName.isNotEmpty) {
      _fullNameController.text = auth.userName;
    }

    if (userId == null) return;

    try {
      final address = await UserStateService.fetchSavedAddress(userId);
      if (address == null || !mounted) return;

      _fullNameController.text =
          (address['full_name'] as String?)?.trim().isNotEmpty == true
          ? (address['full_name'] as String)
          : _fullNameController.text;
      _phoneController.text = (address['phone'] as String? ?? '').trim();
      _pincodeController.text = (address['pincode'] as String? ?? '').trim();
      _cityController.text = (address['city'] as String? ?? '').trim();
      _stateController.text = (address['state'] as String? ?? '').trim();
      _houseController.text = (address['house'] as String? ?? '').trim();
      _areaController.text = (address['area'] as String? ?? '').trim();
      _landmarkController.text = (address['landmark'] as String? ?? '').trim();
      final type = (address['address_type'] as String? ?? '').trim();
      if (type == 'Home' || type == 'Work') {
        _addressType = type;
      }
      setState(() {});
    } catch (_) {
      // Ignore address load failures; user can still continue checkout.
    }
  }

  double get _itemsTotal =>
      widget.items.fold(0, (sum, item) => sum + item.total);
  double get _deliveryCharge => _deliveryOption == 'Express Delivery' ? 49 : 0;
  double get _totalPayable => _itemsTotal + _deliveryCharge;

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _pincodeController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _houseController.dispose();
    _areaController.dispose();
    _landmarkController.dispose();
    _upiController.dispose();
    _cardNumberController.dispose();
    _cardNameController.dispose();
    _cardExpiryController.dispose();
    _cardCvvController.dispose();
    super.dispose();
  }

  String? _requiredValidator(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return '$label is required';
    }
    return null;
  }

  bool _validateCurrentStep() {
    if (_currentStep == 0) {
      return _addressFormKey.currentState?.validate() ?? false;
    }
    if (_currentStep == 2) {
      if (_paymentMethod == 'UPI') {
        return _paymentFormKey.currentState?.validate() ?? false;
      }
      if (_paymentMethod == 'Credit / Debit Card') {
        return _paymentFormKey.currentState?.validate() ?? false;
      }
    }
    return true;
  }

  Future<void> _placeOrder() async {
    if (_isPlacingOrder) return;
    setState(() => _isPlacingOrder = true);

    await Future<void>.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;
    setState(() => _isPlacingOrder = false);

    final orderId =
        'GN${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

    final address =
        '${_houseController.text.trim()}, ${_areaController.text.trim()}, '
        '${_cityController.text.trim()}, ${_stateController.text.trim()} - '
        '${_pincodeController.text.trim()}';

    final orderItems = widget.items
        .map(
          (item) => OrderItem(
            productId: item.productId,
            name: item.name,
            image: item.image,
            size: item.size,
            quantity: item.quantity,
            unitPrice: item.unitPrice,
          ),
        )
        .toList(growable: false);

    final orderRecord = OrderRecord(
      orderId: orderId,
      createdAt: DateTime.now(),
      items: orderItems,
      customerName: _fullNameController.text.trim(),
      phone: _phoneController.text.trim(),
      address: address,
      addressType: _addressType,
      deliveryOption: _deliveryOption,
      paymentMethod: _paymentMethod,
      itemsTotal: _itemsTotal,
      deliveryCharge: _deliveryCharge,
      totalPayable: _totalPayable,
    );

    OrderManager().addOrder(orderRecord);

    final userId = AuthManager().userId;
    if (userId != null) {
      try {
        await UserStateService.persistAddress(
          userId,
          fullName: _fullNameController.text.trim(),
          phone: _phoneController.text.trim(),
          pincode: _pincodeController.text.trim(),
          city: _cityController.text.trim(),
          state: _stateController.text.trim(),
          house: _houseController.text.trim(),
          area: _areaController.text.trim(),
          landmark: _landmarkController.text.trim(),
          addressType: _addressType,
        );
        await UserStateService.persistOrder(userId, orderRecord);
      } catch (_) {
        // Keep order flow successful even if sync fails for the moment.
      }
    }

    if (widget.saveOrderedItemsToCart) {
      final cartManager = CartManager();
      for (final item in widget.items) {
        final productId = int.tryParse(item.productId);
        if (productId == null) continue;

        final matches = ProductData.allProducts.where(
          (entry) => entry.id == productId,
        );
        if (matches.isEmpty) continue;

        final product = matches.first;
        cartManager.addToCart(
          product,
          item.quantity,
          item.size,
          item.unitPrice,
        );
      }

      if (userId != null) {
        UserStateService.persistCart(
          userId,
          cartManager.items,
        ).catchError((_) {});
      }
    }

    widget.onOrderPlaced?.call();

    if (!mounted) return;

    await showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Order Confirmed'),
        content: Text(
          'Your order $orderId has been placed successfully.\n\n'
          'Payment Mode: $_paymentMethod\n'
          'Total Paid: ₹${_totalPayable.toStringAsFixed(0)}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: Stepper(
        type: StepperType.vertical,
        currentStep: _currentStep,
        controlsBuilder: (context, details) {
          final isLast = _currentStep == 3;
          return Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isPlacingOrder
                        ? null
                        : () async {
                            if (!_validateCurrentStep()) return;
                            if (isLast) {
                              await _placeOrder();
                              return;
                            }
                            setState(() => _currentStep += 1);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kBrandGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: _isPlacingOrder
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(isLast ? 'Place Order' : 'Continue'),
                  ),
                ),
                const SizedBox(width: 10),
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => setState(() => _currentStep -= 1),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Back'),
                    ),
                  ),
              ],
            ),
          );
        },
        onStepTapped: (value) {
          setState(() => _currentStep = value);
        },
        steps: [
          Step(
            title: const Text('Delivery Address'),
            isActive: _currentStep >= 0,
            content: _buildAddressStep(),
          ),
          Step(
            title: const Text('Delivery Options'),
            isActive: _currentStep >= 1,
            content: _buildDeliveryStep(),
          ),
          Step(
            title: const Text('Payment Details'),
            isActive: _currentStep >= 2,
            content: _buildPaymentStep(),
          ),
          Step(
            title: const Text('Review & Confirm'),
            isActive: _currentStep >= 3,
            content: _buildReviewStep(),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressStep() {
    return Form(
      key: _addressFormKey,
      child: Column(
        children: [
          TextFormField(
            controller: _fullNameController,
            decoration: const InputDecoration(labelText: 'Full Name'),
            validator: (v) => _requiredValidator(v, 'Full name'),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            maxLength: 10,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              counterText: '',
            ),
            validator: (v) {
              final required = _requiredValidator(v, 'Phone number');
              if (required != null) return required;
              if ((v ?? '').trim().length != 10) {
                return 'Enter valid 10-digit mobile number';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _pincodeController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: const InputDecoration(
                    labelText: 'Pincode',
                    counterText: '',
                  ),
                  validator: (v) {
                    final required = _requiredValidator(v, 'Pincode');
                    if (required != null) return required;
                    if ((v ?? '').trim().length != 6) {
                      return 'Enter valid 6-digit pincode';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: _cityController,
                  decoration: const InputDecoration(labelText: 'City'),
                  validator: (v) => _requiredValidator(v, 'City'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _stateController,
            decoration: const InputDecoration(labelText: 'State'),
            validator: (v) => _requiredValidator(v, 'State'),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _houseController,
            decoration: const InputDecoration(
              labelText: 'Flat / House No / Building',
            ),
            validator: (v) => _requiredValidator(v, 'House details'),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _areaController,
            decoration: const InputDecoration(labelText: 'Area / Street'),
            validator: (v) => _requiredValidator(v, 'Area / Street'),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _landmarkController,
            decoration: const InputDecoration(labelText: 'Landmark (Optional)'),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text('Address Type:'),
              const SizedBox(width: 12),
              ChoiceChip(
                label: const Text('Home'),
                selected: _addressType == 'Home',
                onSelected: (_) => setState(() => _addressType = 'Home'),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('Work'),
                selected: _addressType == 'Work',
                onSelected: (_) => setState(() => _addressType = 'Work'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            ChoiceChip(
              label: const Text('Standard Delivery (3-5 days) - Free'),
              selected: _deliveryOption == 'Standard Delivery',
              onSelected: (_) {
                setState(() => _deliveryOption = 'Standard Delivery');
              },
            ),
            ChoiceChip(
              label: const Text('Express Delivery (1-2 days) - ₹49'),
              selected: _deliveryOption == 'Express Delivery',
              onSelected: (_) {
                setState(() => _deliveryOption = 'Express Delivery');
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentStep() {
    return Form(
      key: _paymentFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ChoiceChip(
                label: const Text('Cash on Delivery'),
                selected: _paymentMethod == 'Cash on Delivery',
                onSelected: (_) {
                  setState(() => _paymentMethod = 'Cash on Delivery');
                },
              ),
              ChoiceChip(
                label: const Text('UPI'),
                selected: _paymentMethod == 'UPI',
                onSelected: (_) {
                  setState(() => _paymentMethod = 'UPI');
                },
              ),
              ChoiceChip(
                label: const Text('Credit / Debit Card'),
                selected: _paymentMethod == 'Credit / Debit Card',
                onSelected: (_) {
                  setState(() => _paymentMethod = 'Credit / Debit Card');
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            _paymentMethod == 'Cash on Delivery'
                ? 'Pay when order arrives'
                : _paymentMethod == 'UPI'
                ? 'Google Pay / PhonePe / Paytm'
                : 'Visa, Mastercard, Rupay',
            style: TextStyle(color: Colors.grey.shade700),
          ),
          if (_paymentMethod == 'UPI') ...[
            const SizedBox(height: 8),
            TextFormField(
              controller: _upiController,
              decoration: const InputDecoration(labelText: 'UPI ID'),
              validator: (v) {
                if (_paymentMethod != 'UPI') return null;
                final required = _requiredValidator(v, 'UPI ID');
                if (required != null) return required;
                if (!(v ?? '').contains('@')) {
                  return 'Enter valid UPI ID';
                }
                return null;
              },
            ),
          ],
          if (_paymentMethod == 'Credit / Debit Card') ...[
            const SizedBox(height: 8),
            TextFormField(
              controller: _cardNumberController,
              keyboardType: TextInputType.number,
              maxLength: 16,
              decoration: const InputDecoration(
                labelText: 'Card Number',
                counterText: '',
              ),
              validator: (v) {
                if (_paymentMethod != 'Credit / Debit Card') return null;
                final required = _requiredValidator(v, 'Card number');
                if (required != null) return required;
                if ((v ?? '').trim().length < 12) {
                  return 'Enter valid card number';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _cardNameController,
              decoration: const InputDecoration(labelText: 'Name on Card'),
              validator: (v) {
                if (_paymentMethod != 'Credit / Debit Card') return null;
                return _requiredValidator(v, 'Name on card');
              },
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _cardExpiryController,
                    keyboardType: TextInputType.datetime,
                    decoration: const InputDecoration(
                      labelText: 'Expiry (MM/YY)',
                    ),
                    validator: (v) {
                      if (_paymentMethod != 'Credit / Debit Card') return null;
                      return _requiredValidator(v, 'Expiry date');
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: _cardCvvController,
                    keyboardType: TextInputType.number,
                    maxLength: 3,
                    decoration: const InputDecoration(
                      labelText: 'CVV',
                      counterText: '',
                    ),
                    validator: (v) {
                      if (_paymentMethod != 'Credit / Debit Card') return null;
                      final required = _requiredValidator(v, 'CVV');
                      if (required != null) return required;
                      if ((v ?? '').trim().length != 3) return 'Invalid CVV';
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReviewStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Deliver To',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(_fullNameController.text),
              Text('+91 ${_phoneController.text}'),
              Text(
                '${_houseController.text}, ${_areaController.text}, '
                '${_cityController.text}, ${_stateController.text} - ${_pincodeController.text}',
              ),
              if (_landmarkController.text.trim().isNotEmpty)
                Text('Landmark: ${_landmarkController.text.trim()}'),
              Text('Type: $_addressType'),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Delivery & Payment',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text('Delivery: $_deliveryOption'),
              Text('Payment: $_paymentMethod'),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Items',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...widget.items.map(
          (item) => Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: item.image.startsWith('http')
                    ? Image.network(
                        item.image,
                        width: 42,
                        height: 42,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        item.image,
                        width: 42,
                        height: 42,
                        fit: BoxFit.cover,
                      ),
              ),
              title: Text(
                item.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text('${item.size} x ${item.quantity}'),
              trailing: Text(
                '₹${item.total.toStringAsFixed(0)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        _buildPriceRow('Items Total', _itemsTotal),
        _buildPriceRow('Delivery Charge', _deliveryCharge),
        const Divider(),
        _buildPriceRow('Total Payable', _totalPayable, highlight: true),
      ],
    );
  }

  Widget _buildPriceRow(String label, double value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: highlight ? FontWeight.bold : FontWeight.w500,
              fontSize: highlight ? 16 : 14,
            ),
          ),
          Text(
            value == 0 ? 'FREE' : '₹${value.toStringAsFixed(0)}',
            style: TextStyle(
              color: highlight ? const Color(0xFF2E7D32) : Colors.black87,
              fontWeight: highlight ? FontWeight.bold : FontWeight.w500,
              fontSize: highlight ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }
}
