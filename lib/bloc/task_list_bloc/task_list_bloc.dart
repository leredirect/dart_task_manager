import 'package:dart_task_manager/bloc/task_list_bloc/task_list_event.dart';
import 'package:dart_task_manager/models/task.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskListBloc extends Bloc<TaskListEvent, List<Task>> {
  TaskListBloc() : super([]);

  @override
  Stream<List<Task>> mapEventToState(TaskListEvent event) async* {
    if (event is AddTaskEvent) {
      List<Task> tasks = List.from(state);
      tasks.add(event.task);

      yield tasks;
    } else if (event is DeleteTaskEvent) {
      List<Task> tasks = List.from(state);
      tasks.remove(event.task);

      yield tasks;
    } else if (event is EditTaskEvent) {
      List<Task> tasks = List.from(state);
      tasks.removeWhere((element) => element.id == event.task.id);
      tasks.add(event.task);
      yield tasks;
    } else if (event is EditTaskCheckEvent) {
      List<Task> tasks = List.from(state);
      yield tasks;
    } else if (event is HiveChecker) {
      yield event.tasks;
    }
  }
}
