import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;

  const TextWidget({Key key, this.text, this.color = Colors.white, this.fontSize = 13}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      this.text, textAlign: TextAlign.center,
      style: TextStyle(color: this.color, letterSpacing: 3, fontSize: this.fontSize),
    );
  }
}
