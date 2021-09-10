import 'package:cloud_firestore/cloud_firestore.dart';

class IdRepository {
  static final IdRepository _idRepository = IdRepository._internal();

  IdRepository._internal();

  factory IdRepository() {
    return _idRepository;
  }

  int id;

  Map<String, dynamic> idToJson() {
    return <String, dynamic>{
      "last-id": this.id,
    };
  }

  idFromJson(Map<String, dynamic> json) {
    id = json['last-id'];
  }

  CollectionReference idCollection =
      FirebaseFirestore.instance.collection("ids");

  Future<QuerySnapshot> getStream() {
    return idCollection.get();
  }

  Future<int> getLastCreatedId() async {
    Future<QuerySnapshot> collection = this.getStream();
    return collection.asStream().first.then((value) {
      if (value.docs.isNotEmpty) {
        value.docs.forEach((element) {
          idFromJson(element.data());
          this.id = this.id + 1;
          idCollection.doc(element.id).update(idToJson());
        });
        return this.id;
      } else {
        this.id = 0;
        idCollection.add(this.idToJson());
        return this.id;
      }
    });
  }
}
