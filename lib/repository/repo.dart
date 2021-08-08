import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_task_manager/models/task.dart';

class Repository {
  static final Repository _repository = Repository._internal();

  Repository._internal();

  factory Repository() {
    return _repository;
  }

  final CollectionReference collection =
      FirebaseFirestore.instance.collection('tasks');

  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }

  Future<DocumentReference> addTask(Task task) {
    return collection.add(task.toJson());
  }

  Future<DocumentReference> deleteTask(Task task){
    return collection.where("id", isEqualTo : task.id).get().then((value){value.docs.forEach((element){
        collection.doc(element.id).delete();
      });
    });
  }
  Future<DocumentReference> editTask(Task task){
    return collection.where("id", isEqualTo : task.id).get().then((value){value.docs.forEach((element){
      collection.doc(element.id).update(task.toJson());
    });
    });
  }
}
