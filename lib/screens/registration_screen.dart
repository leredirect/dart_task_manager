import 'package:dart_task_manager/constants.dart';
import 'package:dart_task_manager/models/user.dart';
import 'package:dart_task_manager/repository/auth_repo.dart';
import 'package:dart_task_manager/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RegistrationScreen();
}

class _RegistrationScreen extends State<RegistrationScreen> {
  final _loginController = TextEditingController();
  final _passController = TextEditingController();
  User currentUser;

  Future<void> register(String login, String pass) async {
    var idBox = await Hive.openBox<int>('id_box');
    int id = idBox.get('id');
    if (id == null) {
      idBox.put('id', 0);
      id = 0;
      idBox.close();
    } else {
      int id = idBox.get('id');
      idBox.put('id', id + 1);
      idBox.close();
    }

    currentUser = new User(id, login, pass);

    var listBox = await Hive.openBox<User>('userBox');
    listBox.clear();
    listBox.put('user', currentUser);
    listBox.close();

    AuthorisationRepository repository = new AuthorisationRepository();
    repository.addUser(currentUser);
    snackBarNotification(context, "Успешно зарегестрирован.");
    Navigator.pushReplacementNamed(context, "homeScreen");
  }

  FocusNode loginNode = FocusNode();
  FocusNode passNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          systemOverlayStyle: Utils.statusBarColor(),
          backwardsCompatibility: false,
          backgroundColor: backgroundColor,
          title: Text(
            "DTM",
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: backgroundColor,
        body: Center(
          child: Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 150),
                  child: Text(
                    "регистрация",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white, fontSize: 15, letterSpacing: 3),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: TextField(
                    focusNode: loginNode,
                    controller: _loginController,
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                    onSubmitted: (value) {
                      FocusScope.of(context).requestFocus(passNode);
                    },
                    decoration: InputDecoration(
                      helperText: "логин",
                      helperStyle:
                          TextStyle(color: Colors.white, letterSpacing: 3),
                      contentPadding: EdgeInsets.only(left: 5),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                        borderSide: BorderSide(color: clearColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                        borderSide: BorderSide(color: clearColor),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: TextField(
                    focusNode: passNode,
                    controller: _passController,
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      helperText: "пароль",
                      helperStyle:
                          TextStyle(color: Colors.white, letterSpacing: 3),
                      contentPadding: EdgeInsets.only(left: 5),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                        borderSide: BorderSide(color: clearColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                        borderSide: BorderSide(color: clearColor),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
                TextButton(
                    onPressed: () {
                      register(_loginController.text, _passController.text);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white)),
                      child: Padding(
                          padding: EdgeInsets.only(
                              top: 10, bottom: 10, left: 50, right: 50),
                          child: Text(
                            "создать",
                            style: TextStyle(
                                color: Colors.white, letterSpacing: 3),
                          )),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _loginController.dispose();
    _passController.dispose();
  }

  @override
  void initState() {
    super.initState();
  }
}
