import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop/models/order.dart';

class Orderitem extends StatefulWidget {
  final Order order;
  const Orderitem({super.key, required this.order});

  @override
  State<Orderitem> createState() => _OrderitemState();
}

class _OrderitemState extends State<Orderitem> {
  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text('R\$ ${widget.order.total.toStringAsFixed(2)}'),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(widget.order.date),
              style: const TextStyle(
                fontSize: 12,
                color: Color.fromARGB(113, 0, 0, 0),
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                expanded 
                ? Icons.arrow_drop_up
                : Icons.arrow_drop_down
              ),
              onPressed: () {
                setState(() {
                  expanded = !expanded;
                });
              },
            ),
          ),
          if (expanded)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              children: widget.order.products.map((product) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(fontSize: 12,),
                    ),
                    Text(
                      '${product.quantity}x ${product.price}',
                      style: const TextStyle(
                        color: Color.fromARGB(113, 0, 0, 0),
                        fontSize: 12,
                      ),
                    )
                  ],
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}