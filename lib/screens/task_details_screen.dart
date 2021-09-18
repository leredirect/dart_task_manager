import 'package:dart_task_manager/bloc/task_list_bloc/task_list_bloc.dart';
import 'package:dart_task_manager/bloc/task_list_bloc/task_list_event.dart';
import 'package:dart_task_manager/models/task.dart';
import 'package:dart_task_manager/repository/task_repo.dart';
import 'package:dart_task_manager/screens/task_edit_screen.dart';
import 'package:dart_task_manager/utils/utils.dart';
import 'package:dart_task_manager/widgets/text_widgets/default_text_widget.dart';
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
                    child: TextWidget(
                     text: choice,
                    ),
                  );
                }).toList();
              },
            ),
          ],
          systemOverlayStyle: Utils.statusBarColor(),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: backgroundColor,
          title: TextWidget(
            text: "Детали задачи",
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
                              child: TextWidget(
                                text: task.name,
                                fontSize: 30,
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
                    child: TextWidget(text: task.text,
                        fontSize: headerText),
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
                          child: TextWidget(
                            text: "Тэги: ${Utils.tagsDisplay(task.tags)}",
                            color: Colors.grey),
                          ),
                        Spacer(),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          alignment: Alignment.centerLeft,
                          child: TextWidget(
                            text: "Создано: ${task.taskCreateTime}",
                           color: Colors.grey
                        ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          alignment: Alignment.centerLeft,
                          child: TextWidget(
                            text: "Приоритет: ${priorityToNameMap[task.priority]}",
                            color: Colors.grey
                          ),
      ),
                        Spacer(),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          alignment: Alignment.centerLeft,
                          child: TextWidget(
                            text: "${deadlineDisplay(task.taskDeadline)}",
                          color: Colors.grey
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      alignment: Alignment.centerLeft,
                      child: TextWidget(
                        text: "Создатель: ${task.creator.login}",
                        color: Colors.grey
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
