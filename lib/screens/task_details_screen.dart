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
      Navigator.push(context, MaterialPageRoute(
          builder: (_) {
            return EditTaskScreen(
              task: task,
            );
          }
      ));
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
                    Text(
                      task.name,
                      style: TextStyle(fontSize: 25),
                      textAlign: TextAlign.left,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Text(
                        "Тэг: ${task.tag}",
                        style: TextStyle(color: Colors.grey),
                      ),
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
            margin: EdgeInsets.only(left:10),
            child: FloatingActionButton(
              child: Icon(Icons.delete),
              onPressed: deleteCurrentTask,
              backgroundColor: Colors.redAccent,
              heroTag: null,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left:10),
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
