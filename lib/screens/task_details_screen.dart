import 'package:dart_task_manager/bloc/task_list_bloc/task_list_bloc.dart';
import 'package:dart_task_manager/bloc/task_list_bloc/task_list_event.dart';
import 'package:dart_task_manager/models/task.dart';
import 'package:dart_task_manager/repository/task_repo.dart';
import 'package:dart_task_manager/screens/task_edit_screen.dart';
import 'package:dart_task_manager/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:hive/hive.dart';

import '../constants.dart';

class TaskDetailsScreen extends StatelessWidget {
  final Task task;

  const TaskDetailsScreen({Key key, this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<void> deleteCurrentTask() async {
      context.read<TaskListBloc>().add(DeleteTaskEvent(task));
      var listBox = await Hive.openBox<List<Task>>('taskList');
      listBox.put('task', context.read<TaskListBloc>().state);
      listBox.close();

      try {
        await TaskRepository().deleteTask(task);
        Navigator.of(context).pop();
      } on Exception catch (e) {
        snackBarNotification(context, e.toString());
        Navigator.of(context)
            .pushNamedAndRemoveUntil("homeScreen", (_) => false);
      }
    }

    void openTaskEditor() {
      Navigator.push(context, MaterialPageRoute(builder: (_) {
        return EditTaskScreen(
          task: task,
        );
      }));
    }

    return BlocBuilder<TaskListBloc, List<Task>>(builder: (context, state) {
      Map<String, Function> options = {
        'редактировать': openTaskEditor,
        'удалить': deleteCurrentTask,
      };
      Utils.statusBarColor();
      return Scaffold(
        appBar: AppBar(
          actions: [
            PopupMenuButton<String>(
              color: backgroundColor,
              icon: Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              onSelected: (String value) {
                options[value]();
              },
              itemBuilder: (BuildContext context) {
                return options.keys.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice, style: standartText),
                  );
                }).toList();
              },
            ),
          ],
          systemOverlayStyle: Utils.statusBarColor(),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: backgroundColor,
          title: Text("детали задачи", style: headerText),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Container(
                              child: Text(
                                task.name,
                                style: bigText,
                              ),
                            ),
                          ),
                        ],
                      )),
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    height: 2,
                    color: taskColorDark,
                  ),
                  Container(
                    child: Text(task.text, style: headerText),
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(
                        left: 15,
                        bottom: MediaQuery.of(context).size.height / 7),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.only(right: 10, left: 10),
                color: snackBarColor,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 7.5,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          alignment: Alignment.centerLeft,
                          child: Text("теги: ${Utils.tagsDisplay(task.tags)}",
                              style: smallLetterSpacingStandartGreyText),
                        ),
                        Spacer(),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          alignment: Alignment.centerLeft,
                          child: Text(
                              "создано: ${DateFormat('dd-MM-yyyy в kk:mm').format(task.taskCreateTime).toString()}",
                              style: smallLetterSpacingStandartGreyText),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          alignment: Alignment.centerLeft,
                          child: Text(
                              "приоритет: ${priorityToNameMap[task.priority]}",
                              style: smallLetterSpacingStandartGreyText),
                        ),
                        Spacer(),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          alignment: Alignment.centerLeft,
                          child: Text(
                              "дедлайн: ${DateFormat('dd-MM-yyyy в kk:mm').format(task.taskDeadline).toString()}",
                              style: smallLetterSpacingStandartGreyText),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "создатель: ${task.creator.login}",
                        style: smallLetterSpacingStandartGreyText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
      );
    });
  }
}
