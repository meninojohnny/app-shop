import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_list.dart';
import 'package:shop/utils/app_routes.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  const ProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final msg = ScaffoldMessenger.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.title),
      trailing: SizedBox(
        width: 80,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.PRODUCT_FORM,
                  arguments: product
                );
              }, 
              icon: const Icon(Icons.edit, color: Colors.purple,),
            ),
            IconButton(
              onPressed: () {
                showDialog<bool>(
                  context: context, 
                  builder: (_) { 
                    return AlertDialog(
                      title: const Text('Excluir produto'),
                      content: Text('Deseja excluir ${product.title}?'),
                      actions: [
                        TextButton(onPressed: () {
                          Navigator.of(context).pop(false);
                        }, child: const Text('Não')),
                        TextButton(onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Sim'))
                      ],
                    );
                  }
                ).then((value) async {
                  if (value ?? false) {
                    try {
                      await Provider.of<ProductList>(context, listen: false).removeItem(product);

                    } catch(error) {
                      msg.showSnackBar(
                        const SnackBar(content: Text('Não foi possivel excluir o produto'))
                      );
                    }
                  }
                }
                );
              }, 
              icon: const Icon(Icons.delete, color: Color.fromARGB(255, 211, 43, 31),),
            ),
          ],
        ),
      ),
    );
  }
}