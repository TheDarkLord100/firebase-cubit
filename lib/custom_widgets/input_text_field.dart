import 'package:firebase_signup/utilities/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InputTextField<B extends StateStreamable<S>, S> extends StatelessWidget {
  const InputTextField(
      {Key? key,
      required this.buildWhen,
      required this.onValueChanged,
      this.getErrorMsg, this.obscureText = false})
      : super(key: key);

  final bool Function(S, S) buildWhen;
  final Function(String value, B cubit) onValueChanged;
  final String? Function(S)? getErrorMsg;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B, S>(
      buildWhen: buildWhen,
      builder: (context, state) {
        var errorMsgText = getErrorMsg?.call(state);
        return TextField(
          obscureText: obscureText,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            errorText: errorMsgText
          ),
          onChanged: (value) => onValueChanged(value, context.read<B>()),
        ).paddingWithSymmetry(horizontal: 16, vertical: 8);
      },
    );
  }
}
