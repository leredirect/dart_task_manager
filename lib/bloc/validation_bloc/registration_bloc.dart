import 'package:dart_task_manager/repository/auth_repo.dart';
import 'package:dart_task_manager/utils/validation_utils.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class RegistrationFormBloc extends FormBloc<String, String> {
  final login = TextFieldBloc(validators: [
    ValidationUtils.required,
    loginValidation,
  ], asyncValidators: [
    loginTakenValidation,
  ]);

  final password = TextFieldBloc(
    validators: [
      ValidationUtils.required,
      passwordValidation,
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
    emitSuccess(canSubmitAgain: true);
  }

  static Future<String> loginTakenValidation(String string) async {
    AuthorisationRepository repository = new AuthorisationRepository();
    bool isLoginTaken = await repository.checkLogin(string);
    if (isLoginTaken) {
      return "Имя пользователя занято";
    } else {
      return null;
    }
  }

  static String passwordValidation(String string) {
    if (string == null || string.isEmpty || string.length >= 5) {
      return null;
    }
    return "Пароль должен быть длиннее 5-ти символов.";
  }

  static String loginValidation(String string) {
    if (string == null || string.isEmpty || string.length >= 5) {
      return null;
    }
    return "Логин должен быть длиннее 5-ти символов.";
  }
}
