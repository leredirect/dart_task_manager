import 'package:dart_task_manager/constants.dart';
import 'package:flutter/material.dart';

class TextButtonWidget extends StatelessWidget {
  final Function onPressed;
  final Color borderColor;
  final String text;
  final Color textColor;
  final double fontSize;
  final textStyle;

  const TextButtonWidget(
      {Key key,
      this.onPressed,
      this.borderColor,
      this.text, this.textColor, this.fontSize = 13, this.textStyle = standartText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
        child: TextButton(
          onPressed: this.onPressed,
          child: Container(
            decoration:
                BoxDecoration(border: Border.all(color: this.borderColor)),
            child: Padding(
              padding:
                  EdgeInsets.only(top: 10, bottom: 10, left: 50, right: 50),
              child: Text(this.text, style: this.textStyle,),
            ),
          ),
        ));
  }
}
