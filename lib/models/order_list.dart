import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/cart_item.dart';
import 'package:shop/models/order.dart';
import 'package:http/http.dart' as http;
import 'package:shop/utils/constants.dart';

class OrderList with ChangeNotifier {
  List<Order> _items = [];
  final String _token;
  final String _userId;

  OrderList([this._token = '', this._items = const [], this._userId = '']);

  List<Order> get items => [..._items];

  int get itemsCount => _items.length;

  Future<void> addOrder(Cart cart) async {
    DateTime date = DateTime.now();
    final response = await http.post(
      Uri.parse('${Constants.ORDER_BASE_URL}/$_userId.json?auth=$_token'),
      body: jsonEncode({
        'total': cart.totalAmount,
        'date': date.toIso8601String(),
        'products': cart.items.values.map((cartItem) => {
          'id': cartItem.id,
          'name': cartItem.name,
          'price': cartItem.price,
          'quantity': cartItem.quantity,
          'productId': cartItem.productId,
        }).toList()
      }));

      if (response.statusCode < 400) {
        _items.insert(0, Order(
          id: Random().nextDouble().toString(), 
          total: cart.totalAmount, 
          products: cart.items.values.toList(), 
          date: date,
        ));
        notifyListeners();
      }
  }

  Future<void> loadOrders() async {
    List<Order> items = [];
    final response = await http.get(
      Uri.parse('${Constants.ORDER_BASE_URL}/$_userId.json?auth=$_token')
    );
    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((orderId, orderData) {
      items.add(Order(
        id: orderId, 
        total: orderData['total'], 
        date: DateTime.parse(orderData['date']),
        products:
        (orderData['products'] as List<dynamic>).map((item) {
          return CartItem(
            id: item['id'], 
            productId: item['productId'], 
            name: item['name'], 
            price: item['price'], 
            quantity: item['quantity'],
          );
        }).toList(), 
      ));
    });
    _items = items.reversed.toList();
    notifyListeners();

  }

  String convertString(String string) {
    string = string.replaceAll('(', '[');
    string = string.replaceAll(')', ']');
    return string;
  }
}