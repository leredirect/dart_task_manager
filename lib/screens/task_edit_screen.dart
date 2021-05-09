import 'package:dart_task_manager/bloc/task_list_bloc/task_list_bloc.dart';
import 'package:dart_task_manager/bloc/task_list_bloc/task_list_event.dart';
import 'package:dart_task_manager/models/task.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;

  const EditTaskScreen({Key key, this.task}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _nameController = TextEditingController();
  final _textController = TextEditingController();
  var taskExpiredTime;

  void addTask(String taskTag, taskExpiredTime) {
    String taskName = _nameController.text;
    String taskText = _textController.text;
    widget.task.name = taskName;
    widget.task.text = taskText;
    widget.task.tag = taskTag;
    var taskCreateTime = DateFormat.Hm().format(DateTime.now());
    taskExpiredTime = DateFormat.H().format(taskExpiredTime);
    // taskExpiredTime = taskExpiredTime.toString();
    // taskExpiredTime = int.parse(taskExpiredTime);
    widget.task.taskExpiredTime = taskExpiredTime;
    context.bloc<TaskListBloc>().add(EditTaskEvent(widget.task));
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  String dropdownValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Редактирование задачи"),
        backgroundColor: Colors.redAccent,
      ),
      body: Column(
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
                hintText: "Название задачи",
                contentPadding: EdgeInsets.only(left: 5)),
          ),
          TextField(
            controller: _textController,
            decoration: InputDecoration(
                hintText: "Условия задачи",
                contentPadding: EdgeInsets.only(left: 5),
                focusColor: Colors.redAccent),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.fromLTRB(5, 10, 0, 0),
            child: DropdownButton<String>(
              value: dropdownValue,
              iconSize: 24,
              elevation: 16,
              underline: Container(
                height: 2,
                color: Colors.redAccent,
              ),
              onChanged: (String newValue) {
                setState(() {
                  dropdownValue = newValue;
                });
              },
              items: <String>[
                'Dart',
                'Flutter',
                'Алгоритмы',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          InkWell(
              onTap: () {
                DatePicker.showTimePicker(
                  context,
                  currentTime: DateTime(1, 1, 0, 0),
                  showSecondsColumn: false,
                  showTitleActions: true,
                  onConfirm: (time) {
                    taskExpiredTime = time;
                    print('confirm $time');
                  },
                  locale: LocaleType.ru,
                );
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(5, 10, 0, 0),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    )
                  ],
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.redAccent,
                ),
                width: 250,
                height: 40,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Center(
                    child: Text(
                  "Задать время на выполнение",
                  style: TextStyle(color: Colors.white),
                )),
                // color: Colors.redAccent,
              )),
          Spacer(),
          InkWell(
              onTap: () => addTask(dropdownValue, taskExpiredTime),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(12)),
                width: 200,
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
    dropdownValue = widget.task.tag;
    _nameController.text = widget.task.name;
    _textController.text = widget.task.text;
  }
}
