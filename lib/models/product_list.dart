import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/http_exception.dart';
import 'package:shop/models/product.dart';
import 'package:shop/utils/constants.dart';

class ProductList with ChangeNotifier {
  List<Product> _items = [];
  bool _showFavoriteOnly = false;
  final String _token;

  ProductList(this._token, this._items);

  List<Product> get items { 
    return 
    _showFavoriteOnly 
      ? _items.where((product) => product.isfavorite == true).toList() 
      : [..._items];
  }

  int get itemsCount => _items.length; 

  Future<void> loadProducts() async {
    _items.clear();
    final response = await http.get(
      Uri.parse('${Constants.PRODUCT_BASE_URL}.json?auth=$_token')
    );
    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((productId, productData) {
      
      _items.add(Product(
        id: productId, 
        title: productData['name'], 
        price: productData['price'] + 0.0, 
        description: productData['description'], 
        imageUrl: productData['imageUrl'],
        isfavorite: productData['isFavorite']
      ));
    });
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse('${Constants.PRODUCT_BASE_URL}.json?auth=$_token'),
      body: jsonEncode({
        'name': product.title,
        'description': product.description,
        'price': product.price,
        'imageUrl': product.imageUrl,
        'isFavorite': product.isfavorite
      }),
    );
    
    final id = jsonDecode(response.body)['name'];
    _items.add(Product(
      id: id, 
      title: product.title, 
      price: product.price, 
      description: product.description, 
      imageUrl: product.imageUrl,
      isfavorite: product.isfavorite
    ));
    notifyListeners();
    
  }

  Future<void> saveProduct(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    Product product = Product(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(), 
      title: data['name'] as String, 
      price: data['price'] as double, 
      description: data['description'] as String, 
      imageUrl: data['imageUrl'] as String,
    );

    if (hasId) {
      return updateProduct(product);
    } else {
      return addProduct(product);
    }
  }

  Future<void> updateProduct(Product product) async {
    int index = _items.indexWhere((Product item) => item.id == product.id);
    if (index >= 0) {
      await http.patch(
        Uri.parse('${Constants.PRODUCT_BASE_URL}/${product.id}.json?auth=$_token'),
        body: jsonEncode({
          'name': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
        }),
      );
      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> removeItem(Product product) async {
    int index = _items.indexWhere((Product item) => item.id == product.id);

    if (index >= 0) {
      final Product product2 = product;
      _items.remove(product);
      notifyListeners();

      final response = await http.delete(Uri.parse('${Constants.PRODUCT_BASE_URL}/${product.id}.json?auth=$_token'),);

      if (response.statusCode >= 400) {
        _items.insert(index, product2);
        notifyListeners();
        throw HttpExceptions(
          msg: 'Não foi possivel excluiro o produto.',
          statusCode: response.statusCode,
        );
      }

    }
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