import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

import '../../constants.dart';

class DateTimeInputWidget extends StatelessWidget {
  final FocusNode focusNode;
  final Function onEditingComplete;
  final InputFieldBloc dateTimeFormBloc;
  final String helperText;
  final bool isExpandable;

  const DateTimeInputWidget({
    Key key,
    @required this.onEditingComplete,
    @required this.helperText,
    @required this.focusNode,
    @required this.isExpandable,
    @required this.dateTimeFormBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //width: MediaQuery.of(context).size.width / 1.1,
      child:
          //   child: TextFieldBlocBuilder(
          //   onEditingComplete: this.onEditingComplete,
          //   focusNode: focusNode,
          //   style: TextStyle(color: Colors.white, letterSpacing: 2),
          //   textAlign: TextAlign.left,
          //   maxLines: this.isExpandable ? null : 1,
          //   decoration: InputDecoration(
          //     helperText: this.helperText,
          //     helperStyle: TextStyle(color: Colors.white, letterSpacing: 3),
          //     contentPadding: EdgeInsets.only(left: 10),
          //     enabledBorder: UnderlineInputBorder(
          //       borderRadius: BorderRadius.all(Radius.circular(0)),
          //       borderSide: BorderSide(color: clearColor),
          //     ),
          //     focusedBorder: UnderlineInputBorder(
          //       //borderRadius: BorderRadius.all(Radius.circular(0)),
          //       borderSide: BorderSide(color: clearColor),
          //     ),
          //   ),
          //   textFieldBloc: this.textFieldBloc,
          // ),
          Container(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: DateTimeFieldBlocBuilder(
          canSelectTime: true,
          focusNode: this.focusNode,
          textAlign: TextAlign.left,
          style: TextStyle(color: Colors.white, letterSpacing: 2),
          dateTimeFieldBloc: this.dateTimeFormBloc,
          format: DateFormat('dd-MM-yyyy в hh:mm'),
          initialDate: DateTime.now(),
          firstDate: DateTime(2021),
          lastDate: DateTime(2022),
          decoration: InputDecoration(
            suffixIcon: Icon(
              Icons.calendar_today_outlined,
              color: Colors.grey,
            ),
            labelText: this.helperText,
            labelStyle: standartText,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: clearColor.withOpacity(0)),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: clearColor.withOpacity(0)),
            ),
          ),
        ),
      ),
    );
  }
}
