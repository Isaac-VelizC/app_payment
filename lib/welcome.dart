import 'dart:async';
import 'package:app_payment/Screens/home_screen.dart';
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
      const Duration(seconds: 10), () => Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => const HomeScreen(),),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      
          width: double.infinity,
          height: double.infinity,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        AnimatedContainer(
          duration: Duration(seconds: 1),
          curve: Curves.easeInOut,
          width: double.infinity,
          height: double.infinity,
          child: Text('Anabel')
        ),
        SizedBox(height: 25.0),
        Text(
          '¡Bienvenida!',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
    /*Container(
      color: Colors.white,
      height: double.infinity,
      width: double.infinity,
      child: const Center(
        child: Text('data'),
      ),
    );*/
  }
}
