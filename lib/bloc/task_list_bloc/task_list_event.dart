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
