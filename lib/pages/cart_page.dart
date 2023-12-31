import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/cart_item.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/order_list.dart';

class CartPage extends StatefulWidget {

  CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of<Cart>(context);
    final List items = cart.items.values.toList();
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text(
          'Carrinho',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  const Text('Total:'),
                  const SizedBox(width: 10,),
                  Chip(
                    backgroundColor: Colors.purple, 
                    label: Text(
                      'R\$ ${cart.totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const Spacer(),
                  isLoading ? const CircularProgressIndicator() : TextButton(
                    onPressed: cart.items.isEmpty ? null : () {
                      try {
                        setState(() {isLoading = !isLoading;});
                        Provider.of<OrderList>(context, listen: false).addOrder(cart).then((value) {
                          cart.clear(); 
                          setState(() {isLoading = !isLoading;});
                        });
                      } catch(e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao adicionar produto')));
                      }
                      
                      
                    }, 
                    child: const Text('COMPRAR'),
                  ),
                ]
              ),
            ),
          ),
          Expanded(child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (_, index) {
              return CartItemWidget(cartItem: items[index]);
            },
          )),
        ],
      ),
    );
  }
}