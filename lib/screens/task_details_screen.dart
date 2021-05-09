import 'package:dart_task_manager/bloc/task_list_bloc/task_list_bloc.dart';
import 'package:dart_task_manager/bloc/task_list_bloc/task_list_event.dart';
import 'package:dart_task_manager/models/task.dart';
import 'package:dart_task_manager/screens/task_edit_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

    String correctTimeNaming(taskExpiredTime){
      taskExpiredTime = taskExpiredTime.toString();
      List<String> result = taskExpiredTime.split('');
      int secint = int.parse(result[1]);

        // // taskExpiredTime = int.parse(taskExpiredTime);
        String hoursStr = "";

      if (secint == 1){
         hoursStr = "час";
      }
      else if (secint > 1 && secint < 5){
         hoursStr = "часа";
      }
      else{
         hoursStr = "часов";
      }
      return hoursStr;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
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
                    Row(
                      children: [
                        Text(
                          task.name,
                          style: TextStyle(fontSize: 25),
                          textAlign: TextAlign.left,
                        ),
                        Spacer(),
                        Container(
                          // color: Colors.red,
                          alignment: Alignment.centerRight,
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
                          margin: EdgeInsets.only(top: 5),
                          child: Text(
                            "Тэг: ${task.tag}",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Spacer(),
                        Container(
                          // color: Colors.red,
                          alignment: Alignment.centerRight,
                          child: Text(
                            "На выполнение: ${task.taskExpiredTime} ${correctTimeNaming(task.taskExpiredTime)}",
                            textAlign: TextAlign.right,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              height: 2,
              color: Colors.redAccent,
            ),
            Container(
              child: Text(task.text,
                  style: TextStyle(fontSize: 20, color: Colors.black)),
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
              child: Icon(Icons.delete),
              onPressed: deleteCurrentTask,
              backgroundColor: Colors.redAccent,
              heroTag: null,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: FloatingActionButton(
              child: Icon(Icons.edit),
              onPressed: openTaskEditor,
              backgroundColor: Colors.redAccent,
              heroTag: null,
            ),
          ),
        ],
      ),
    );
  }
}
