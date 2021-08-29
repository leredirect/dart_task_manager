import 'package:dart_task_manager/bloc/task_list_bloc/task_list_bloc.dart';
import 'package:dart_task_manager/bloc/task_list_bloc/task_list_event.dart';
import 'package:dart_task_manager/models/task.dart';
import 'package:dart_task_manager/repository/repo.dart';
import 'package:dart_task_manager/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:smart_select/smart_select.dart';

import '../constants.dart';

class CreateNewTaskScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CreateNewTaskScreenState();
}

class _CreateNewTaskScreenState extends State<CreateNewTaskScreen> {
  final _nameController = TextEditingController();
  final _textController = TextEditingController();
  DateTime taskExpiredTime;
  String dropdownValue = nameToTagMap.keys.first;
  DateTime pickedDate;
  TimeOfDay pickedTime;

  Future<void> showTaskTimePicker(DateTime pickedDate) {
    if (pickedDate != null) {
      return showTimePicker(context: context, initialTime: TimeOfDay.now())
          .then((value) => setState(() {
                pickedTime = value;
              }));
    } else {}
  }

  List<int> tagValue = [0];
  Priorities priorityValue = Priorities.LOW;
  List<S2Choice<int>> s2Options = Utils.s2TagsList();
  List<S2Choice<int>> s2Priority = Utils.s2PriorityList();


