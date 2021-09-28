import 'package:dart_task_manager/models/task.dart';
import 'package:dart_task_manager/utils/utils.dart';
import 'package:dart_task_manager/widgets/task_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class GridViewWidget extends StatelessWidget {
  final List<Task> state;
  final Tags filtState;
  final Priorities priority;

  GridViewWidget(this.state, this.filtState, [this.priority]);

  @override
  Widget build(BuildContext context) {
    if (this.priority != null) {
      if (this.filtState != null) {
        List<Task> filtredState = this
            .state
            .where((element) => element.tags.contains(filtState))
            .toList();
        List<Task> priorititedFiltredState = filtredState
            .where((element) => element.priority == this.priority)
            .toList();
        priorititedFiltredState.removeWhere((element) => element.taskDeadline.isBefore(DateTime.now()));
        if (priorititedFiltredState.isNotEmpty) {
          return TaskListWidget(taskList: priorititedFiltredState,color: taskColorDark);
        } else {
          return SliverToBoxAdapter(
            child: Container(
                margin:
                    EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
                child: Text(
                    "нет задач c фильтром ${tagToNameMap[this.filtState]}",
                    style: standartText)),
          );
        }
      } else {
        List<Task> priorititedFiltredState = this
            .state
            .where((element) => element.priority == this.priority)
            .toList();

        priorititedFiltredState.removeWhere((element) => element.taskDeadline.isBefore(DateTime.now()));
        if (priorititedFiltredState.isNotEmpty) {
          return TaskListWidget(taskList: priorititedFiltredState, color: taskColorDark);
        } else {
          return SliverToBoxAdapter(
            child: Container(
                margin:
                    EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
                child: Text("нет задач", style: standartText)),
          );
        }
      }
    } else {
      List<Task> expiredTasksState = this
          .state
          .where((element) => element.taskDeadline.isBefore(DateTime.now()))
          .toList();
      if (expiredTasksState.isNotEmpty) {
        return TaskListWidget(taskList: expiredTasksState, color: Colors.grey);
      } else {
        return SliverToBoxAdapter(
          child: Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
              child: Text("нет просроченных задач", style: standartText)),
        );
      }
    }
  }
}
