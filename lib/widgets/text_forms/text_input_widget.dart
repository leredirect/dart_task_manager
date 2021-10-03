import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

import '../../constants.dart';

class TextInputWidget extends StatelessWidget {
  final FocusNode focusNode;
  final Function onEditingComplete;
  final TextFieldBloc textFieldBloc;
  final String helperText;
  final bool isExpandable;

  const TextInputWidget({
    Key key,
    @required this.onEditingComplete,
    @required this.textFieldBloc,
    @required this.helperText,
    @required this.focusNode,
    @required this.isExpandable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: TextFieldBlocBuilder(
        onEditingComplete: this.onEditingComplete,
        focusNode: focusNode,
        style: standartText,
        textAlign: TextAlign.left,
        maxLines: this.isExpandable ? null : 1,
        decoration: InputDecoration(
          alignLabelWithHint: true,
          labelText: this.helperText,
          labelStyle: standartText,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          contentPadding: EdgeInsets.only(left: 10),
          enabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(0)),
            borderSide: BorderSide(color: clearColor),
          ),
          focusedBorder: UnderlineInputBorder(
            //borderRadius: BorderRadius.all(Radius.circular(0)),
            borderSide: BorderSide(color: clearColor),
          ),
        ),
        textFieldBloc: this.textFieldBloc,
      ),
    );
  }
}
