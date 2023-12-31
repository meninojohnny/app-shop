import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/cart_item.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  const CartItemWidget({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of<Cart>(context);
    return Dismissible(
      key: ValueKey(cartItem.id),
      direction: DismissDirection.endToStart,
      background: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          color: const Color.fromARGB(255, 177, 36, 26),
          padding: const EdgeInsets.only(right: 20),
          alignment: Alignment.centerRight,
          child: const Icon(Icons.delete, color: Colors.white,),
        ),
      ),
      onDismissed: (_) {
        cart.removeItem(cartItem.productId);
      },
      confirmDismiss: (_) {
        return showDialog(
          context: context, 
          builder: (_) {
            return AlertDialog(
              title: const Text('Tem certeza?'),
              content: const Text('Deseja remover?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  }, 
                  child: const Text('Não'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  }, 
                  child: const Text('Sim'),
                ),
              ],
            );
          },
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.purple,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: FittedBox( 
                child: Text(
                  'R\$ ${cartItem.price.toStringAsFixed(2)}', 
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          title: Text(cartItem.name),
          subtitle: Text('Total: R\$ ${cartItem.price * cartItem.quantity}'),
          trailing: Text('${cartItem.quantity}x'),
        ),
      ),
    );
  }
}