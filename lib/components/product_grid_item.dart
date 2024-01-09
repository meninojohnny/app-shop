import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/auth.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/product.dart';
import 'package:shop/utils/app_routes.dart';

class ProductGridItem extends StatelessWidget {
  const ProductGridItem({super.key});

  @override
  Widget build(BuildContext context) {
    final Product product = Provider.of<Product>(context);
    final Cart cart = Provider.of<Cart>(context);
    final auth = Provider.of<Auth>(context);

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
                product.toggleFavorite(auth.token ?? '', auth.userId ?? '');
              },
              icon: Icon(
                product.isfavorite ? Icons.favorite : Icons.favorite_border, 
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          trailing: IconButton(
            onPressed: () {
              cart.addItem(product);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Produto adicionado com sucesso!'),
                  duration: const Duration(seconds: 1),
                  action: SnackBarAction(
                    label: 'DESFAZER', 
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                  ),
                )
              );
            },
            icon: Icon(
              Icons.shopping_cart,
              color: Theme.of(context).primaryColor
            ),
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