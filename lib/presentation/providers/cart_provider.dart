import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:callparts/model/cart_item.dart';
import 'package:callparts/model/product.dart';

class CartProvider extends ChangeNotifier {
  List<CartItem> _items = [];
  double _shippingFee = 25000; // VND
  double _taxRate = 0.08; // 8%
  double _discount = 0;

  static const String _cartKey = 'shopping_cart';

  List<CartItem> get items => List.unmodifiable(_items);
  
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  
  double get shippingFee => _shippingFee;
  double get taxRate => _taxRate;
  double get discount => _discount;

  // Calculate subtotal for selected items only
  double get subtotal => _items
      .where((item) => item.selected)
      .fold(0.0, (sum, item) => sum + item.totalPrice);

  double get tax => subtotal * _taxRate;

  double get total => subtotal + _shippingFee + tax - _discount;

  // Check if a product is already in cart
  bool isInCart(int productId) {
    return _items.any((item) => item.productId == productId);
  }

  // Get quantity of a product in cart
  int getProductQuantity(int productId) {
    final item = _items.firstWhere(
      (item) => item.productId == productId,
      orElse: () => CartItem(
        productId: 0,
        product: null,
        quantity: 0,
      ),
    );
    return item.quantity;
  }

  // Add item to cart
  void addItem(Product product, {int quantity = 1}) {
    final existingIndex = _items.indexWhere(
      (item) => item.productId == product.id,
    );

    if (existingIndex >= 0) {
      // Update quantity if item already exists
      _items[existingIndex] = _items[existingIndex].copyWith(
        quantity: _items[existingIndex].quantity + quantity,
      );
    } else {
      // Add new item
      _items.add(CartItem.fromProduct(product, quantity: quantity));
    }

    _saveToPreferences();
    notifyListeners();
  }

  // Update item quantity
  void updateQuantity(int productId, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(productId);
      return;
    }

    final index = _items.indexWhere((item) => item.productId == productId);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(quantity: newQuantity);
      _saveToPreferences();
      notifyListeners();
    }
  }

  // Remove item from cart
  void removeItem(int productId) {
    _items.removeWhere((item) => item.productId == productId);
    _saveToPreferences();
    notifyListeners();
  }

  // Toggle item selection
  void toggleSelection(int productId, bool selected) {
    final index = _items.indexWhere((item) => item.productId == productId);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(selected: selected);
      _saveToPreferences();
      notifyListeners();
    }
  }

  // Select/deselect all items
  void toggleSelectAll(bool selected) {
    _items = _items.map((item) => item.copyWith(selected: selected)).toList();
    _saveToPreferences();
    notifyListeners();
  }

  // Clear entire cart
  void clearCart() {
    _items.clear();
    _saveToPreferences();
    notifyListeners();
  }

  // Apply discount
  void applyDiscount(double discountAmount) {
    _discount = discountAmount;
    notifyListeners();
  }

  // Save cart to SharedPreferences
  Future<void> _saveToPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartData = _items.map((item) => item.toJson()).toList();
      await prefs.setString(_cartKey, jsonEncode(cartData));
    } catch (e) {
      debugPrint('Error saving cart: $e');
    }
  }

  // Load cart from SharedPreferences
  Future<void> loadFromPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartString = prefs.getString(_cartKey);
      
      if (cartString != null) {
        final List<dynamic> cartData = jsonDecode(cartString);
        _items = cartData.map((item) => CartItem.fromJson(item)).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading cart: $e');
    }
  }

  // Get selected items count
  int get selectedItemsCount => _items.where((item) => item.selected).length;

  // Check if all items are selected
  bool get allItemsSelected => _items.isNotEmpty && _items.every((item) => item.selected);
}
