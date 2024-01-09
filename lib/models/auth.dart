import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/data/store.dart';
import 'package:shop/exceptions/auth_exception.dart';

class Auth with ChangeNotifier {
  String? _email;
  String? _token;
  String? _userId;
  DateTime? _expiryDate;
  Timer? _logOutTimer;

  bool get isAuth {
    final isValid = _expiryDate?.isAfter(DateTime.now()) ?? false;
    return _token != null && isValid;
  }

  String? get email {
    return isAuth ? _email : null;
  }

  String? get token {
    return isAuth ? _token : null;
  }

   String? get userId {
    return isAuth ? _userId : null;
  }

  Future<void> _authenticate(String email, String password, String fragmentUrl) async {
    final String url = 'https://identitytoolkit.googleapis.com/v1/accounts:$fragmentUrl?key=AIzaSyDywn0mJHSGXTnTcFaMxgPFZY52JOwzcVY';
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true
      })
    );

    final body = jsonDecode(response.body);
    if (body['error'] != null) {
      throw AuthException(body['error']['message']);
    } else {
      _token = body['idToken'];
      _email = body['email'];
      _userId = body['localId'];
      _expiryDate = DateTime.now().add(Duration(seconds: int.parse(body['expiresIn'])));

      Store.saveMap('userData', {
        'token': _token,
        'email': _email,
        'userId': _userId,
        'expiryDate': _expiryDate!.toIso8601String()
      });

      _autoLogOut();
      notifyListeners();
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> logIn(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  void logOut() {
    _email = null;
    _token = null;
    _userId = null;
    _expiryDate = null;
    _clearLogOutTimer();
    Store.remove('userData');
    notifyListeners();
  }

  void _clearLogOutTimer() {
    _logOutTimer?.cancel();
    _logOutTimer = null;
  }

  void _autoLogOut() {
    _clearLogOutTimer();
    final _timeToLogOut = _expiryDate?.difference(DateTime.now()).inSeconds;
    _logOutTimer = Timer(Duration(seconds: _timeToLogOut ?? 0), logOut);
  }

  Future<void> tryAutoLogOut() async {

    if (isAuth) return;

    final userData = await Store.getMap('userData');
    if (userData.isEmpty) return;

    final expiryDate = DateTime.parse(userData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) return;

    _token = userData['token'];
    _email = userData['email'];
    _userId = userData['userId'];
    _expiryDate = expiryDate;

    _autoLogOut();
    notifyListeners();

  }

}