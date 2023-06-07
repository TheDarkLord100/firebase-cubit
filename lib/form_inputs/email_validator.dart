import 'package:formz/formz.dart';

class Email extends FormzInput<String, bool> {
  const Email.pure() : super.pure('');
  const Email.dirty([String value = '']) : super.dirty(value);

  static final RegExp _emailRegEx = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  @override
  bool? validator(String value) {
    var hasMatch = _emailRegEx.hasMatch(value);
    return hasMatch ? null : hasMatch;
  }
}
