import 'package:formz/formz.dart';

class Password extends FormzInput<String, bool> {
  const Password.pure() : super.pure('');
  const Password.dirty([String value = '']) : super.dirty(value);

  @override
  bool? validator(String value) {
    bool isValid = (value.length >= 6) ? true : false;
    return isValid ? null : isValid;
  }
}
