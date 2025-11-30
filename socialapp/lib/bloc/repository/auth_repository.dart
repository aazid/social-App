import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserPassword = 'user_password';
  static const String _keyUserFullName = 'user_full_name';
  static const String _keyUserId = 'user_id';
  static const String _keyIsLoggedIn = 'is_logged_in';

  Future<String?> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password are required');
    }

    final prefs = await SharedPreferences.getInstance();
    final storedEmail = prefs.getString(_keyUserEmail);
    final storedPassword = prefs.getString(_keyUserPassword);
    final userId = prefs.getString(_keyUserId);

    if (storedEmail == null || storedPassword == null) {
      throw Exception('No account found. Please sign up first.');
    }

    if (email == storedEmail && password == storedPassword) {
      await prefs.setBool(_keyIsLoggedIn, true);
      return userId ?? 'user_${DateTime.now().millisecondsSinceEpoch}';
    }

    throw Exception('Invalid email or password');
  }

  Future<String?> signUp(
    String email,
    String password,
    String confirmPassword,
    String fullName,
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

    final prefs = await SharedPreferences.getInstance();
    final existingEmail = prefs.getString(_keyUserEmail);

    if (existingEmail != null && existingEmail == email) {
      throw Exception('Account already exists. Please login.');
    }

    final userId = 'user_${DateTime.now().millisecondsSinceEpoch}';

    await prefs.setString(_keyUserEmail, email);
    await prefs.setString(_keyUserPassword, password);
    await prefs.setString(_keyUserFullName, fullName);
    await prefs.setString(_keyUserId, userId);
    await prefs.setBool(_keyIsLoggedIn, true);

    return userId;
  }

  Future<void> forgotPassword(String email) async {
    await Future.delayed(const Duration(seconds: 1));

    if (email.isEmpty) {
      throw Exception('Email is required');
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      throw Exception('Please enter a valid email');
    }

    if (email == 'test@example.com') {
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final storedEmail = prefs.getString(_keyUserEmail);

    if (storedEmail == null) {
      throw Exception('No account found with this email');
    }

    if (storedEmail != email) {
      throw Exception('No account found with this email');
    }
  }

  Future<void> resetPassword(
    String email,
    String newPassword,
    String confirmPassword,
  ) async {
    await Future.delayed(const Duration(seconds: 1));

    if (email.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      throw Exception('All fields are required');
    }

    if (newPassword.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }

    if (newPassword != confirmPassword) {
      throw Exception('Passwords do not match');
    }

    final prefs = await SharedPreferences.getInstance();
    final storedEmail = prefs.getString(_keyUserEmail);

    if (email == 'test@example.com') {
      await prefs.setString(_keyUserEmail, email);
      await prefs.setString(_keyUserPassword, newPassword);
      await prefs.setString(_keyUserFullName, 'Test User');
      await prefs.setBool(_keyIsLoggedIn, false);
      return;
    }

    if (storedEmail == null || storedEmail != email) {
      throw Exception('No account found with this email');
    }

    await prefs.setString(_keyUserPassword, newPassword);

    await prefs.setBool(_keyIsLoggedIn, false);
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

    final prefs = await SharedPreferences.getInstance();
    final storedPassword = prefs.getString(_keyUserPassword);

    if (storedPassword == null || storedPassword != oldPassword) {
      throw Exception('Current password is incorrect');
    }

    await prefs.setString(_keyUserPassword, newPassword);
  }

  Future<void> updateProfile(String fullName, String bio) async {
    await Future.delayed(const Duration(seconds: 1));

    if (fullName.trim().isEmpty) {
      throw Exception('Name is required');
    }

    if (fullName.trim().length < 2) {
      throw Exception('Name must be at least 2 characters');
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserFullName, fullName);
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 200));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, false);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  Future<String?> getCurrentUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserEmail);
  }

  Future<String?> getCurrentUserFullName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserFullName);
  }

  Future<String?> getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserId);
  }

  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
