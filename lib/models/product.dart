import 'package:flutter/material.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final double price;
  final String description;
  final String imageUrl;
  bool isfavorite;

  Product({
    required this.id, 
    required this.title, 
    required this.price, 
    required this.description, 
    required this.imageUrl,
    this.isfavorite = false,
  });

  void toggleFavorite() {
    isfavorite = !isfavorite;
    notifyListeners();
  }
}