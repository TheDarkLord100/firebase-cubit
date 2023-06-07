import 'package:authentication_repository/authentication_repository.dart';
import 'package:firebase_signup/cubit/authentication_cubit/auth_cubit.dart';
import 'package:firebase_signup/cubit/login_cubit/login_cubit.dart';
import 'package:firebase_signup/custom_widgets/custom_button.dart';
import 'package:firebase_signup/custom_widgets/input_text_field.dart';
import 'package:firebase_signup/screens/signup_screen.dart';
import 'package:firebase_signup/utilities/common_utilities.dart';
import 'package:firebase_signup/utilities/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocProvider(
        create: (context) => LoginCubit(context.read<AuthCubit>()),
        child: BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            var cubit = context.read<LoginCubit>();
            if(state.status == FormzSubmissionStatus.success) {
              Navigator.popUntil(context, (route) => route.isFirst);
            }
            if (state.msg != '') {
              CommonUtils.showSnackBar(context, state.msg);
              cubit.clearErrorMsg();
            }
          },
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Color(0xFF0B5CF8), Color(0xFF000000)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter)),
              ),
              Positioned(
                  top: -50,
                  left: -30,
                  child: Container(
                    height: 250,
                    width: 250,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                            colors: [Color(0xFFFFFFFF), Colors.transparent],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter)),
                  )),
              Positioned(
                  top: 25,
                  right: 10,
                  child: Container(
                    height: 130,
                    width: 130,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                            colors: [Color(0xFF0056FF), Color(0xFF183671)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter)),
                  )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'LOGIN',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ).paddingForOnly(top: 180).wrapCenter(),
                  const Text(
                    'Email',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  )
                      .paddingWithSymmetry(horizontal: 20, vertical: 4)
                      .paddingForOnly(top: 20),
                  InputTextField<LoginCubit, LoginState>(
                    buildWhen: (p, c) => p.email != c.email,
                    onValueChanged: (value, cubit) =>
                        cubit.onEmailChanged(value),
                    getErrorMsg: (state) =>
                        state.email.isPure || state.email.isValid
                            ? null
                            : 'Invalid Email',
                  ).paddingForOnly(bottom: 20),
                  const Text(
                    'Password',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ).paddingWithSymmetry(horizontal: 20, vertical: 4),
                  InputTextField<LoginCubit, LoginState>(
                    obscureText: true,
                    buildWhen: (p, c) => p.password != c.password,
                    onValueChanged: (value, cubit) =>
                        cubit.onPasswordChanged(value),
                    getErrorMsg: (state) =>
                        state.password.isPure || state.password.isValid
                            ? null
                            : 'Invalid Password',
                  ).paddingForOnly(bottom: 0),
                  const Text(
                    'Forgot Password?',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ).paddingWithSymmetry(horizontal: 20, vertical: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomButton(
                        title: 'SIGN UP',
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignupScreen()));
                        },
                      ),
                      CustomCubitButton<LoginCubit, LoginState>(
                              onTap: (state, cubit) => cubit.onButtonPressed(),
                              isEnabled: (state) =>
                                  state.email.isValid && state.password.isValid,
                              isLoading: (state) => state.status == FormzSubmissionStatus.inProgress,
                              title: 'LOGIN')
                          .wrapCenter(),
                    ],
                  ).paddingWithSymmetry(horizontal: 20, vertical: 20)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
