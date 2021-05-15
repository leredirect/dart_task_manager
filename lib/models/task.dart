class Task {
  String name = "";
  String text = "";
  Tags tag;
  var taskCreateTime;
  String taskDeadline;

  Task(this.name, this.text, this.tag, this.taskCreateTime, this.taskDeadline);

  Task.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    text = json['text'];
    tag = tagsMap[json['tag']];
    taskCreateTime = json['taskCreateTime'];
    taskDeadline = json['taskDeadline'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['text'] = this.text;

    data['tag'] = tagsMap.keys.firstWhere((k) => tagsMap[k] == this.tag);
    data['taskCreateTime'] = this.taskCreateTime;
    data['taskDeadline'] = this.taskDeadline;
    return data;
  }

}

enum Tags { DART, FLUTTER, ALGORITHMS }

final tagsMap = {
  "Flutter": Tags.FLUTTER,
  "Dart": Tags.DART,
  "Алгоритмы": Tags.ALGORITHMS,
};

dynamic taskListToJson(List<Task> tasks){
  final Map<String, dynamic> data = new Map<String, dynamic>();
  if (tasks != null) {
    data['tasks'] = tasks.map((v) => v.toJson()).toList();
  }
  return data;
}