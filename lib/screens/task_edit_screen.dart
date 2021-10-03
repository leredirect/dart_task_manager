import 'package:dart_task_manager/bloc/connectivity_bloc/connectivity_bloc.dart';
import 'package:dart_task_manager/bloc/task_list_bloc/task_list_bloc.dart';
import 'package:dart_task_manager/bloc/task_list_bloc/task_list_event.dart';
import 'package:dart_task_manager/bloc/validation_bloc/login_bloc.dart';
import 'package:dart_task_manager/bloc/validation_bloc/task_data_bloc/task_data_bloc.dart';
import 'package:dart_task_manager/models/task.dart';
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

class EditTaskScreen extends StatefulWidget {
  final Task task;

  const EditTaskScreen({Key key, this.task}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  DateTime taskExpiredTime;
  DateTime pickedDate;
  TimeOfDay pickedTime;
  FocusNode nameNode = FocusNode();
  FocusNode textNode = FocusNode();
  FocusNode dateNode = FocusNode();
  List<Tags> tagValue;
  Priorities priorityValue;
  List<S2Choice<int>> s2Options = Utils.s2TagsList();
  List<S2Choice<int>> s2Priority = Utils.s2PriorityList();

  Future<void> editTask() async {
    bool isOnline = context.read<ConnectivityBloc>().state;
    widget.task.priority = priorityValue;
    widget.task.name = context.read<TaskDataBloc>().name.value;
    widget.task.text = context.read<TaskDataBloc>().text.value;
    widget.task.tags = tagValue;
    widget.task.taskDeadline = context.read<TaskDataBloc>().deadline.value;
    widget.task.isPushed = isOnline;

    context.read<TaskListBloc>().add(EditTaskEvent(widget.task));

    var listBox = await Hive.openBox<List<Task>>('taskList');
    listBox.put('task', context.read<TaskListBloc>().state);
    listBox.close();

    try {
      await TaskRepository().editTask(widget.task);
      Navigator.of(context).pop();
    } on Exception catch (e) {
      snackBarNotification(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    Utils.statusBarColor();
    return Builder(builder: (context) {
      var taskDataBloc = BlocProvider.of<TaskDataBloc>(context);
      return FormBlocListener<TaskDataBloc, String, String>(
        onSubmitting: (context, state) {
          UIBlock.block(context,
              customLoaderChild: CircularProgressIndicator(
                backgroundColor: backgroundColor,
                valueColor: AlwaysStoppedAnimation<Color>(taskColorDark),
              ));
        },
        onSuccess: (context, state) async {
          await editTask();
          await Future.delayed(Duration(milliseconds: 500));
          UIBlock.unblock(context);
          snackBarNotification(context, "задача отредактирована.", duration: 1);
          context.read<LoginFormBloc>().clear();
          Navigator.of(context).pushNamedAndRemoveUntil("/", (_) => false);
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
              title: Text("редактировать задачу", style: headerText),
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
                    text: "редактировать",
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
    priorityValue = widget.task.priority;
    tagValue = widget.task.tags;
    context.read<TaskDataBloc>().name.updateValue(widget.task.name);
    context.read<TaskDataBloc>().text.updateValue(widget.task.text);
    context.read<TaskDataBloc>().deadline.updateValue(widget.task.taskDeadline);
  }
}
