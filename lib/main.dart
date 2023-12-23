import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product_list.dart';
import 'package:shop/pages/product_detail_page.dart';
import 'package:shop/pages/products_overview_pages.dart';
import 'package:shop/utils/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductList(),
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.purple,
          primaryColor: Colors.red,
          useMaterial3: true,
          fontFamily: 'Lato'
        ),
        initialRoute: AppRoutes.PRODUCTS_OVERVIEW,
        routes: {
          AppRoutes.PRODUCTS_OVERVIEW: (_) => const ProductsOverviewPage(),
          AppRoutes.PRODUCT_DETAIL: (_) => const ProductDetailPage(),
        },
      ),
    );
  }
}