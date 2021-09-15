import 'package:dart_task_manager/models/task.dart';

class TaskListEvent {}

class AddTaskEvent extends TaskListEvent {
  Task task;

  AddTaskEvent(this.task);
}

class DeleteTaskEvent extends TaskListEvent {
  Task task;

  DeleteTaskEvent(this.task);
}

class EditTaskEvent extends TaskListEvent {
  Task task;

  EditTaskEvent(this.task);
}

class EditTaskCheckEvent extends TaskListEvent {
  Task task;
//101
  EditTaskCheckEvent(this.task);
}

class HiveChecker extends TaskListEvent {
  List<Task> tasks;
//101
  HiveChecker(this.tasks);
}

class DeleteAllTasksEvent extends TaskListEvent {
  List<Task> tasks;
//101
  DeleteAllTasksEvent(this.tasks);
}
