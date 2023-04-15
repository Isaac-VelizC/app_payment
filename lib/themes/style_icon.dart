import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StyleIcono extends StatelessWidget {
  final String iconName;
  final Color color;
  final double ancho;
  final double alto;
  const StyleIcono({
    super.key,
    required this.iconName,
    required this.color,
    required this.ancho,
    required this.alto,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/$iconName.svg',
      color: color,
      width: ancho,
      height: alto,
    );
  }
}
