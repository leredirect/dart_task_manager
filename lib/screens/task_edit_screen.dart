import 'package:dart_task_manager/bloc/task_list_bloc/task_list_bloc.dart';
import 'package:dart_task_manager/bloc/task_list_bloc/task_list_event.dart';
import 'package:dart_task_manager/models/task.dart';
import 'package:dart_task_manager/repository/repo.dart';
import 'package:dart_task_manager/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

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

  Future<void> addTask(String taskTag, String deadline) async {
    List<int> tags = [];
    tags.add(nameToTagMap[taskTag].index);
    widget.task.taskDeadline = deadline;
    String taskName = _nameController.text;
    String taskText = _textController.text;
    widget.task.name = taskName;
    widget.task.text = taskText;
    widget.task.tags = tags;

    context.read<TaskListBloc>().add(EditTaskEvent(widget.task));
    context.read<TaskListBloc>().add(EditTaskCheckEvent(widget.task));
    var listBox = await Hive.openBox<List<Task>>('taskList');
    listBox.put('task', context.read<TaskListBloc>().state);
    listBox.close();
    try {
      await Repository().editTask(widget.task);
      Navigator.of(context).pop();
    } on Exception catch (e) {
      snackBarNotification(context, e.toString());
      Navigator.of(context).pushNamedAndRemoveUntil("/", (_) => false);
    }
  }

  Future<void> showTaskTimePicker(DateTime pickedDate) {
    if (pickedDate != null) {
      return showTimePicker(context: context, initialTime: TimeOfDay.now())
          .then((value) => setState(() {
                pickedTime = value;
              }));
    } else {}
  }

  Future<void> deadlineCalc(
      String dropdownValue, DateTime pickedDate, TimeOfDay pickedTime) async {
    if (pickedDate == null && pickedTime == null) {
      String deadlineRes = widget.task.taskDeadline.toString();
      return addTask(dropdownValue, deadlineRes);
      // return showDialog<void>(
      //   context: context,
      //   barrierDismissible: false,
      //   builder: (BuildContext context) {
      //     return AlertDialog(
      //       backgroundColor: backgroundColor,
      //       title: const Text('Ошибка', style: TextStyle(color: Colors.white)),
      //       content: SingleChildScrollView(
      //         child: ListBody(
      //           children: const <Widget>[
      //             Text('Введите дату и время',
      //                 style: TextStyle(color: Colors.white)),
      //           ],
      //         ),
      //       ),
      //       actions: <Widget>[
      //         TextButton(
      //           child: Text('OK', style: TextStyle(color: Colors.white)),
      //           onPressed: () {
      //             Navigator.of(context).pop();
      //           },
      //         ),
      //       ],
      //     );
      // },
      // );
    } else {
      DateTime deadline = DateTime(pickedDate.year, pickedDate.month,
          pickedDate.day, pickedTime.hour, pickedTime.minute);
      String deadlineMinute;
      bool isAfter = deadline.isAfter(DateTime.now());
      Duration diff = deadline.difference(DateTime.now());
      if (pickedTime.minute.toInt() <= 9) {
        deadlineMinute = "0" + pickedTime.minute.toString();
        String deadlineRes = (deadline.day.toString() +
            "." +
            deadline.month.toString() +
            "." +
            deadline.year.toString() +
            " в " +
            deadline.hour.toString() +
            ":" +
            deadlineMinute);
        return await addTask(dropdownValue, deadlineRes);
      } else {
        String deadlineRes = (deadline.day.toString() +
            "." +
            deadline.month.toString() +
            "." +
            deadline.year.toString() +
            " в " +
            deadline.hour.toString() +
            ":" +
            deadline.minute.toString());
        return addTask(dropdownValue, deadlineRes);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Utils.statusBarColor();
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.light,
            ),
            backwardsCompatibility: false,
            iconTheme: IconThemeData(color: Colors.white),
            title: Text(
              "Редактирование задачи",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: backgroundColor,
          ),
          body: Column(
            children: [
              TextField(
                focusNode: FocusNode(debugLabel: "name_edit"),
                controller: _nameController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Название задачи",
                  contentPadding: EdgeInsets.only(left: 5),
                  hintStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Utils.tagColor(
                            isWhite: false,
                            isDetail: false,
                            drpv: dropdownValue)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Utils.tagColor(
                          isWhite: false, isDetail: false, drpv: dropdownValue),
                    ),
                  ),
                ),
              ),
              TextField(
                focusNode: FocusNode(debugLabel: "text_edit"),
                controller: _textController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Условия задачи",
                  hintStyle: TextStyle(color: Colors.white),
                  contentPadding: EdgeInsets.only(left: 5),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Utils.tagColor(
                            isWhite: false,
                            isDetail: false,
                            drpv: dropdownValue)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Utils.tagColor(
                            isWhite: false,
                            isDetail: false,
                            drpv: dropdownValue)),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(5, 20, 0, 0),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Выберите тег:",
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                child: DropdownButton<String>(
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  dropdownColor: backgroundColor,
                  value: dropdownValue,
                  iconSize: 24,
                  elevation: 16,
                  underline: Container(
                      height: 2,
                      color: Utils.tagColor(
                          isWhite: false,
                          isDetail: false,
                          drpv: dropdownValue)),
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownValue = newValue;
                    });
                  },
                  items: nameToTagMap.keys
                      .toList()
                      .where((element) =>
                          element != tagToNameMap[Tags.CLEAR] &&
                          element != tagToNameMap[Tags.EXPIRED])
                      .map<DropdownMenuItem<String>>((String value) {
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
                    DateTime now = DateTime.now();
                    var lastDate = now.add(const Duration(days: 60));
                    var firstDate = now.subtract(const Duration(days: 5));
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: firstDate,
                      lastDate: lastDate,
                    )
                        .then((value) => pickedDate = value)
                        .then((value) => showTaskTimePicker(pickedDate));
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
                      color: Utils.tagColor(
                          isWhite: false, isDetail: false, drpv: dropdownValue),
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
              Container(
                margin: EdgeInsets.fromLTRB(5, 10, 0, 0),
                alignment: Alignment.center,
                child: Text(
                  Utils.timeHint(
                    pickedDate,
                    pickedTime,
                    isEdit: true,
                    task: widget.task,
                  ),
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ),
              Spacer(),
              InkWell(
                  onTap: () =>
                      deadlineCalc(dropdownValue, pickedDate, pickedTime),
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
                        color: Utils.tagColor(
                            isWhite: false,
                            isDetail: false,
                            drpv: dropdownValue),
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
          backgroundColor: backgroundColor,
        ));
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
        nameToTagMap.keys.firstWhere((k) => nameToTagMap[k] == widget.task.tags.first);
    _nameController.text = widget.task.name;
    _textController.text = widget.task.text;
  }
}
