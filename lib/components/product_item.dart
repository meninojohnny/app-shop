import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product.dart';
import 'package:shop/utils/app_routes.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key});

  @override
  Widget build(BuildContext context) {
  final Product product = Provider.of(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          title: Text(
            product.title,
            style: const TextStyle(fontFamily: 'Lato'),
            textAlign: TextAlign.center,
          ),
          leading: Consumer<Product>(
            builder: (_, product, __) => IconButton(
              onPressed: () {
                product.toggleFavorite();
              },
              icon: Icon(
                product.isfavorite ? Icons.favorite : Icons.favorite_border, 
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          trailing: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.shopping_cart),
          ),
          backgroundColor: Colors.black87,
        ),
        child: InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(
              AppRoutes.PRODUCT_DETAIL,
              arguments: product
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}