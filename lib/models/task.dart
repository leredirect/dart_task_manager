import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task {
  @HiveField(0)
  String name = "";
  @HiveField(1)
  String text = "";
  @HiveField(2)
  Tags tag;
  @HiveField(3)
  String taskCreateTime;
  @HiveField(4)
  String taskDeadline;
  @HiveField(5)
  int id;

  Task(this.name, this.text, this.tag, this.taskCreateTime, this.taskDeadline,
      this.id);
}

@HiveType(typeId: 1)
enum Tags {
  @HiveField(0)
  DART,
  @HiveField(1)
  FLUTTER,
  @HiveField(2)
  ALGORITHMS,
  @HiveField(3)
  CLEAR
}

final nameToTagMap = {
  "Flutter": Tags.FLUTTER,
  "Dart": Tags.DART,
  "Алгоритмы": Tags.ALGORITHMS,
  "Нет фильтра": Tags.CLEAR
};

final tagToNameMap = {
  Tags.FLUTTER: "Flutter",
  Tags.DART: "Dart",
  Tags.ALGORITHMS: "Алгоритмы",
  Tags.CLEAR: "Нет фильтра"
};
