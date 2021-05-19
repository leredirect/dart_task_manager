class Task {
  String name = "";
  String text = "";
  Tags tag;
  var taskCreateTime;
  String taskDeadline;
  int id;


  Task(this.name, this.text, this.tag, this.taskCreateTime, this.taskDeadline, this.id);
}

enum Tags { DART, FLUTTER, ALGORITHMS }

final tagsMap = {
  "Flutter": Tags.FLUTTER,
  "Dart": Tags.DART,
  "Алгоритмы": Tags.ALGORITHMS,
};
