import 'package:bloc/bloc.dart';
import 'package:firebase_signup/utilities/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {Key? key, this.onTap, required this.title, this.isLoading = false})
      : super(key: key);

  final VoidCallback? onTap;
  final String title;
  final bool isLoading;

  bool get isEnabled => !isLoading && onTap != null;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          side: BorderSide(
            color: isEnabled ? Colors.white : Colors.grey,
            width: 1.5,
          )),
      child: isLoading
          ? const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            )
          : Text(
              title,
              style: TextStyle(
                  color: isEnabled ? Colors.white : Colors.grey, fontSize: 18),
            ).paddingWithSymmetry(horizontal: 2, vertical: 2),
    );
  }
}

class CustomCubitButton<C extends StateStreamable<S>, S>
    extends StatelessWidget {
  const CustomCubitButton(
      {Key? key,
      this.buildWhen,
      required this.title,
      this.onTap,
      this.isEnabled,
      this.isLoading})
      : super(key: key);

  final bool Function(S, S)? buildWhen;
  final String title;
  final void Function(S, C)? onTap;
  final bool Function(S)? isEnabled;
  final bool Function(S)? isLoading;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<C, S>(
        buildWhen: buildWhen,
        builder: (context, state) {
          var loading = isLoading?.call(state) ?? false;
          var enabled = (isEnabled?.call(state) ?? onTap != null) && !loading;
          return CustomButton(
            isLoading: loading,
            title: title,
            onTap: enabled
                ? () {
                    onTap?.call(state, context.read<C>());
                  }
                : null,
          );
        });
  }
}
