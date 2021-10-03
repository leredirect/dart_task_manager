import 'package:dart_task_manager/models/task.dart';
import 'package:dart_task_manager/widgets/task_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskListWidget extends StatelessWidget {
  final List<Task> taskList;
  final Color color;

  const TaskListWidget({Key key, this.taskList, this.color}) : super(key: key);

  int gridAxisCount() {
    switch (taskList.length) {
      case 0:
        return 1;
        break;
      case 1:
        return 1;
        break;
      case 2:
        return 2;
        break;
      default:
        return 2;
        break;
    }
  }

  double gridAxisParameters() {
    switch (taskList.length) {
      case 0:
        return 100;
        break;
      case 1:
        return 100;
        break;
      case 2:
        return 30;
        break;
      default:
        return 30;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.only(left: gridAxisParameters(), right: gridAxisParameters(), top: 20, bottom: 20),
      sliver: SliverGrid.count(
        childAspectRatio: ((MediaQuery.of(context).size.width - 90) / 2) /
            (MediaQuery.of(context).size.height / 4.9),
        mainAxisSpacing: gridAxisParameters(),
        crossAxisSpacing: gridAxisParameters(),
        crossAxisCount: gridAxisCount(),
        children: taskList.map((e) => TaskWidget(task: e, color: this.color)).toList(),
      ),
    );
  }
}
