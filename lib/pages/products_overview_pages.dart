import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/components/badgee.dart';
import 'package:shop/components/product_grid.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/product_list.dart';
import 'package:shop/utils/app_routes.dart';

enum FilterOptions {
  favorite,
  all
}

class ProductsOverviewPage extends StatefulWidget {
  const ProductsOverviewPage({super.key});

  @override
  State<ProductsOverviewPage> createState() => _ProductsOverviewPageState();
}

class _ProductsOverviewPageState extends State<ProductsOverviewPage> {
  bool isLoading = true;

  Future<void> _refreshProducts(BuildContext context) {
    return Provider.of<ProductList>(context, listen: false).loadProducts();
  }

  @override
  void initState() {
    super.initState();
    Provider.of<ProductList>(context, listen: false).loadProducts().then((value) {
      setState(() {isLoading = false;});
    });
  }

  @override
  Widget build(BuildContext context) {
    final ProductList provider = Provider.of<ProductList>(context);
    // print(provider.items.length);
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text(
          'Minha loja',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (_) => [
              const PopupMenuItem(value: FilterOptions.favorite, child: Text('Somente os favoritos'),),
              const PopupMenuItem(value: FilterOptions.all, child: Text('Todos'),)
            ],
            onSelected: (FilterOptions optionSelected) {
              if (optionSelected == FilterOptions.favorite) {
                provider.showFavoriteOnly();
              } else {
                provider.showAll();
              }
            },
          ),
          Consumer<Cart>(
            builder: (_, cart, child) => Badgee(
              value: cart.itemsCount,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.CART_PAGE);
                }, 
                icon: const Icon(Icons.shopping_cart, color: Colors.white,),
              ),
            ),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh:() => _refreshProducts(context),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: isLoading 
          ? const Center(child: CircularProgressIndicator()) 
          : const ProductGrid(),
        ),
      ),
    );
  }
}