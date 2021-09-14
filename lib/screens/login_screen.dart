import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dart_task_manager/bloc/user_bloc/user_bloc.dart';
import 'package:dart_task_manager/bloc/user_bloc/user_event.dart';
import 'package:dart_task_manager/bloc/validation_bloc/login_bloc.dart';
import 'package:dart_task_manager/constants.dart';
import 'package:dart_task_manager/models/user.dart';
import 'package:dart_task_manager/repository/auth_repo.dart';
import 'package:dart_task_manager/screens/home_screen.dart';
import 'package:dart_task_manager/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:hive/hive.dart';
import 'package:uiblock/uiblock.dart';

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
      try {
        User currentUser = await repository.getUser(login, pass);
        context.read<UserBloc>().add(SetUserEvent(currentUser));

        var userBox = await Hive.openBox<User>('userBox');
        userBox.put('user', currentUser);
        userBox.close();

        context.read<LoginFormBloc>().clear();

        snackBarNotification(context, "Успешно авторизован.");
        Navigator.pushReplacementNamed(context, "homeScreen");
      } on Exception catch (e) {
        snackBarNotification(context, e.toString());
      }
    }
  }

  Future<bool> compareUserFromBoxWithUserFromFirebase() async {
    AuthorisationRepository repository = new AuthorisationRepository();
    var userBox = await Hive.openBox<User>('userBox');
    if (userBox.isNotEmpty) {
      User userFromBox = userBox.get("user");
      bool compareWithBase = await repository.isUserExists(
          userFromBox.login, userFromBox.password);
      if (compareWithBase) {
        currentUser = userFromBox;
        context.read<UserBloc>().add(SetUserEvent(currentUser));

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
              return Builder(builder: (context) {
                var loginBloc = BlocProvider.of<LoginFormBloc>(context);

                return FormBlocListener<LoginFormBloc, String, String>(
                  onSubmitting: (context, state) {
                    UIBlock.block(context);
                  },
                  onSuccess: (context, state) async {
                    await Future.delayed(Duration(milliseconds: 1000));
                    UIBlock.unblock(context);
                    snackBarNotification(context, "Выполняется вход...",
                        duration: 1);
                    login(loginBloc.login.value, loginBloc.password.value);
                  },
                  onFailure: (context, state) {
                    UIBlock.unblock(context);

                    snackBarNotification(context, state.failureResponse,
                        duration: 1);
                  },
                  child: GestureDetector(
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
                                    "вход в существующий аккаунт",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        letterSpacing: 3),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 1.5,
                                  child: TextFieldBlocBuilder(
                                    onEditingComplete: () {
                                      FocusScope.of(context)
                                          .requestFocus(passNode);
                                    },
                                    focusNode: loginNode,
                                    style: TextStyle(color: Colors.white),
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      helperText: "логин",
                                      helperStyle: TextStyle(
                                          color: Colors.white,
                                          letterSpacing: 3),
                                      contentPadding: EdgeInsets.only(left: 5),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(0)),
                                        borderSide:
                                            BorderSide(color: clearColor),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(0)),
                                        borderSide:
                                            BorderSide(color: clearColor),
                                      ),
                                    ),
                                    textFieldBloc: loginBloc.login,
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 1.5,
                                  child: TextFieldBlocBuilder(
                                    focusNode: passNode,
                                    onEditingComplete: () {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    },
                                    style: TextStyle(color: Colors.white),
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      helperText: "логин",
                                      helperStyle: TextStyle(
                                          color: Colors.white,
                                          letterSpacing: 3),
                                      contentPadding: EdgeInsets.only(left: 5),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(0)),
                                        borderSide:
                                            BorderSide(color: clearColor),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(0)),
                                        borderSide:
                                            BorderSide(color: clearColor),
                                      ),
                                    ),
                                    textFieldBloc: loginBloc.password,
                                  ),
                                ),
                                SizedBox(
                                  height: 100,
                                ),
                                TextButton(
                                    onPressed: loginBloc.submit,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.white)),
                                      child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 10,
                                              bottom: 10,
                                              left: 50,
                                              right: 50),
                                          child: Text(
                                            "войти",
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
                    ),
                  ),
                );
              });
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
