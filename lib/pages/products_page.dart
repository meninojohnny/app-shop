import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/components/product_item.dart';
import 'package:shop/models/product_list.dart';
import 'package:shop/utils/app_routes.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    Provider.of<ProductList>(
      context, 
      listen: false).loadProducts().then((value) {
        setState(() {
          isLoading = false;
        });
      });
  }
  @override
  Widget build(BuildContext context) {
    final ProductList products = Provider.of<ProductList>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text(
          'Gerenciar produtos',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.PRODUCT_FORM);
            }, 
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: isLoading 
      ? const Center(child: CircularProgressIndicator()) 
      : Padding(
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: products.itemsCount,
          itemBuilder: (_, index) {
            return Column(
              children: [
                ProductItem(product: products.items[index]),
                const Divider(),
              ],
            );
        }),
      ),
    );
  }
}