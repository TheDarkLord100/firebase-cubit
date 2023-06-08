import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

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

  Future<RequestStatus<UserProfile?>> login({required String email, required String password}) async {
    final result = await authRepo.logInWithEmailAndPassword(
        email: email, password: password);
    if (result.status == RequestStatus.SUCCESS) {
      emit(state.copyWith(status: AuthStatus.authenticated, user: result.body));
    } return result;
  }

  Future<RequestStatus<UserProfile?>> signup({required String email, required String password}) async {
    final result = await authRepo.signUp(email: email, password: password);
    if (result.status == RequestStatus.SUCCESS) {
      emit(state.copyWith(status: AuthStatus.authenticated, user: result.body));
    } return result;
  }

  Future<RequestStatus<BaseResponse?>> logOut() async {
    final result = await authRepo.logOut();
    if (result.status == RequestStatus.SUCCESS) {
      emit(state.copyWith(status: AuthStatus.unauthenticated, user: UserProfile.empty));
    } return result;
  }

}
