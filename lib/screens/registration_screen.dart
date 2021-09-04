import 'package:connectivity_plus/connectivity_plus.dart';
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
  Color passBorderColor = clearColor;
  Color logBorderColor = clearColor;
  FocusNode loginNode = FocusNode();
  FocusNode passNode = FocusNode();


  bool checkRegisterData(_loginController, _passController){
      if(_loginController.text.length < 3 && _passController.text.length < 5){
        logBorderColor = Colors.red;
        passBorderColor = Colors.red;
        snackBarNotification(context, "Логин и пароль должны быть длиннее 3-х и 5-ти символов соответсвенно.", duration: 2);
        return false;
      }
      else if (_loginController.text.length < 3){
        logBorderColor = Colors.red;
        passBorderColor = clearColor;
        snackBarNotification(context, "Логин должен быть длиннее 3-х символов.", duration: 2);
        return false;
      }else if(_passController.text.length < 3){
        passBorderColor = Colors.red;
        logBorderColor = clearColor;
        snackBarNotification(context, "Пароль должен быть длиннее 5-ти символов.", duration: 2);
        return false;
      }else{
        passBorderColor = Colors.green;
        logBorderColor = Colors.green;
        return true;
      }
  }

  Future<void> register(String login, String pass) async {
    var internet = await (Connectivity().checkConnectivity());
    if (internet == ConnectivityResult.none) {
      snackBarNotification(context, "Отсутствует подключение к интернету.");
    } else {
      AuthorisationRepository repository = new AuthorisationRepository();

      List<int> ids = await repository.getIdList();
      ids.sort();
      print (ids);

      currentUser = new User(ids.last+1, login, pass);

      var listBox = await Hive.openBox<User>('userBox');
      listBox.clear();
      listBox.put('user', currentUser);
      listBox.close();

      bool isLoginBusy = await repository.checkLogin(currentUser);
      if (isLoginBusy) {
        snackBarNotification(context, "Имя пользователя занято.", duration: 2);
      } else {
        repository.addUser(currentUser);
        snackBarNotification(context, "Успешно зарегестрирован.", duration: 1);
        Navigator.pushReplacementNamed(context, "homeScreen");
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                        checkRegisterData(_loginController, _passController);
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
                  child: TextField(
                    focusNode: passNode,
                    controller: _passController,
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                    onSubmitted: (value){
                      FocusScope.of(context).dispose();
                      checkRegisterData(_loginController, _passController);
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
                    onPressed: () {
                      bool isRegisterDataCorrect = checkRegisterData(_loginController, _passController);
                      if (isRegisterDataCorrect) {
                        setState(() {});
                        snackBarNotification(context, "Выполняется регистрация...", duration: 1);
                        register(_loginController.text, _passController.text);
                      }else{
                        setState(() {

                        });
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
