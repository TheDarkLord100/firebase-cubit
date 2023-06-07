part of 'auth_cubit.dart';

enum AuthStatus { initial, authenticated, unauthenticated }

class AuthState extends Equatable {
  final AuthStatus status;
  final UserProfile user;

  const AuthState({required this.status, required this.user});

  @override
  List<Object?> get props => [status, user];

  AuthState copyWith({AuthStatus? status, UserProfile? user}) {
    return AuthState(user: user ?? this.user, status: status ?? this.status);
  }
}
