import 'package:firebase_signup/utilities/extensions.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

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
        child: const Text(
          'Splash Screen',
          style: TextStyle(
            fontSize: 24,
            color: Colors.white
          ),
        ).wrapCenter(),
      ),
    );
  }
}
