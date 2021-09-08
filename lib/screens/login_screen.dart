import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dart_task_manager/constants.dart';
import 'package:dart_task_manager/models/user.dart';
import 'package:dart_task_manager/repository/auth_repo.dart';
import 'package:dart_task_manager/screens/home_screen.dart';
import 'package:dart_task_manager/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginController = TextEditingController();
  final _passController = TextEditingController();
  User currentUser;

  Future<void> login(String login, String pass) async {
    var internet = await (Connectivity().checkConnectivity());
    AuthorisationRepository repository = new AuthorisationRepository();
    if (internet == ConnectivityResult.none) {
      snackBarNotification(context, "Отсутствует подключение к интернету.");
    } else {
      List<int> ids = await repository.getIdList();
      int id = ids.last + 1;
      User currentUser = new User(id, login, pass);
      try {
        bool result = await repository.checkUser(currentUser);
        print(result);
        if (result == true) {
          var listBox = await Hive.openBox<User>('userBox');
          listBox.put('user', currentUser);
          listBox.close();
          snackBarNotification(context, "Успешно авторизован.");
          Navigator.pushReplacementNamed(context, "homeScreen");
        } else {
          snackBarNotification(context, "Пользователь не найден");
        }
      } on Exception catch (e) {
        snackBarNotification(context, e.toString());
      }
    }
  }

  Future<bool> compareUserFromBoxWithUserFromFirebase() async {
    print("smth");
    AuthorisationRepository repository = new AuthorisationRepository();
    var userBox = await Hive.openBox<User>('userBox');
    if (userBox.isNotEmpty) {
      User userFromBox = userBox.get("user");
      bool compareWithBase = await repository.checkUser(userFromBox);
      if (compareWithBase) {
        currentUser = userFromBox;
        print("true");
        return true;
      }
    }
    return false;
  }

  FocusNode loginNode = FocusNode();
  FocusNode passNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: compareUserFromBoxWithUserFromFirebase(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data) {
              return HomeScreen();
            } else {
              return GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: Scaffold(
                  appBar: AppBar(
                    systemOverlayStyle: Utils.statusBarColor(),
                    backwardsCompatibility: false,
                    actions: [
                      IconButton(
                        icon: Icon(
                          Icons.person_add,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, "registrationScreen");
                        },
                      )
                    ],
                    backgroundColor: backgroundColor,
                    title: Text(
                      "DTM",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  backgroundColor: backgroundColor,
                  body: Center(
                    child: Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 150),
                            child: Text(
                              "вход в существующий аккаунт",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  letterSpacing: 3),
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
                                helperStyle: TextStyle(
                                    color: Colors.white, letterSpacing: 3),
                                contentPadding: EdgeInsets.only(left: 5),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(0)),
                                  borderSide: BorderSide(color: clearColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(0)),
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
                                helperStyle: TextStyle(
                                    color: Colors.white, letterSpacing: 3),
                                contentPadding: EdgeInsets.only(left: 5),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(0)),
                                  borderSide: BorderSide(color: clearColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(0)),
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
                                login(_loginController.text,
                                    _passController.text);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white)),
                                child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                        left: 50,
                                        right: 50),
                                    child: Text(
                                      "вход",
                                      style: TextStyle(
                                          color: Colors.white,
                                          letterSpacing: 3),
                                    )),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          } else {
            return Container();
          }
        });
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
