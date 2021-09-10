import 'package:dart_task_manager/bloc/task_list_bloc/task_list_bloc.dart';
import 'package:dart_task_manager/bloc/task_list_bloc/task_list_event.dart';
import 'package:dart_task_manager/models/task.dart';
import 'package:dart_task_manager/repository/task_repo.dart';
import 'package:dart_task_manager/screens/task_edit_screen.dart';
import 'package:dart_task_manager/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

    String deadlineDisplay(String deadline) {
      print(task.taskDeadline);
      String result = "Дедлайн: $deadline";
      return result;
    }

    return BlocBuilder<TaskListBloc, List<Task>>(builder: (context, state) {
      Map<String, Function> options = {
        'Редактировать': openTaskEditor,
        'Удалить': deleteCurrentTask,
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
                    child: Text(
                      choice,
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }).toList();
              },
            ),
          ],
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light,
          ),
          backwardsCompatibility: false,
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: backgroundColor,
          title: Text(
            "Детали задачи",
            style: TextStyle(color: Colors.white),
          ),
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
                                style: TextStyle(
                                    fontSize: 30, color: Colors.white),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ],
                      )),
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    height: 2,
                    color: Utils.tagColor(
                        isWhite: false,
                        isDetail: true,
                        drpv: null,
                        tag: task.tags.first),
                  ),
                  Container(
                    child: Text(task.text,
                        style: TextStyle(fontSize: 20, color: Colors.white)),
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
                          child: Text(
                            "Тэги: ${Utils.tagsDisplay(task.tags)}",
                            textAlign: TextAlign.right,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Spacer(),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Создано: ${task.taskCreateTime}",
                            textAlign: TextAlign.right,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Приоритет: ${priorityToNameMap[task.priority]}",
                            textAlign: TextAlign.right,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Spacer(),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "${deadlineDisplay(task.taskDeadline)}",
                            textAlign: TextAlign.right,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Создатель: ${task.creator.login}",
                        textAlign: TextAlign.right,
                        style: TextStyle(color: Colors.grey),
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
