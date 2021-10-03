import 'package:dart_task_manager/bloc/connectivity_bloc/connectivity_bloc.dart';
import 'package:dart_task_manager/bloc/task_list_bloc/task_list_bloc.dart';
import 'package:dart_task_manager/bloc/task_list_bloc/task_list_event.dart';
import 'package:dart_task_manager/bloc/user_bloc/user_bloc.dart';
import 'package:dart_task_manager/bloc/validation_bloc/login_bloc.dart';
import 'package:dart_task_manager/bloc/validation_bloc/task_data_bloc/task_data_bloc.dart';
import 'package:dart_task_manager/models/task.dart';
import 'package:dart_task_manager/models/user.dart';
import 'package:dart_task_manager/repository/ids_repo.dart';
import 'package:dart_task_manager/repository/task_repo.dart';
import 'package:dart_task_manager/utils/utils.dart';
import 'package:dart_task_manager/widgets/text_button.dart';
import 'package:dart_task_manager/widgets/text_forms/date_time_input_widget.dart';
import 'package:dart_task_manager/widgets/text_forms/text_input_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:hive/hive.dart';
import 'package:smart_select/smart_select.dart';
import 'package:uiblock/uiblock.dart';

import '../constants.dart';

class CreateNewTaskScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CreateNewTaskScreenState();
}

class _CreateNewTaskScreenState extends State<CreateNewTaskScreen> {
  DateTime taskExpiredTime;
  String dropdownValue = nameToTagMap.keys.first;
  DateTime pickedDate;
  TimeOfDay pickedTime;
  FocusNode nameNode = FocusNode();
  FocusNode textNode = FocusNode();
  FocusNode dateNode = FocusNode();
  List<Tags> tagValue;
  Priorities priorityValue;
  List<S2Choice<int>> s2Options = Utils.s2TagsList();
  List<S2Choice<int>> s2Priority = Utils.s2PriorityList();

  Future<void> addTask() async {
    String taskName = context.read<TaskDataBloc>().name.value;
    String taskText = context.read<TaskDataBloc>().text.value;
    User user = context.read<UserBloc>().state;
    DateTime taskCreateTime = DateTime.now();
    int id = await IdRepository().getLastCreatedTaskId();
    bool isOnline = context.read<ConnectivityBloc>().state;
    DateTime deadline = context.read<TaskDataBloc>().deadline.value;
    List<Tags> tags = tagValue.toSet().toList();
    Task task;

      task = Task(taskName, taskText, tags, user, taskCreateTime, deadline,
          id, priorityValue, isOnline);


    context.read<TaskListBloc>().add(AddTaskEvent(task));
    var listBox = await Hive.openBox<List<Task>>('taskList');
    listBox.put('task', context.read<TaskListBloc>().state);
    listBox.close();
    Navigator.of(context).pop();
    TaskRepository repository = new TaskRepository();
    repository.addTask(task);
    context.read<TaskDataBloc>().clear();
  }

  @override
  Widget build(BuildContext context) {
    Utils.statusBarColor();
    return Builder(builder: (context) {
      var taskDataBloc = BlocProvider.of<TaskDataBloc>(context);
      return FormBlocListener<TaskDataBloc, String, String>(
        onSubmitting: (context, state) {
          UIBlock.block(context);
        },
        onSuccess: (context, state) async {
          snackBarNotification(context, "создание задачи...", duration: 1);
          addTask();
          await Future.delayed(Duration(milliseconds: 500));
          UIBlock.unblock(context);
          snackBarNotification(context, "задача создана.", duration: 1);
          context.read<LoginFormBloc>().clear();
        },
        onFailure: (context, state) {
          UIBlock.unblock(context);
          snackBarNotification(context, state.failureResponse, duration: 1);
        },
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            appBar: AppBar(
              systemOverlayStyle: Utils.statusBarColor(),
              iconTheme: IconThemeData(color: Colors.white),
              title: Text("новая задача", style: headerText),
              backgroundColor: backgroundColor,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: TextInputWidget(
                      textFieldBloc: taskDataBloc.name,
                      focusNode: nameNode,
                      helperText: 'название',
                      onEditingComplete: () {
                        FocusScope.of(context).requestFocus(textNode);
                      },
                      isExpandable: false,
                    ),
                  ),
                  TextInputWidget(
                    textFieldBloc: taskDataBloc.text,
                    focusNode: textNode,
                    helperText: 'текст',
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus(dateNode);
                    },
                    isExpandable: true,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SmartSelect<int>.multiple(
                      tileBuilder: (context, state) {
                        return S2Tile.fromState(
                          state,
                          title: Text("выберите тег:", style: standartText),
                          padding: EdgeInsets.only(
                              left: 5, right: 5, bottom: 0, top: 3),
                        );
                      },
                      title: "выберите тег:",
                      placeholder: "выберите один или несколько тэгов",
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
                      value: tagValue.map((e) => e.index).toList(),
                      choiceItems: s2Options,
                      onChange: (state) {
                        tagValue = [];
                        setState(() => state.value.forEach((e) {
                              tagValue.add(Tags.values[e]);
                            }));
                      }),
                  SmartSelect<int>.single(
                      tileBuilder: (context, state) {
                        return S2Tile.fromState(
                          state,
                          title:
                              Text("выберите приоритет:", style: standartText),
                          padding: EdgeInsets.only(
                              left: 5, right: 5, bottom: 0, top: 3),
                        );
                      },
                      title: "выберите приоритет",
                      placeholder: "выберите приоритет",
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
                        setState(() =>
                            priorityValue = Priorities.values[state.value]);
                      }),
                  DateTimeInputWidget(
                    focusNode: dateNode,
                    helperText: 'дата окончания:',
                    onEditingComplete: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    isExpandable: true,
                    dateTimeFormBloc: taskDataBloc.deadline,
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  TextButtonWidget(
                    onPressed: () {
                      taskDataBloc.submit();
                    },
                    borderColor: Colors.white,
                    text: "создать",
                    textColor: Colors.white,
                  ),
                ],
              ),
            ),
            backgroundColor: backgroundColor,
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    priorityValue = Priorities.LOW;
    tagValue = [Tags.DART];
  }
}
