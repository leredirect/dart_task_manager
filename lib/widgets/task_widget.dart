import 'package:dart_task_manager/constants.dart';
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

    MaterialColor tagColor() {
      switch (task.tag) {
        case Tags.DART:
          return Colors.blueGrey;
          break;
        case Tags.FLUTTER:
          return Colors.pink;
          break;
        case Tags.ALGORITHMS:
          return Colors.cyan;
          break;
      }
    }

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: openTaskDetails,
            child: Container(
              margin: EdgeInsets.fromLTRB(30, 10, 30, 0),
              width: MediaQuery.of(context).size.width * 0.8,
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height * 0.05,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: tagColor()),
                color: secondaryColorLight,
              ),
              child: Center(
                  child: Text(
                task.name,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              )),
            ),
          ),
        ],
      ),
    );
  }
}
