import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_task_manager/models/task.dart';

class TaskRepository {
  static final TaskRepository _taskRepository = TaskRepository._internal();

  TaskRepository._internal();

  factory TaskRepository() {
    return _taskRepository;
  }

  final CollectionReference collection =
      FirebaseFirestore.instance.collection("tasks");

  Future<QuerySnapshot> getStream() {
    return collection.get();
  }

  Future<DocumentReference> addTask(Task task) {
    return collection.add(task.toJson());
  }
  Future<DocumentReference> deleteTask(Task task) {
    return collection.where("id", isEqualTo: task.id).get().then((value) {
      if (value.docs.length == 0) {
        throw Exception("Ошибка: Задача была удалена.");
      } else {
        value.docs.forEach((element) {
          collection.doc(element.id).delete();
        });
      }
    });
  }

  Future<DocumentReference> editTask(Task task) {
    return collection.where("id", isEqualTo: task.id).get().then((value) {
      if (value.docs.length == 0) {
        throw Exception("Ошибка: Задача была удалена.");
      } else {
        value.docs.forEach((element) {
          collection.doc(element.id).update(task.toJson());
        });
      }
    });
  }
}
