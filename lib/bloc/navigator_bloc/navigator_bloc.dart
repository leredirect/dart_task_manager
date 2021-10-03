import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'navigator_event.dart';

class NavigatorBloc extends Bloc<NavigatorEvent, dynamic> {
  final GlobalKey<NavigatorState> navigatorKey;

  NavigatorBloc({this.navigatorKey}) : super(null);

  dynamic get initialState => 0;

  @override
  Stream<dynamic> mapEventToState(NavigatorEvent event) async* {
    if (event is NavigatorPop) {
      navigatorKey.currentState.pop();
    } else if (event is NavigatorPushNamed) {
      navigatorKey.currentState.pushNamed(event.route);
    } else if (event is NavigatorPushNamedAndRemoveUntil) {
      navigatorKey.currentState
          .pushNamedAndRemoveUntil(event.route, (route) => false);
    }
  }
}
