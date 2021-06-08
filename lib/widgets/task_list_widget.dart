import 'package:dart_task_manager/models/task.dart';
import 'package:dart_task_manager/widgets/task_widget.dart';
import 'package:flutter/cupertino.dart';

class TaskListWidget extends StatelessWidget {
  final List<Task> taskList;

  const TaskListWidget({Key key, this.taskList}) : super(key: key);

  int gridAxisCount() {
    switch (taskList.length) {
      case 0:
        return 1;
        break;
      case 1:
        return 1;
      case 2:
        return 2;
      case 3:
        return 3;
      default:
        return 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      crossAxisCount: gridAxisCount(),
      children: taskList.map((e) => TaskWidget(task: e)).toList(),
    );
  }
}
