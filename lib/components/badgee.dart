import 'package:flutter/material.dart';

class Badgee extends StatelessWidget {
  final int value;
  final Widget child;
  const Badgee({super.key, required this.value, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        child,
        if (value > 0)
        Positioned(
          child: Positioned(
            child: Container(
              width: 15,
              height: 15,
              alignment: Alignment.center,
              margin: const EdgeInsets.only(right: 10),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle
              ),
              child: Text(
                value.toString(), 
                style: const TextStyle(fontSize: 8, color: Colors.white),
              ),
            ),
          ),
        )
      ],
    );
  }
}