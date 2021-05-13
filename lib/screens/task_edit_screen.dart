import 'package:dart_task_manager/bloc/task_list_bloc/task_list_bloc.dart';
import 'package:dart_task_manager/bloc/task_list_bloc/task_list_event.dart';
import 'package:dart_task_manager/models/task.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../constants.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;

  const EditTaskScreen({Key key, this.task}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _nameController = TextEditingController();
  final _textController = TextEditingController();
  String dropdownValue;
  DateTime pickedDate;
  TimeOfDay pickedTime;

  void addTask(String taskTag, DateTime deadline) {
    String taskName = _nameController.text;
    String taskText = _textController.text;
    widget.task.name = taskName;
    widget.task.text = taskText;
    widget.task.tag = tagsMap[taskTag];
    var taskCreateTime = DateFormat.Hm().format(DateTime.now());
    widget.task.taskDeadline = deadline;
    context.bloc<TaskListBloc>().add(EditTaskEvent(widget.task));
    context.bloc<TaskListBloc>().add(EditTaskCheckEvent(widget.task));
    Navigator.of(context).pop();
  }

  void deadlineCalc(
      String dropdownValue, DateTime pickedDate, TimeOfDay pickedTime) {
    DateTime deadline = DateTime(pickedDate.year, pickedDate.month,
        pickedDate.day, pickedTime.hour, pickedTime.minute);
    bool isBefore = deadline.isAfter(DateTime.now());
    Duration diff = deadline.difference(DateTime.now());
    print(diff);
    if (isBefore) {
      return addTask(dropdownValue, deadline);
    } else {
      return addTask(dropdownValue, null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Редактирование задачи"),
        backgroundColor: primaryColor,
      ),
      body: Column(
        children: [
          TextField(
            controller: _nameController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Название задачи",
              contentPadding: EdgeInsets.only(left: 5),
              hintStyle: TextStyle(color: Colors.white),
              enabledBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: secondaryColorLight.withOpacity(0.45)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: secondaryColorLight),
              ),
            ),
          ),
          TextField(
            controller: _textController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Условия задачи",
              hintStyle: TextStyle(color: Colors.white),
              contentPadding: EdgeInsets.only(left: 5),
              enabledBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: secondaryColorLight.withOpacity(0.45)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: secondaryColorLight),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.fromLTRB(5, 10, 0, 0),
            child: DropdownButton<String>(
              style: TextStyle(color: Colors.white, fontSize: 16),
              dropdownColor: primaryColorDark,
              value: dropdownValue,
              iconSize: 24,
              elevation: 16,
              underline: Container(
                height: 2,
                color: secondaryColorLight,
              ),
              onChanged: (String newValue) {
                setState(() {
                  dropdownValue = newValue;
                });
              },
              items: tagsMap.keys.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
            ),
          ),
          InkWell(
              onTap: () {
                // DatePicker.showTimePicker(
                //   context,
                //   currentTime: DateTime(1, 1, 0, 0),
                //   showSecondsColumn: false,
                //   showTitleActions: true,
                //   onConfirm: (time) {
                //     taskExpiredTime = time;
                //     print('confirm $time');
                //   },
                //   locale: LocaleType.ru,
                // );
                DateTime now = DateTime.now();
                var lastDate = now.add(const Duration(days: 60));
                var firstDate = now.subtract(const Duration(days: 5));
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: firstDate,
                  lastDate: lastDate,
                ).then((value) => pickedDate = value).then((value) =>
                    showTimePicker(
                            context: context, initialTime: TimeOfDay.now())
                        .then((value) => pickedTime = value));
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(5, 10, 0, 0),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      spreadRadius: 1,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    )
                  ],
                  borderRadius: BorderRadius.circular(12),
                  color: secondaryColorLight,
                ),
                width: MediaQuery.of(context).size.width * 0.6,
                height: 40,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Center(
                    child: Text(
                  "Задать время на выполнение",
                  style: TextStyle(color: Colors.white),
                )),
              )),
          Spacer(),
          InkWell(
              onTap: () => deadlineCalc(dropdownValue, pickedDate, pickedTime),
              child: Container(
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      )
                    ],
                    color: secondaryColorLight,
                    borderRadius: BorderRadius.circular(12)),
                width: MediaQuery.of(context).size.width * 0.4,
                height: 40,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                margin: EdgeInsets.only(bottom: 50),
                child: Center(
                    child: Text(
                  "Подтвердить",
                  style: TextStyle(color: Colors.white),
                )),
                // color: Colors.redAccent,
              ))
        ],
      ),
      backgroundColor: primaryColorDark,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _textController.dispose();
  }

  @override
  void initState() {
    super.initState();
    dropdownValue =
        tagsMap.keys.firstWhere((k) => tagsMap[k] == widget.task.tag);
    _nameController.text = widget.task.name;
    _textController.text = widget.task.text;
  }
}
