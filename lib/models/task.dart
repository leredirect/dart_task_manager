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
  ALGORITHMS
}

final tagsMap = {
  "Flutter": Tags.FLUTTER,
  "Dart": Tags.DART,
  "Алгоритмы": Tags.ALGORITHMS,
};
