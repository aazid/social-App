abstract class AuthEvent {}

class LoginSubmitted extends AuthEvent {
  final String email;
  final String password;
  LoginSubmitted({required this.email, required this.password});
}

class SignUp extends AuthEvent {
  final String email;
  final String password;
  final String confirmPassword;
  final String fullName;
  SignUp({
    required this.confirmPassword,
    required this.email,
    required this.fullName,
    required this.password,
  });
}

class ForgotPassword extends AuthEvent {
  final String email;
  ForgotPassword({required this.email});
}

class ChangePassword extends AuthEvent {
  final String oldPassword;
  final String newPassword;
  final String confirmPassword;
  ChangePassword({
    required this.confirmPassword,
    required this.newPassword,
    required this.oldPassword,
  });
}

class UpdateProfile extends AuthEvent {
  final String fullName;
  final String bio;
  UpdateProfile({required this.bio, required this.fullName});
}
