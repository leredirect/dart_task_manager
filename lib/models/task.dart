class Task {
  String name = "";
  String text = "";
  Tags tag;
  var taskCreateTime;
  var taskExpiredTime;

  Task(this.name, this.text, this.tag, this.taskCreateTime,
      this.taskExpiredTime);
}

enum Tags {
  DART,
  FLUTTER,
  ALGORITHMS
}

final tagsMap = {
  "Flutter": Tags.FLUTTER,
  "Dart": Tags.DART,
  "Алгоритмы": Tags.ALGORITHMS,
};