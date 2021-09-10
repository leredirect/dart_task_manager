import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dart_task_manager/constants.dart';
import 'package:dart_task_manager/models/user.dart';
import 'package:dart_task_manager/repository/auth_repo.dart';
import 'package:dart_task_manager/repository/ids_repo.dart';
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
  Color passBorderColor = clearColor;
  Color logBorderColor = clearColor;
  FocusNode loginNode = FocusNode();
  FocusNode passNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  Future<void> register(String login, String pass) async {
    var internet = await (Connectivity().checkConnectivity());
    if (internet == ConnectivityResult.none) {
      snackBarNotification(context, "Отсутствует подключение к интернету.",
          duration: 2);
    } else {
      AuthorisationRepository repository = new AuthorisationRepository();

      int newId = await IdRepository().getLastCreatedId();

      currentUser = new User(newId, login, pass);

      var listBox = await Hive.openBox<User>('userBox');
      listBox.clear();
      listBox.put('user', currentUser);
      listBox.close();

      repository.addUser(currentUser);
      snackBarNotification(context, "Успешно зарегестрирован.", duration: 1);
      Navigator.pushReplacementNamed(context, "homeScreen");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pushReplacementNamed(context, '/'),
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
          body: SingleChildScrollView(
            child: Center(
              child: Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 150),
                      child: Text(
                        "регистрация",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            letterSpacing: 3),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: TextFormField(
                        focusNode: loginNode,
                        controller: _loginController,
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length < 3) {
                            return 'Логин должен быть длиннее 3-х символов.';
                          } else {
                            return null;
                          }
                        },
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).requestFocus(passNode);
                        },
                        decoration: InputDecoration(
                          helperText: "логин",
                          helperStyle:
                              TextStyle(color: Colors.white, letterSpacing: 3),
                          contentPadding: EdgeInsets.only(left: 5),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(0)),
                            borderSide: BorderSide(color: logBorderColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(0)),
                            borderSide: BorderSide(color: logBorderColor),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: TextFormField(
                        focusNode: passNode,
                        controller: _passController,
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                        obscureText: true,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length < 5) {
                            return 'Пароль должен быть длиннее 5-ти символов.';
                          } else {
                            return null;
                          }
                        },
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).requestFocus(passNode);
                        },
                        decoration: InputDecoration(
                          helperText: "пароль",
                          helperStyle:
                              TextStyle(color: Colors.white, letterSpacing: 3),
                          contentPadding: EdgeInsets.only(left: 5),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(0)),
                            borderSide: BorderSide(color: passBorderColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(0)),
                            borderSide: BorderSide(color: passBorderColor),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    TextButton(
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            AuthorisationRepository repository =
                                new AuthorisationRepository();
                            bool isLoginTaken = await repository
                                .checkLogin(_loginController.text);
                            if (isLoginTaken) {
                              setState(() {
                                logBorderColor = Colors.red;
                              });
                              snackBarNotification(
                                  context, "Имя пользователя занято.",
                                  duration: 1);
                            } else {
                              snackBarNotification(
                                  context, "Выполняется регистрация...",
                                  duration: 1);
                              register(
                                  _loginController.text, _passController.text);
                            }
                          }
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
