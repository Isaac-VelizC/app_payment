import 'dart:async';
import 'package:app_payment/Screens/navegacion_screen.dart';
import 'package:flutter/material.dart';

class BienvenidoScreen extends StatefulWidget {
  const BienvenidoScreen({super.key});

  @override
  State<BienvenidoScreen> createState() => _BienvenidoScreenState();
}

class _BienvenidoScreenState extends State<BienvenidoScreen> {
  double logoSize = 100.0;

  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const NavegadorScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedContainer(
              duration: const Duration(seconds: 2),
              curve: Curves.easeInOut,
              height: 200,
              width: 200,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/hola.png'),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              '¡Bienvenido!',
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
