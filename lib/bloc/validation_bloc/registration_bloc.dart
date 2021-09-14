import 'package:dart_task_manager/repository/auth_repo.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class RegistrationFormBloc extends FormBloc<String, String> {
  final login = TextFieldBloc(validators: [
    required,
    loginValidator,
  ], asyncValidators: [
    baseValidator,
  ]);

  final password = TextFieldBloc(
    validators: [
      required,
      passwordValidator,
    ],
  );

  RegistrationFormBloc() {
    addFieldBlocs(
      fieldBlocs: [
        login,
        password,
      ],
    );
  }

  @override
  void onSubmitting() async {
    print(login.value);
    AuthorisationRepository repository = new AuthorisationRepository();
    bool isLoginTaken = await repository.checkLogin(login.value);
    if (isLoginTaken) {
      emitFailure(failureResponse: "Проверьте правильность введенных данных.");
    } else {
      emitSuccess();
    }
  }

  static Future<String> baseValidator(String string) async {
    AuthorisationRepository repository = new AuthorisationRepository();
    bool isLoginTaken = await repository.checkLogin(string);
    if (isLoginTaken) {
      return "Имя пользователя занято";
    } else {
      return null;
    }
  }

  static String passwordValidator(String string) {
    if (string == null || string.isEmpty || string.length >= 5) {
      return null;
    }
    return "Пароль должен быть длинее 5-ти символов.";
  }

  static String loginValidator(String string) {
    if (string == null || string.isEmpty || string.length >= 5) {
      return null;
    }
    return "Логин должен быть длинее 5-ти символов.";
  }

  static String required(dynamic value) {
    if (value == null ||
        value == false ||
        ((value is Iterable || value is String || value is Map) &&
            value.length == 0)) {
      return "Поле не может быть пустым";
    }
    return null;
  }
}
