import 'package:dart_task_manager/repository/auth_repo.dart';
import 'package:dart_task_manager/utils/validation_utils.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class LoginFormBloc extends FormBloc<String, String> {
  final login = TextFieldBloc(
    validators: [
      ValidationUtils.required,
    ],
  );

  final password = TextFieldBloc(
    validators: [
      ValidationUtils.required,
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
      emitSuccess(canSubmitAgain: true);
    } else {
      emitFailure(failureResponse: "Проверьте правильность введенных данных.");
    }
  }
}
