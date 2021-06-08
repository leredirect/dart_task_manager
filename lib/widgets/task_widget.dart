import 'package:dart_task_manager/models/task.dart';
import 'package:dart_task_manager/screens/task_details_screen.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

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

    return Container(
      child: InkWell(
        onTap: openTaskDetails,
        child: Container(
          color: tagColor(),
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  task.name,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.black, fontSize: 25),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
