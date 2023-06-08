import 'dart:developer';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_signup/cubit/authentication_cubit/auth_cubit.dart';
import 'package:firebase_signup/form_inputs/email_validator.dart';
import 'package:firebase_signup/form_inputs/password_validator.dart';
import 'package:formz/formz.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this.auth) : super(const LoginState());
  final AuthCubit auth;
  void clearErrorMsg() {
    emit(state.copyWith(msg: ''));
  }

  void onEmailChanged(String value) {
    var email = value.isEmpty ? const Email.pure() : Email.dirty(value);
    emit(state.copyWith(email: email));
  }

  void onPasswordChanged(String value) {
    var password =
        value.isEmpty ? const Password.pure() : Password.dirty(value);
    emit(state.copyWith(password: password));
  }

  void onButtonPressed() async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    await Future.delayed(const Duration(seconds: 3));

    try {
      final res = await auth.login(
          email: state.email.value, password: state.password.value);
      if(res.status == RequestStatus.SUCCESS) {
        emit(state.copyWith(status: FormzSubmissionStatus.success));
      } else {
       emit(state.copyWith(status: FormzSubmissionStatus.failure, msg: res.message));
      }
    } on Exception catch (e) {
      log(e.toString());
    }
  }
}
