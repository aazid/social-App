class AuthRepository {
  Future<String?> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password are required');
    }

    if (email == 'test@example.com' && password == 'password') {
      return 'aazid';
    }
    throw Exception('Invalid credentials');
  }

  Future<String?> signUp(
    String email,
    String password,
    String confirmPassword, String fullName,
  ) async {
    await Future.delayed(const Duration(seconds: 1));

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      throw Exception('All fields are required');
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      throw Exception('Please enter a valid email');
    }

    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }

    if (password != confirmPassword) {
      throw Exception('Passwords do not match');
    }

    return 'new_user_${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<void> forgotPassword(String email) async {
    await Future.delayed(const Duration(seconds: 1));

    if (email.isEmpty) {
      throw Exception('Email is required');
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      throw Exception('Please enter a valid email');
    }
  }

  Future<void> changePassword(
    String oldPassword,
    String newPassword,
    String confirmPassword,
  ) async {
    await Future.delayed(const Duration(seconds: 1));

    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      throw Exception('All fields are required');
    }

    if (newPassword.length < 6) {
      throw Exception('New password must be at least 6 characters');
    }

    if (newPassword != confirmPassword) {
      throw Exception('New passwords do not match');
    }

    if (oldPassword == newPassword) {
      throw Exception('New password must be different from old password');
    }
  }

  Future<void> updateProfile(String fullName, String bio) async {
    await Future.delayed(const Duration(seconds: 1));

    if (fullName.trim().isEmpty) {
      throw Exception('Name is required');
    }

    if (fullName.trim().length < 2) {
      throw Exception('Name must be at least 2 characters');
    }
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
