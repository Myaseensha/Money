import 'package:flutter/material.dart';

class Box extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final child;
  const Box({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 15,
              offset: Offset(5, 5),
            ),
            BoxShadow(
              color: Colors.white12,
              blurRadius: 15,
              offset: Offset(-5, -5),
            ),
          ],
        ),
        child: Center(
          child: child,
        ),
      ),
    );
  }
}
