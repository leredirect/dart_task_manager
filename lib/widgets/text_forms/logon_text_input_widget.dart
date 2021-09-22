import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

import '../../constants.dart';

class LogonTextInputWidget extends StatelessWidget {
  final FocusNode focusNode;
  final Function onEditingComplete;
  final TextFieldBloc textFieldBloc;
  final String helperText;
  final bool isObscured;
  final SuffixButton suffixButton;

  const LogonTextInputWidget(
      {Key key,
      @required this.onEditingComplete,
      @required this.textFieldBloc,
      @required this.helperText,
      @required this.focusNode,
      this.isObscured,
      this.suffixButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.5,
      child: TextFieldBlocBuilder(
        onEditingComplete: this.onEditingComplete,
        focusNode: focusNode,
        suffixButton: this.suffixButton,
        obscureTextTrueIcon: Icon(Icons.visibility_outlined, color: clearColor),
        obscureTextFalseIcon:
            Icon(Icons.visibility_off_outlined, color: clearColor),
        style: TextStyle(color: Colors.white, letterSpacing: 2),
        textAlign: TextAlign.left,
        decoration: InputDecoration(
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(0)),
            borderSide: BorderSide(color: Colors.red),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(0)),
            borderSide: BorderSide(color: Colors.red),
          ),
          helperText: this.helperText,
          helperStyle: TextStyle(color: Colors.white, letterSpacing: 3),
          contentPadding: EdgeInsets.only(left: 10),
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
