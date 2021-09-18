import 'package:dart_task_manager/models/user.dart';

class UserEvent {}

class SetUserEvent extends UserEvent {
  User user;

  SetUserEvent(this.user);
}

class ClearUserEvent extends UserEvent {}
