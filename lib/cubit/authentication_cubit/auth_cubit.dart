import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required this.authRepo})
      : super(AuthState(status: AuthStatus.initial, user: UserProfile.empty)) {
    _appStart();
  }

  final AuthenticationRepository authRepo;

  void _appStart() async {
    await Future.delayed(const Duration(seconds: 3));
    authRepo.isSignedIn().then((isSignedIn) async {
      if (isSignedIn) {
        final user = await authRepo.user.first;
        emit(state.copyWith(
            status: AuthStatus.authenticated, user: user));
      } else {
        emit(state.copyWith(
            status: AuthStatus.unauthenticated, user: UserProfile.empty));
      }
    });
  }

  Future<void> login({required String email, required String password}) async {
    final user = await authRepo.logInWithEmailAndPassword(email: email, password: password);
    emit(state.copyWith(status: AuthStatus.authenticated, user: user));
  }

  Future<void> signup({required String email, required String password}) async {
    final user = await authRepo.signUp(email: email, password: password);
    emit(state.copyWith(status: AuthStatus.authenticated, user: user));
  }

  void logOut() {
    authRepo.logOut();
    emit(state.copyWith(status: AuthStatus.unauthenticated));
  }

}
