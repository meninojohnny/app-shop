import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shop/models/cart_item.dart';
import 'package:shop/models/product.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get itemsCount => _items.length;

  double get totalAmount {
    double total = 0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void add(Product product) {
    if (_items.containsKey(product.id)) {
      _items.update(product.id, (CartItem existingItem) {
        return CartItem(
          id: existingItem.id,
          productId: existingItem.productId, 
          name: existingItem.name, 
          price: existingItem.price, 
          quantity: existingItem.quantity + 1,
        );
      });
    } else {
      _items.putIfAbsent(product.id, () => CartItem(
        id: Random().nextDouble().toString(), 
        productId: product.id, 
        name: product.title, 
        price: product.price, 
        quantity: 1,
      ),);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}