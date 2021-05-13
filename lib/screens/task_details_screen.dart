import 'package:dart_task_manager/bloc/task_list_bloc/task_list_bloc.dart';
import 'package:dart_task_manager/bloc/task_list_bloc/task_list_event.dart';
import 'package:dart_task_manager/models/task.dart';
import 'package:dart_task_manager/screens/task_edit_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants.dart';

class TaskDetailsScreen extends StatelessWidget {
  final Task task;

  const TaskDetailsScreen({Key key, this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void deleteCurrentTask() {
      context.bloc<TaskListBloc>().add(DeleteTaskEvent(task));
      Navigator.of(context).pop();
    }

    void openTaskEditor() {
      Navigator.push(context, MaterialPageRoute(builder: (_) {
        return EditTaskScreen(
          task: task,
        );
      }));
    }

    // String correctTimeNaming(DateTime deadline) {
    //   Duration difference = DateTime.now().difference(deadline);
    //
    //   String hoursStr = "";
    //   String fmResultStr = difference.toString();
    //   List<String> result = fmResultStr.split('');
    //   int secInt = int.tryParse(result[1]) ?? 0;
    //   print (secInt);
    //   if (secInt == 0) {
    //     hoursStr = "Время не задано";
    //   } else if (secInt == 1) {
    //     hoursStr = "час";
    //   } else if (secInt > 1 && secInt < 5) {
    //     hoursStr = "часа";
    //   } else {
    //     hoursStr = "часов";
    //   }}

    String deadlineDisplay(DateTime deadline) {
      if (deadline == null) {
        String result = "булщит";
        return result;
      } else {
        Duration difference = DateTime.now().difference(deadline);
        String fmResultStr = difference.inHours.toString();
        fmResultStr = fmResultStr.replaceAll("-", "");
        print(fmResultStr);
        String result = "Дедлайн через: $fmResultStr часов";
        return result;
      }
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
                color: secondaryColorLight,
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
                child: Icon(Icons.delete),
                onPressed: deleteCurrentTask,
                backgroundColor: secondaryColorLight,
                heroTag: null,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10),
              child: FloatingActionButton(
                child: Icon(Icons.edit),
                onPressed: openTaskEditor,
                backgroundColor: secondaryColorLight,
                heroTag: null,
              ),
            ),
          ],
        ),
      );
    });
  }
}
