import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/utils/constants.dart';

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

  Future<void> toggleFavorite(String token, String userId) async {
    isfavorite = !isfavorite;
    notifyListeners();
    await http.put(
      Uri.parse('${Constants.USER_FAVORITES}/$userId/$id.json?auth=$token'), 
      body: jsonEncode(isfavorite)
    ).catchError((error) {
      isfavorite = !isfavorite;
      notifyListeners();
    });
    
  }
}