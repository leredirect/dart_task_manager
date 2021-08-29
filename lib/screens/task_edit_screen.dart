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
import 'package:smart_select/smart_select.dart';

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

  List<int> tagValue = [0];
  int priorityValue;
  List<S2Choice<int>> s2options = Utils.s2TagsList();
  List<S2Choice<int>> s2Priority = Utils.s2PriorityList();

  Future<void> addTask(String taskTag, String deadline) async {
    List<Tags> tags = tagValue.map((e) => Tags.values[e]).toList();
    widget.task.taskDeadline = deadline;
    String taskName = _nameController.text;
    String taskText = _textController.text;
    widget.task.name = taskName;
    widget.task.text = taskText;
    widget.task.tags = tags;
    widget.task.priority = Priorities.values[priorityValue];
    context.read<TaskListBloc>().add(EditTaskEvent(widget.task));
    context.read<TaskListBloc>().add(EditTaskCheckEvent(widget.task));
    var listBox = await Hive.openBox<List<Task>>('taskList');
    listBox.put('task', context.read<TaskListBloc>().state);
    listBox.close();
    print(
        "${widget.task.id}, ${widget.task.name}, ${widget.task.text}, ${widget.task.taskCreateTime}, ${widget.task.taskDeadline}, ${widget.task.tags.toString()}");
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
                placeholder: "Выберите один или несколько тегов",
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
                choiceItems: s2options,
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
                placeholder: "Выберите один или несколько тегов",
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
                value: priorityValue,
                choiceItems: s2Priority,
                onChange: (state) {
                  setState(() => priorityValue = state.value);
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
    List<int> tags = [];
    widget.task.tags.forEach((e) {
      tags.add(e.index);
    });
    tagValue = tags;
    Priorities selectedPriority = nameToPriorityMap[widget.task.priority];
    priorityValue = selectedPriority.index;
    _nameController.text = widget.task.name;
    _textController.text = widget.task.text;
  }
}
