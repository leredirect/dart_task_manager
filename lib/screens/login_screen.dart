import 'package:dart_task_manager/bloc/connectivity_bloc/connectivity_bloc.dart';
import 'package:dart_task_manager/bloc/user_bloc/user_bloc.dart';
import 'package:dart_task_manager/bloc/user_bloc/user_event.dart';
import 'package:dart_task_manager/bloc/validation_bloc/login_bloc.dart';
import 'package:dart_task_manager/constants.dart';
import 'package:dart_task_manager/models/user.dart';
import 'package:dart_task_manager/repository/auth_repo.dart';
import 'package:dart_task_manager/screens/home_screen.dart';
import 'package:dart_task_manager/utils/utils.dart';
import 'package:dart_task_manager/widgets/text_button.dart';
import 'package:dart_task_manager/widgets/text_forms/logon_text_input_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hive/hive.dart';
import 'package:uiblock/uiblock.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  User currentUser;

  Future<void> login(String login, String pass) async {
    bool isOnline = context
        .read<ConnectivityBloc>()
        .state;
    AuthorisationRepository repository = new AuthorisationRepository();
    if (!isOnline) {
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
        Navigator.pushNamedAndRemoveUntil(
            context, "homeScreen", (route) => false);
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
                      backgroundColor: backgroundColor,
                      body: AnimationConfiguration.synchronized(
                        duration: const Duration(milliseconds: 1000),
                        child: FadeInAnimation(
                          child: Center(
                            child: Container(
                              margin: EdgeInsets.only(
                                  top: MediaQuery
                                      .of(context)
                                      .size
                                      .height /
                                      15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: Text("DTM",
                                          style: bigText,
                                    ),
                                  ),
                                  Spacer(
                                  ),
                                  Container(
                                    // margin: EdgeInsets.only(
                                    //     top: 100, bottom: 100),
                                    child: Text(
                                      "вход в существующий аккаунт",
                                      style: headerText,
                                    ),
                                  ),
                                  Spacer(
                                  ),
                                  LogonTextInputWidget(
                                    isObscured: false,
                                    textFieldBloc: loginBloc.login,
                                    focusNode: loginNode,
                                    helperText: 'логин',
                                    onEditingComplete: () {
                                      FocusScope.of(context)
                                          .requestFocus(passNode);
                                    },
                                  ),
                                  LogonTextInputWidget(
                                    suffixButton: SuffixButton.obscureText,
                                    isObscured: true,
                                    textFieldBloc: loginBloc.password,
                                    focusNode: passNode,
                                    helperText: 'пароль',
                                    onEditingComplete: () {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    },
                                  ),
                                 Spacer(),
                                  TextButtonWidget(
                                    onPressed: loginBloc.submit,
                                    borderColor: Colors.white,
                                    text: "войти", textColor: Colors.white,),
                                  TextButtonWidget(onPressed: () {
                                    Navigator.pushNamed(context, "registrationScreen");},
                                    borderColor: backgroundColor,
                                    text: "регистрация", textColor: Colors.grey,),
                                  Spacer(),
                                ],
                              ),
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
            return Container(
              color: backgroundColor,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
            );
          }
        });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }
}
