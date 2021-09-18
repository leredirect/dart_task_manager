abstract class NavigatorEvent {}

class NavigatorPop extends NavigatorEvent {}

class NavigatorPushNamed extends NavigatorEvent {
  final String route;

  NavigatorPushNamed(this.route);
}

class NavigatorPushNamedAndRemoveUntil extends NavigatorEvent {
  final String route;

  NavigatorPushNamedAndRemoveUntil(this.route);
}
