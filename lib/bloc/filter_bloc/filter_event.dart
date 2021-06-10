import 'package:dart_task_manager/models/task.dart';

class FilterEvent {}

class FilterChecker extends FilterEvent {
  Tags tag;

  FilterChecker(this.tag);
}

class ClearFilter extends FilterEvent {
  Tags tag;

  ClearFilter(this.tag);
}
