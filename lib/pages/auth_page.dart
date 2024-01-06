import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/components/auth_form.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 208, 106, 226),
                  Color.fromARGB(255, 97, 77, 168),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight
              )
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 35),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 200, 25, 12),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [BoxShadow(
                      color: Color.fromARGB(129, 0, 0, 0),
                      blurRadius: 1.1,
                      offset: Offset(0, 2),
                    )],
                  ),
                  transform: Matrix4.rotationZ(-8 * pi / 180)..translate(-10.0),
                  child: const Text(
                    'Minha Loja',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontFamily: 'Anton'
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                AuthForm(),
              ],
            ),
          ),
        ]
      ),
    );
  }
}