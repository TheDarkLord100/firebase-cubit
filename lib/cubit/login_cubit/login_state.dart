part of 'login_cubit.dart';

class LoginState extends Equatable {
  final Email email;
  final Password password;
  final String msg;
  final FormzSubmissionStatus status;

  const LoginState(
      {this.email = const Email.pure(),
      this.password = const Password.pure(),
      this.msg = '',
      this.status = FormzSubmissionStatus.initial});

  @override
  List<Object?> get props => [email, password, msg, status];

  LoginState copyWith(
      {Email? email,
      Password? password,
      String? msg,
      FormzSubmissionStatus? status}) {
    return LoginState(
        email: email ?? this.email,
        password: password ?? this.password,
        msg: msg ?? this.msg,
        status: status ?? this.status);
  }
}
