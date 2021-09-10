
import 'package:dart_task_manager/models/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'user_event.dart';

class UserBloc extends Bloc<UserEvent, User> {
  UserBloc() : super(null);

  @override
  Stream<User> mapEventToState(UserEvent event) async* {
    if (event is SetUserEvent) {
      yield event.user;
    }
    if (event is ClearUserEvent) {
      yield null;
    }
  }
}
