import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_task_manager/models/task.dart';
import 'package:dart_task_manager/screens/home_screen.dart';
import 'package:dart_task_manager/utils/utils.dart';

class Repository {
  static final Repository _repository = Repository._internal();

  Repository._internal();

  factory Repository() {
    return _repository;
  }

  final CollectionReference collection =
      //    FirebaseFirestore.instance.collection('tasks');
      FirebaseFirestore.instance.collection("tasks");

  Future<QuerySnapshot> getStream() {
    // return collection.snapshots();
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
