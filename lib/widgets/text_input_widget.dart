import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

import '../constants.dart';

class TextInputWidget extends StatelessWidget {
  final FocusNode focusNode;
  final Function onEditingComplete;
  final TextFieldBloc textFieldBloc;
  final String helperText;
  final bool isObscured;

  const TextInputWidget(
      {Key key,
      @required this.onEditingComplete,
      @required this.textFieldBloc,
      @required this.helperText,
      @required this.focusNode,
        this.isObscured})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.5,
      child: TextFieldBlocBuilder(
        onEditingComplete: this.onEditingComplete,
        focusNode: focusNode,
        obscureText: this.isObscured,
        style: TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          helperText: this.helperText,
          helperStyle: TextStyle(color: Colors.white, letterSpacing: 3),
          contentPadding: EdgeInsets.only(left: 5),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(0)),
            borderSide: BorderSide(color: clearColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(0)),
            borderSide: BorderSide(color: clearColor),
          ),
        ),
        textFieldBloc: this.textFieldBloc,
      ),
    );
  }
}
