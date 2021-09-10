import 'package:cloud_firestore/cloud_firestore.dart';

class IdsRepository {
  static final IdsRepository _idsRepository =
  IdsRepository._internal();

  IdsRepository._internal();

  factory IdsRepository() {
    return _idsRepository;
  }

  int id;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "last-id": this.id,
    };
  }

  fromJson(Map<String, dynamic> json) {
    id = json['last-id'] as int;
  }

  CollectionReference idCollection =
  FirebaseFirestore.instance.collection("ids");

  Future<QuerySnapshot> getStream() {
    return idCollection.get();
  }

  Future<List<int>> getIdList() async {
    List<int> ids = [];
    Future<QuerySnapshot> collection = IdsRepository().getStream();
    return collection.asStream().first.then((value) {
      if (value.docs.isNotEmpty) {
        value.docs.forEach((element) {
          ids.add(fromJson(element.data()));
        });
        print(ids);
        return ids;
      } else {
        this.id = 0;
        idCollection.add(this.toJson());
        ids.add(0);
        return ids;
      }
    });
  }
  
  
}