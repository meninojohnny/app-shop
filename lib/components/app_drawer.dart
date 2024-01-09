import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/auth.dart';
import 'package:shop/utils/app_routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Bem vindo Usuário'),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            title: const Text('Loja'),
            leading: const Icon(Icons.shop),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(AppRoutes.PRODUCTS_OVERVIEW);
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Pedidos'),
            leading: const Icon(Icons.payment),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(AppRoutes.ORDERS);
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Gerenciar produtos'),
            leading: const Icon(Icons.edit),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(AppRoutes.PRODUCTS);
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Sair'),
            leading: const Icon(Icons.logout),
            onTap: () {
              Provider.of<Auth>(context, listen: false).logOut();
              Navigator.of(context).pushReplacementNamed(AppRoutes.AUTH_OR_HOME_PAGE);
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}