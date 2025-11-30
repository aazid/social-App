abstract class AuthState {}

class AuthInitial extends AuthState {
  AuthInitial();
}

class AuthLoading extends AuthState {
  AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final String userId;
  AuthAuthenticated(String s, {required this.userId});
}

class AuthUnAuthenticated extends AuthState {
  AuthUnAuthenticated();
}

class AuthError extends AuthState {
  final String message;
  AuthError({required this.message});
}

class AuthSuccess extends AuthState {
  final String message;
  AuthSuccess(String s, {required this.message});
}
