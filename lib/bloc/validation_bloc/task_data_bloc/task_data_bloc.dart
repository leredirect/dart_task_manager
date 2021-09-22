import 'package:dart_task_manager/utils/validation_utils.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class TaskDataBloc extends FormBloc<String, String> {
  final name = TextFieldBloc(
    validators: [
      ValidationUtils.required,
    ],
  );

  final text = TextFieldBloc(
    validators: [
      ValidationUtils.required,
    ],
  );

  final deadline =
      InputFieldBloc<DateTime, Object>(validators: [ValidationUtils.required]);

  TaskDataBloc() {
    addFieldBlocs(
      fieldBlocs: [
        name,
        text,
        deadline,
      ],
    );
  }

  @override
  void onSubmitting() async {
    emitSuccess(canSubmitAgain: true);
  }
}
