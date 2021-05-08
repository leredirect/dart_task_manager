import 'package:dart_task_manager/models/task.dart';
import 'package:dart_task_manager/widgets/task_widget.dart';
import 'package:flutter/cupertino.dart';

class TaskListWidget extends StatelessWidget {
  final List<Task> taskList;

  const TaskListWidget({Key key, this.taskList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: taskList.map((e) => TaskWidget(task: e)).toList(),

      ),
    );
  }
}
