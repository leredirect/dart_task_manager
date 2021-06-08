import 'package:dart_task_manager/bloc/task_list_bloc/task_list_bloc.dart';
import 'package:dart_task_manager/bloc/task_list_bloc/task_list_event.dart';
import 'package:dart_task_manager/models/task.dart';
import 'package:dart_task_manager/screens/task_edit_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import '../constants.dart';

class TaskDetailsScreen extends StatelessWidget {
  final Task task;

  const TaskDetailsScreen({Key key, this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<void> deleteCurrentTask() async {
      context.bloc<TaskListBloc>().add(DeleteTaskEvent(task));
      var listBox = await Hive.openBox<List<Task>>('taskList');
      listBox.put('task', context.bloc<TaskListBloc>().state);
      listBox.close();
      Navigator.of(context).pop();
    }

    dynamic tagColor() {
      switch (task.tag) {
        case Tags.DART:
          return Colors.indigoAccent;
          break;
        case Tags.FLUTTER:
          return Colors.deepPurpleAccent;
          break;
        case Tags.ALGORITHMS:
          return Colors.cyanAccent.withOpacity(0.7);
          break;
        case Tags.CLEAR:
          return primaryColor;
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
      return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text("Детали задачи"),
        ),
        body: Center(
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
                            style: TextStyle(fontSize: 30, color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      // Container(
                      //   margin: EdgeInsets.only(top: 5),
                      //   child: Text(
                      //     "Тэг: ${task.tag}",
                      //     style: TextStyle(color: Colors.grey),
                      //   ),
                      // ),
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Создано: ${task.taskCreateTime}",
                              textAlign: TextAlign.right,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
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
                  )),
              Container(
                margin: EdgeInsets.only(bottom: 20),
                height: 2,
                color: tagColor(),
              ),
              Container(
                child: Text(task.text,
                    style: TextStyle(fontSize: 20, color: Colors.white)),
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: 15),
              ),
            ],
          ),
        ),
        backgroundColor: primaryColorDark,
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(left: 10),
              child: FloatingActionButton(
                child: Icon(
                  Icons.delete,
                  color: primaryColor,
                ),
                onPressed: deleteCurrentTask,
                backgroundColor: tagColor(),
                heroTag: null,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10),
              child: FloatingActionButton(
                child: Icon(Icons.edit, color: primaryColor),
                onPressed: openTaskEditor,
                backgroundColor: tagColor(),
                heroTag: null,
              ),
            ),
          ],
        ),
      );
    });
  }
}
