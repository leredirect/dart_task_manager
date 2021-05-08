import 'package:dart_task_manager/models/task.dart';
import 'package:dart_task_manager/screens/task_details_screen.dart';
import 'package:flutter/material.dart';

class TaskWidget extends StatelessWidget {
  final Task task;

  const TaskWidget({Key key, this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void openTaskDetails() {
      Navigator.push(context, MaterialPageRoute(
        builder: (_) {
          return TaskDetailsScreen(
            task: task,
          );
        },
      ));
    }

    return Row(
      children: [
        InkWell(
          onTap: openTaskDetails,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.redAccent,
            ),
            margin: EdgeInsets.fromLTRB(30, 10, 30, 0),
            width: 350,
            height: 60,
            child: Center(child: Text(task.name, textAlign: TextAlign.center, style: TextStyle(color: Colors.white),)),
          ),
        ),
      ],
    );
  }
}
