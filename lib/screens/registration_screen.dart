import 'package:dart_task_manager/bloc/connectivity_bloc/connectivity_bloc.dart';
import 'package:dart_task_manager/bloc/user_bloc/user_bloc.dart';
import 'package:dart_task_manager/bloc/user_bloc/user_event.dart';
import 'package:dart_task_manager/bloc/validation_bloc/registration_bloc.dart';
import 'package:dart_task_manager/constants.dart';
import 'package:dart_task_manager/models/user.dart';
import 'package:dart_task_manager/repository/auth_repo.dart';
import 'package:dart_task_manager/repository/ids_repo.dart';
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

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RegistrationScreen();
}

class _RegistrationScreen extends State<RegistrationScreen> {
  User currentUser;

  FocusNode loginNode = FocusNode();
  FocusNode passNode = FocusNode();

  Future<void> register(String login, String pass) async {
    bool isOnline = context.read<ConnectivityBloc>().state;
    if (!isOnline) {
      snackBarNotification(context, "Отсутствует подключение к интернету.",
          duration: 2);
    } else {
      snackBarNotification(context, "Выполняется регистрация...", duration: 1);

      AuthorisationRepository repository = new AuthorisationRepository();

      int newId = await IdRepository().getLastCreatedUserId();

      currentUser = new User(newId, login, pass);
      context.read<UserBloc>().add(SetUserEvent(currentUser));

      var listBox = await Hive.openBox<User>('userBox');
      listBox.clear();
      listBox.put('user', currentUser);
      listBox.close();

      context.read<RegistrationFormBloc>().clear();

      repository.addUser(currentUser);
      snackBarNotification(context, "Успешно зарегестрирован.", duration: 1);
      Navigator.pushNamedAndRemoveUntil(
          context, "homeScreen", (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Builder(builder: (context) {
          var registrationBloc = BlocProvider.of<RegistrationFormBloc>(context);

          return FormBlocListener<RegistrationFormBloc, String, String>(
            onSubmitting: (context, state) {
              UIBlock.block(context);
            },
            onSuccess: (context, state) async {
              UIBlock.unblock(context);

              register(registrationBloc.login.value,
                  registrationBloc.password.value);
            },
            onFailure: (context, state) {
              UIBlock.unblock(context);

              snackBarNotification(context, state.failureResponse, duration: 1);
            },
            child: AnimationConfiguration.synchronized(
              duration: const Duration(milliseconds: 1000),
              child: FadeInAnimation(
                child: Center(
                  child: Container(
                    margin: EdgeInsets.only(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Spacer(),
                        Container(
                          child: Text("регистрация", style: headerText),
                        ),
                        Spacer(),
                        LogonTextInputWidget(
                          textFieldBloc: registrationBloc.login,
                          isObscured: false,
                          focusNode: loginNode,
                          helperText: 'логин',
                          onEditingComplete: () {
                            FocusScope.of(context).requestFocus(passNode);
                          },
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        LogonTextInputWidget(
                          textFieldBloc: registrationBloc.password,
                          suffixButton: SuffixButton.obscureText,
                          isObscured: true,
                          focusNode: passNode,
                          helperText: 'пароль',
                          onEditingComplete: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                        ),
                        Spacer(),
                        TextButtonWidget(
                          onPressed: registrationBloc.submit,
                          borderColor: Colors.white,
                          text: "регистрация",
                          textColor: Colors.white,
                        ),
                        TextButtonWidget(
                          onPressed: () {
                            Navigator.pushNamed(context, "/");
                          },
                          borderColor: backgroundColor,
                          text: "войти",
                          textColor: Colors.grey,
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
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
