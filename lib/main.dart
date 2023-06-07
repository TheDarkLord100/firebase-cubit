import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_signup/cubit/authentication_cubit/auth_cubit.dart';
import 'package:firebase_signup/screens/home_screen.dart';
import 'package:firebase_signup/screens/login_screen.dart';
import 'package:firebase_signup/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final authenticationRepository = AuthenticationRepository();
  await authenticationRepository.user.first;

  runApp(MyApp(
    authRepo: authenticationRepository,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.authRepo}) : super(key: key);

  final AuthenticationRepository authRepo;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authRepo,
      child: BlocProvider(
        create: (_) => AuthCubit(authRepo: authRepo),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state.status == AuthStatus.authenticated) {
                return const HomeScreen();
              } else if (state.status == AuthStatus.unauthenticated) {
                return const LoginScreen();
              } else {
                return const SplashScreen();
              }
            },
          ),
          theme: ThemeData(
            inputDecorationTheme: InputDecorationTheme(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: const BorderSide(
                  color: Colors.white,
                  width: 1.5
                )
              ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(
                        color: Colors.white,
                        width: 1.5
                    )
                ),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(
                        color: Colors.red,
                        width: 1.5
                    )
                ),
                focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(
                        color: Colors.red,
                        width: 1.5
                    )
                )
            )
          ),
        ),
      ),
    );
  }
}
