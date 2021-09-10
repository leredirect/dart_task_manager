import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_task_manager/models/user.dart';

class AuthorisationRepository {
  static final AuthorisationRepository _authorisationRepository =
      AuthorisationRepository._internal();

  AuthorisationRepository._internal();

  factory AuthorisationRepository() {
    return _authorisationRepository;
  }

  CollectionReference collection =
      FirebaseFirestore.instance.collection("users");

  Future<QuerySnapshot> getStream() {
    return collection.get();
  }

  Future<DocumentReference> addUser(User user) {
    return collection.add(user.toJson());
  }

  Future<DocumentReference> deleteUser(User user) {
    return collection.where("id", isEqualTo: user.id).get().then((value) {
      if (value.docs.length == 0) {
        throw Exception("Ошибка: Пользователь не найден.");
      } else {
        value.docs.forEach((element) {
          collection.doc(element.id).delete();
        });
      }
    });
  }

  Future<DocumentReference> editUser(User user) {
    return collection.where("id", isEqualTo: user.id).get().then((value) {
      if (value.docs.length == 0) {
        throw Exception("Ошибка: Пользователь не найден.");
      } else {
        value.docs.forEach((element) {
          collection.doc(element.id).update(user.toJson());
        });
      }
    });
  }

  Future<User> getUser(String login, String password) async {
    List<User> users = [];
    Future<QuerySnapshot> collection = AuthorisationRepository().getStream();
    return collection.asStream().first.then((value) {
      value.docs.forEach((element) {
        users.add(User.fromJson(element.data()));
      });
      print(users);
      for (int i = 0; i < users.length; i++) {
        if (users[i].login == login) {
          print("login: true");
          if (users[i].password == password) {
            print("pass: true");
            return users[i];
          }
        }
      }
      throw Exception("Ошибка.");
    });
  }

  Future<bool> checkUser(String login, String password) async {
    List<User> users = [];
    Future<QuerySnapshot> collection = AuthorisationRepository().getStream();
    return collection.asStream().first.then((value) {
      value.docs.forEach((element) {
        users.add(User.fromJson(element.data()));
      });
      print(users);
      for (int i = 0; i < users.length; i++) {
        if (users[i].login == login) {
          print("login: true");
          if (users[i].password == password) {
            print("pass: true");
            return true;
          }
        }
      }
      return false;
    });
  }



  Future<bool> checkLogin(String login) async {
    List<String> logins = [];
    Future<QuerySnapshot> collection = AuthorisationRepository().getStream();
    return collection.asStream().first.then((value) {
        value.docs.forEach((element) {
          logins.add(User.fromJson(element.data()).login);
        });
        for (int i = 0; i < logins.length; i++) {
          if (logins[i] == login) {
            print("login: true");
            return true;
          }
        }
        return false;
    });
  }
}
