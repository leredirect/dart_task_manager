import 'package:cloud_firestore/cloud_firestore.dart';

class IdRepository {
  static final IdRepository _idRepository = IdRepository._internal();

  IdRepository._internal();

  factory IdRepository() {
    return _idRepository;
  }

  int userId;
  int taskId;

  Map<String, dynamic> idToJson() {
    return <String, dynamic>{
      "last-user-id": this.userId,
      "last-task-id": this.taskId,
    };
  }

  idFromJson(Map<String, dynamic> json) {
    userId = json['last-user-id'];
    taskId = json['last-task-id'];
  }

  CollectionReference idCollection =
      FirebaseFirestore.instance.collection("ids");

  Future<QuerySnapshot> getStream() {
    return idCollection.get();
  }

  Future<int> getLastCreatedUserId() async {
    Future<QuerySnapshot> collection = this.getStream();
    return collection.asStream().first.then((value) {
      if (value.docs.isNotEmpty) {
        value.docs.forEach((element) {
          idFromJson(element.data());
          this.userId = this.userId + 1;
          idCollection.doc(element.id).update(idToJson());
        });
        return this.userId;
      } else {
        this.userId = 0;
        idCollection.add(this.idToJson());
        return this.userId;
      }
    });
  }

  Future<int> getLastCreatedTaskId() async {
    Future<QuerySnapshot> collection = this.getStream();
    var value = await collection.asStream().first;
      if (value.docs.isNotEmpty) {
        value.docs.forEach((element) {
          idFromJson(element.data());
          this.taskId = this.taskId + 1;
          idCollection.doc(element.id).update(idToJson());
        });
        return this.taskId;
      } else {
        this.taskId = 0;
        idCollection.add(this.idToJson());
        return this.taskId;
      }
  }

}