  Future<void> deadlineCalc(
      String dropdownValue, DateTime pickedDate, TimeOfDay pickedTime) async {
    if (pickedDate == null && pickedTime == null) {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: backgroundColor,
            title: const Text('Ошибка', style: TextStyle(color: Colors.white)),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text('Введите дату и время',
                      style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('OK', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
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
        return await addTask(dropdownValue, deadlineRes, tagValue);
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
        return addTask(dropdownValue, deadlineRes, tagValue);
      }
    }
  }

  Future<void> addTask(String tag, String deadline, List<int> tagValue) async {
    Priorities priority = priorityValue;
    List<Tags> tags = tagValue.map((e) => Tags.values[e]).toList();
    String taskName = _nameController.text;
    String taskText = _textController.text;
    String taskCreateTime = DateFormat.d().format(DateTime.now()) +
        "." +
        DateFormat.M().format(DateTime.now()) +
        "." +
        DateFormat.y().format(DateTime.now()) +
        " в " +
        DateFormat.Hm().format(DateTime.now());

    var idBox = await Hive.openBox<int>('id_box');
    int id = idBox.get('id');
    if (id == null) {
      idBox.put('id', 0);
    } else {
      int id = idBox.get('id');
      idBox.put('id', id + 1);
    }
    Task task =
        Task(taskName, taskText, tags, taskCreateTime, deadline, id, priority);
    print(
        "${task.id}, ${task.name}, ${task.text}, ${task.taskCreateTime}, ${task.taskDeadline}, ${task.priority}, ${task.tags.toString()}");
    context.read<TaskListBloc>().add(AddTaskEvent(task));
    var listBox = await Hive.openBox<List<Task>>('taskList');
    listBox.put('task', context.read<TaskListBloc>().state);
    listBox.close();
    Navigator.of(context).pop();
    Repository repository = new Repository();
    repository.addTask(task);
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
            "Новая задача",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: backgroundColor,
        ),
        body: Column(
          children: [
            TextField(
              focusNode: FocusNode(debugLabel: "name"),
              controller: _nameController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Название задачи",
                contentPadding: EdgeInsets.only(left: 5),
                hintStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: tagValue.isEmpty
                          ? clearColor.withOpacity(0.5)
                          : Utils.tagColor(
                              isWhite: false,
                              isDetail: false,
                              drpv: tagToNameMap[Tags.values[tagValue.first]])),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: tagValue.isEmpty
                        ? clearColor.withOpacity(0.5)
                        : Utils.tagColor(
                            isWhite: false,
                            isDetail: false,
                            drpv: tagToNameMap[Tags.values[tagValue.first]]),
                  ),
                ),
              ),
            ),
            TextField(
              focusNode: FocusNode(debugLabel: "text"),
              controller: _textController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Условия задачи",
                hintStyle: TextStyle(color: Colors.white),
                contentPadding: EdgeInsets.only(left: 5),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: tagValue.isEmpty
                          ? clearColor.withOpacity(0.5)
                          : Utils.tagColor(
                              isWhite: false,
                              isDetail: false,
                              drpv: tagToNameMap[Tags.values[tagValue.first]])),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: tagValue.isEmpty
                          ? clearColor.withOpacity(0.5)
                          : Utils.tagColor(
                              isWhite: false,
                              isDetail: false,
                              drpv: tagToNameMap[Tags.values[tagValue.first]])),
                ),
              ),
            ),
            SmartSelect<int>.multiple(
                tileBuilder: (context, state) {
                  return S2Tile.fromState(
                    state,
                    title: Text("Выберите тег:",
                        style: TextStyle(color: Colors.white)),
                    padding:
                        EdgeInsets.only(left: 5, right: 5, bottom: 0, top: 3),
                  );
                },
                title: "Выберите тег:",
                placeholder: "Выберите один или несколько тэгов",
                choiceStyle: S2ChoiceStyle(
                  titleStyle: TextStyle(color: Colors.black),
                  color: backgroundColor,
                  activeColor: backgroundColor,
                  activeAccentColor: clearColor,
                  accentColor: clearColor,
                ),
                modalStyle: S2ModalStyle(
                  backgroundColor: backgroundColor,
                ),
                modalHeaderStyle: S2ModalHeaderStyle(
                    backgroundColor: backgroundColor,
                    textStyle: TextStyle(color: clearColor)),
                choiceType: S2ChoiceType.chips,
                choiceLayout: S2ChoiceLayout.grid,
                modalType: S2ModalType.bottomSheet,
                value: tagValue,
                choiceItems: s2Options,
                onChange: (state) {
                  setState(() => tagValue = state.value);
                  print(tagValue);
                }),
            SmartSelect<int>.single(
                tileBuilder: (context, state) {
                  return S2Tile.fromState(
                    state,
                    title: Text("Выберите приоритет:",
                        style: TextStyle(color: Colors.white)),
                    padding:
                        EdgeInsets.only(left: 5, right: 5, bottom: 0, top: 3),
                  );
                },
                title: "Выберите приоритет",
                placeholder: "Выберите один или несколько тэгов",
                choiceStyle: S2ChoiceStyle(
                  titleStyle: TextStyle(color: Colors.black),
                  color: backgroundColor,
                  activeColor: backgroundColor,
                  activeAccentColor: clearColor,
                  accentColor: clearColor,
                ),
                modalStyle: S2ModalStyle(
                  backgroundColor: backgroundColor,
                ),
                modalHeaderStyle: S2ModalHeaderStyle(
                    backgroundColor: backgroundColor,
                    textStyle: TextStyle(color: clearColor)),
                choiceType: S2ChoiceType.chips,
                choiceLayout: S2ChoiceLayout.grid,
                modalType: S2ModalType.bottomSheet,
                value: priorityValue.index,
                choiceItems: s2Priority,
                onChange: (state) {
                  setState(() => priorityValue = Priorities.values[state.value]);
                  print(priorityValue);
                }),
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
                    color: tagValue.isEmpty
                        ? clearColor.withOpacity(0.5)
                        : Utils.tagColor(
                            isWhite: false,
                            isDetail: false,
                            drpv: tagToNameMap[Tags.values[tagValue.first]]),
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
                Utils.timeHint(pickedDate, pickedTime, isEdit: false),
                style: TextStyle(
                  color: Colors.white24,
                ),
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
                      color: tagValue.isEmpty
                          ? clearColor.withOpacity(0.5)
                          : Utils.tagColor(
                              isWhite: false,
                              isDetail: false,
                              drpv: tagToNameMap[Tags.values[tagValue.first]]),
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
                ))
          ],
        ),
        backgroundColor: backgroundColor,
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
  }
}
