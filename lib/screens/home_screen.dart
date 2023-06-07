import 'package:firebase_signup/cubit/authentication_cubit/auth_cubit.dart';
import 'package:firebase_signup/custom_widgets/custom_button.dart';
import 'package:firebase_signup/utilities/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Color(0xFF0B5CF8),
                  Color(0xFF000000)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter
            )
        ),
        child: CustomButton(title: 'log out',
          onTap: () {
          var auth = context.read<AuthCubit>();
          auth.logOut();
          },
        ).wrapCenter(),
      ),
    );
  }
}
