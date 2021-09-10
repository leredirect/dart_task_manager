import 'package:dart_task_manager/models/user.dart';
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
  Priorities priority;
  @HiveField(7)
  User creator;

  Task(this.name, this.text, this.tags, this.creator, this.taskCreateTime, this.taskDeadline,
      this.id, this.priority);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "name": this.name,
      "text": this.text,
      "tag": this.tags.map((e) => e.index).toList(),
      "taskCreateTime": this.taskCreateTime,
      "taskDeadline": this.taskDeadline,
      "id": this.id,
      "priority": priorityToNameMap[this.priority],
      "creator" : this.creator.toJson(),
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
    priority = nameToPriorityMap[json['priority']];
    creator = User.fromJson(json['creator']);
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

@HiveType(typeId: 2)
enum Priorities {
  @HiveField(0)
  HIGH,
  @HiveField(1)
  MEDIUM,
  @HiveField(2)
  LOW,
}

final nameToPriorityMap = {
  "Высокий": Priorities.HIGH,
  "Средний": Priorities.MEDIUM,
  "Низкий": Priorities.LOW,
};

final priorityToNameMap = {
  Priorities.HIGH: "Высокий",
  Priorities.MEDIUM: "Средний",
  Priorities.LOW: "Низкий",
};

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
