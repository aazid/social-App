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
  final String firstName;
  final String lastName;
  final String dob;
  final String gender;
  final String? profilePicturePath;
  SignUp({
    required this.confirmPassword,
    required this.email,
    required this.dob,
    required this.firstName,
    required this.gender,
    required this.lastName,
    required this.password,
    this.profilePicturePath,
  });
}

class ForgotPassword extends AuthEvent {
  final String email;
  ForgotPassword({required this.email});
}

class ResetPassword extends AuthEvent {
  final String email;
  final String newPassword;
  final String confirmPassword;
  ResetPassword({
    required this.email,
    required this.newPassword,
    required this.confirmPassword,
  });
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
