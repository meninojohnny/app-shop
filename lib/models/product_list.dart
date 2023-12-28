import 'package:flutter/material.dart';
import 'package:shop/data/dummy_products.dart';
import 'package:shop/models/product.dart';

class ProductList with ChangeNotifier {
  final List<Product> _items = dummyProducts;
  bool _showFavoriteOnly = false;


  List<Product> get items => _showFavoriteOnly ? _items.where((product) => product.isfavorite).toList() : [..._items];

  void addProduct(Product product) {
    _items.add(product);
    notifyListeners();
  }

  void showFavoriteOnly() {
    _showFavoriteOnly = true;
    notifyListeners();
  }

  void showAll() {
    _showFavoriteOnly = false;
    notifyListeners();
  }
}