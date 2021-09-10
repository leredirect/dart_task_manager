import 'package:cloud_firestore/cloud_firestore.dart';

class IdsRepository {
  static final IdsRepository _idsRepository = IdsRepository._internal();

  IdsRepository._internal();

  factory IdsRepository() {
    return _idsRepository;
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

  Future<int> getIdList() async {
    Future<QuerySnapshot> collection = IdsRepository().getStream();
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
