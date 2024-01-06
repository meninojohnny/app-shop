import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/auth.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/order_list.dart';
import 'package:shop/models/product_list.dart';
import 'package:shop/pages/auth_or_home_page.dart';
import 'package:shop/pages/auth_page.dart';
import 'package:shop/pages/cart_page.dart';
import 'package:shop/pages/orders_page.dart';
import 'package:shop/pages/product_detail_page.dart';
import 'package:shop/pages/product_form_page.dart';
import 'package:shop/pages/products_overview_pages.dart';
import 'package:shop/pages/products_page.dart';
import 'package:shop/utils/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Auth()),
        ChangeNotifierProxyProvider<Auth, ProductList>(
          create: (_) => ProductList('', []),
          update: (context, auth, previus) => ProductList(
            auth.token ?? '', 
            previus?.items ?? [],
          ),
        ),
        ChangeNotifierProxyProvider<Auth, OrderList>(
          create: (_) => OrderList('', []),
          update: (ctx, auth, previus) => OrderList(
            auth.token ?? '', 
            previus!.items ?? []
          ),
        ),
        ChangeNotifierProvider(create: (_) => Cart()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.purple,
          primaryColor: Colors.red,
          canvasColor: const Color.fromARGB(255, 189, 170, 192),
          useMaterial3: true,
          fontFamily: 'Lato'
        ),
        routes: {
          AppRoutes.AUTH_OR_HOME_PAGE: (_) => const AuthOrHomePage(),
          AppRoutes.PRODUCTS_OVERVIEW: (_) => const ProductsOverviewPage(),
          AppRoutes.PRODUCT_DETAIL: (_) => const ProductDetailPage(),
          AppRoutes.CART_PAGE: (_) => CartPage(),
          AppRoutes.ORDERS: (_) => const OrdersPage(),
          AppRoutes.PRODUCTS: (_) => const ProductsPage(),
          AppRoutes.PRODUCT_FORM: (_) => const ProductFormPage()
        }, 
      ),
    );
  }
}