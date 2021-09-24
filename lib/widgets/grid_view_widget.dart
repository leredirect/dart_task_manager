import 'package:dart_task_manager/models/task.dart';
import 'package:dart_task_manager/utils/utils.dart';
import 'package:dart_task_manager/widgets/task_list_widget.dart';
import 'package:dart_task_manager/widgets/task_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../constants.dart';

class GridViewWidget extends StatelessWidget {
  final List<Task> state;
  final Tags filtState;
  final Priorities priority;

  GridViewWidget(this.state, this.filtState, this.priority);

  @override
  Widget build(BuildContext context) {
    if (this.filtState != null) {
      List<Task> filtredState = this.state
          .where((element) => element.tags.contains(filtState))
          .toList();
      List<Task> priorititedFiltredState = filtredState
          .where((element) => element.priority == this.priority)
          .toList();
      if (priorititedFiltredState.isNotEmpty) {
        return TaskListWidget(taskList: priorititedFiltredState);
      } else {
        return SliverToBoxAdapter(
          child: Container(
              margin: EdgeInsets.only(
                  left: 10, right: 10, top: 20, bottom: 20),
              child: Text("нет задач c фильтром ${tagToNameMap[this.filtState]}", style: standartText)),
        );
      }
    } else {
      List<Task> priorititedFiltredState = this.state
          .where((element) => element.priority == this.priority)
          .toList();
      if (priorititedFiltredState.isNotEmpty) {
        return TaskListWidget(taskList: priorititedFiltredState);
      } else {
        return SliverToBoxAdapter(
          child: Container(
              margin: EdgeInsets.only(
                  left: 10, right: 10, top: 20, bottom: 20),
              child: Text("нет задач", style: standartText)),
        );
      }
    }
  }


}
