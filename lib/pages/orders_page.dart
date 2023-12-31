import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/components/order_item.dart';
import 'package:shop/models/order_list.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text(
          'Meus Pedidos',
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<OrderList>(context, listen: false).loadOrders(), 
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if(snapshot.error != null) {
            return const Center(child: Text('Ocorreu um erro'),);
          } else {
            return Consumer<OrderList>(
              builder: (context, orders, child) {
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: ListView.builder(
                    itemCount: orders.items.length,
                    itemBuilder: (_, index) {
                      return Orderitem(order: orders.items[index]);
                  }),
                );
              },
            );
          }
        },
      ),
      // body: isLoading 
      // ? const Center(child: CircularProgressIndicator()) 
      // : Padding(
      //   padding: const EdgeInsets.all(10),
      //   child: ListView.builder(
      //     itemCount: orders.length,
      //     itemBuilder: (_, index) {
      //       return Orderitem(order: orders[index]);
      //   }),
      // ),
    );
  }
}