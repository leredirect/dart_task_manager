import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task {
  @HiveField(0)
  String name = "";
  @HiveField(1)
  String text = "";
  @HiveField(2)
  List<Tags> tags;
  @HiveField(3)
  String taskCreateTime;
  @HiveField(4)
  String taskDeadline;
  @HiveField(5)
  int id;

  @HiveField(6)
  Task(this.name, this.text, this.tags, this.taskCreateTime, this.taskDeadline,
      this.id);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "name": this.name,
      "text": this.text,
      "tag": this.tags.map((e) => e.index).toList(),
      "taskCreateTime": this.taskCreateTime,
      "taskDeadline": this.taskDeadline,
      "id": this.id,
    };
  }

  Task.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    text = json['text'];
    tags = [];
    json['tag'].forEach((e) {
      tags.add(Tags.values[e]);
    });

    taskCreateTime = json['taskCreateTime'];
    taskDeadline = json['taskDeadline'] as String;
    id = json['id'] as int;
  }
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
  CLEAR,
  @HiveField(4)
  EXPIRED
}

final nameToTagMap = {
  "Flutter": Tags.FLUTTER,
  "Dart": Tags.DART,
  "Алгоритмы": Tags.ALGORITHMS,
  "Нет фильтра": Tags.CLEAR,
  "Истекшие": Tags.EXPIRED,
};

final tagToNameMap = {
  Tags.FLUTTER: "Flutter",
  Tags.DART: "Dart",
  Tags.ALGORITHMS: "Алгоритмы",
  Tags.CLEAR: "Нет фильтра",
  Tags.EXPIRED: "Истекшие",
};
