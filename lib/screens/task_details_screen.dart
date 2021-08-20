import 'package:dart_task_manager/bloc/task_list_bloc/task_list_bloc.dart';
import 'package:dart_task_manager/bloc/task_list_bloc/task_list_event.dart';
import 'package:dart_task_manager/models/task.dart';
import 'package:dart_task_manager/repository/repo.dart';
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
        await Repository().deleteTask(task);
        Navigator.of(context).pop();
      } on Exception catch (e) {
        snackBarNotification(context, e.toString());
        Navigator.of(context).pushNamedAndRemoveUntil("/", (_) => false);
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
      Utils.statusBarColor();
      return Scaffold(
        appBar: AppBar(
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
        body: SingleChildScrollView(
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
                color: Utils.tagColor(
                    isWhite: false, isDetail: true, drpv: null, tag: task.tag),
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
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(left: 10),
              child: FloatingActionButton(
                child: Icon(
                  Icons.delete,
                  color: backgroundColor,
                ),
                onPressed: deleteCurrentTask,
                backgroundColor: Utils.tagColor(
                    isWhite: false, isDetail: true, drpv: null, tag: task.tag),
                heroTag: null,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10),
              child: FloatingActionButton(
                child: Icon(Icons.edit, color: backgroundColor),
                onPressed: openTaskEditor,
                backgroundColor: Utils.tagColor(
                    isWhite: false, isDetail: true, drpv: null, tag: task.tag),
                heroTag: null,
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
      );
    });
  }
}
