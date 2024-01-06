import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/auth.dart';
import 'package:shop/pages/auth_page.dart';
import 'package:shop/pages/products_overview_pages.dart';

class AuthOrHomePage extends StatelessWidget {
  const AuthOrHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Auth>(context);
    return provider.isAuth ? const ProductsOverviewPage() : const AuthPage();
  }
}