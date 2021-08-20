import 'package:dart_task_manager/models/task.dart';
import 'package:dart_task_manager/widgets/task_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

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
    return AnimationConfiguration.synchronized(
      duration: const Duration(milliseconds: 500),
      child: SlideAnimation(
        horizontalOffset: 50.0,
        child: FadeInAnimation(
          child: GridView.count(
            padding: EdgeInsets.fromLTRB(
                gridAxisParameters(),
                gridAxisParameters(),
                gridAxisParameters(),
                gridAxisParameters()),
            mainAxisSpacing: gridAxisParameters(),
            crossAxisSpacing: gridAxisParameters(),
            crossAxisCount: gridAxisCount(),
            children: taskList.map((e) => TaskWidget(task: e)).toList(),
          ),
        ),
      ),
    );
  }
}
