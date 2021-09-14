import 'package:dart_task_manager/repository/auth_repo.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class LoginFormBloc extends FormBloc<String, String> {
  final login = TextFieldBloc(
    validators: [
      required,
    ],
  );

  final password = TextFieldBloc(
    validators: [
      required,
    ],
  );

  LoginFormBloc() {
    addFieldBlocs(
      fieldBlocs: [
        login,
        password,
      ],
    );
  }

  @override
  void onSubmitting() async {
    AuthorisationRepository repository = new AuthorisationRepository();
    bool isUserExist =
        await repository.isUserExists(login.value, password.value);
    if (isUserExist) {
      emitSuccess();
    } else {
      emitFailure(failureResponse: "Проверьте правильность введенных данных.");
    }
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
