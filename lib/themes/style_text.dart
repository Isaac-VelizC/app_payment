import 'package:flutter/material.dart';

class StyleText extends StatelessWidget {
  final String text;
  final Color colors;
  final double? size;
  final FontWeight? fontweight;
  const StyleText(
      {super.key,
      required this.colors,
      this.size,
      required this.text,
      this.fontweight});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: colors,
        fontSize: size,
        fontWeight: fontweight,
      ),
    );
  }
}
