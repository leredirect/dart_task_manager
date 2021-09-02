import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 3)
class User {
  @HiveField(0)
  int id;
  @HiveField(1)
  String login;
  @HiveField(2)
  String password;

  User(
    this.id,
    this.login,
    this.password,
  );

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "id": this.id,
      "login": this.login,
      "password": this.password,
    };
  }

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    login = json['login'];
    password = json['password'];
  }

  @override
  String toString() {
    return "id: ${this.id}\nlogin: ${this.login}\npass: ${this.password}\n";
  }
}
