import 'package:dart_task_manager/models/task.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'filter_event.dart';

class FilterBloc extends Bloc<FilterEvent, Tags> {
  FilterBloc() : super(null);

  @override
  Stream<Tags> mapEventToState(FilterEvent event) async* {
    if (event is FilterChecker) {
      yield event.tag;
    }
    if (event is ClearFilter) {
      yield null;
    }
  }
}
