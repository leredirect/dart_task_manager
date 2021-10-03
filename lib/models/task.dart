import 'package:dart_task_manager/models/user.dart';
import 'package:dart_task_manager/utils/utils.dart';
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
  DateTime taskCreateTime;
  @HiveField(4)
  DateTime taskDeadline;
  @HiveField(5)
  int id;
  @HiveField(6)
  Priorities priority;
  @HiveField(7)
  User creator;
  @HiveField(8)
  bool isPushed;

  Task(this.name, this.text, this.tags, this.creator, this.taskCreateTime,
      this.taskDeadline, this.id, this.priority,
      [this.isPushed]);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "name": this.name,
      "text": this.text,
      "tag": this.tags.map((e) => e.index).toList(),
      "taskCreateTime": this.taskCreateTime.toString(),
      "taskDeadline": this.taskDeadline.toString(),
      "id": this.id,
      "priority": priorityToNameMap[this.priority],
      "creator": this.creator.toJson(),
    };
  }

  Task.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    text = json['text'];
    tags = [];
    json['tag'].forEach((e) {
      tags.add(Tags.values[e]);
    });
    taskCreateTime = DateTime.parse(json['taskCreateTime']);
    taskDeadline = DateTime.parse(json['taskDeadline']);
    id = json['id'] as int;
    priority = nameToPriorityMap[json['priority']];
    creator = User.fromJson(json['creator']);
    isPushed = true;
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
