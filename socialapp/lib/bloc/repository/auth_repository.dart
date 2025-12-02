import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  static const String _keyAllUsers = 'all_users_db';

  static const String _keyCurrentEmail = 'current_user_email';
  static const String _keyIsLoggedIn = 'is_logged_in';

  Future<Map<String, dynamic>> _getAllUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final String? usersJson = prefs.getString(_keyAllUsers);
    if (usersJson == null) {
      return {};
    }
    return jsonDecode(usersJson) as Map<String, dynamic>;
  }

  Future<void> _saveAllUsers(Map<String, dynamic> users) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAllUsers, jsonEncode(users));
  }

  Future<String?> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password are required');
    }

    final users = await _getAllUsers();

    if (!users.containsKey(email)) {
      throw Exception('No account found. Please sign up first.');
    }

    final userData = users[email] as Map<String, dynamic>;
    if (userData['password'] == password) {
      await _createSession(email);
      return userData['id'];
    }

    throw Exception('Invalid email or password');
  }

  Future<String?> signUp({
    required String email,
    required String password,
    required String confirmPassword,
    required String firstName,
    required String lastName,
    required String dob,
    required String gender,
    String? profilePicturePath,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    if (email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        firstName.isEmpty ||
        lastName.isEmpty ||
        dob.isEmpty ||
        gender.isEmpty) {
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

    final users = await _getAllUsers();

    if (users.containsKey(email)) {
      throw Exception('Account already exists. Please login.');
    }

    final userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
    final fullName = '$firstName $lastName';

    await _createOrUpdateUser(
      email: email,
      password: password,
      fullName: fullName,
      id: userId,
      firstName: firstName,
      lastName: lastName,
      dob: dob,
      gender: gender,
      profilePicturePath: profilePicturePath,
    );

    await _createSession(email);

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

    if (email == 'test@example.com') return;

    final users = await _getAllUsers();
    if (!users.containsKey(email)) {
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

    final users = await _getAllUsers();

    if (!users.containsKey(email) && email != 'test@example.com') {
      throw Exception('No account found with this email');
    }

    String fullName = 'User';
    String userId = 'user_${DateTime.now().millisecondsSinceEpoch}';

    if (users.containsKey(email)) {
      final userData = users[email] as Map<String, dynamic>;
      fullName = userData['fullName'] ?? 'User';
      userId = userData['id'] ?? userId;
    } else if (email == 'test@example.com') {
      fullName = 'Test User';
      userId = 'user_test_id';
    }

    await _createOrUpdateUser(
      email: email,
      password: newPassword,
      fullName: fullName,
      id: userId,
    );

    final prefs = await SharedPreferences.getInstance();
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

    final currentUserEmail = await getCurrentUserEmail();
    if (currentUserEmail == null) {
      throw Exception('Not logged in');
    }

    final users = await _getAllUsers();
    final userData = users[currentUserEmail] as Map<String, dynamic>;

    if (userData['password'] != oldPassword) {
      throw Exception('Current password is incorrect');
    }

    await _createOrUpdateUser(
      email: currentUserEmail,
      password: newPassword,
      fullName: userData['fullName'],
      id: userData['id'],
    );
  }

  Future<void> updateProfile(String fullName, String bio) async {
    await Future.delayed(const Duration(seconds: 1));

    if (fullName.trim().isEmpty) {
      throw Exception('Name is required');
    }

    if (fullName.trim().length < 2) {
      throw Exception('Name must be at least 2 characters');
    }

    final currentUserEmail = await getCurrentUserEmail();
    if (currentUserEmail == null) {
      throw Exception('Not logged in');
    }

    final users = await _getAllUsers();
    final userData = users[currentUserEmail] as Map<String, dynamic>;

    await _createOrUpdateUser(
      email: currentUserEmail,
      password: userData['password'],
      fullName: fullName,
      id: userData['id'],
    );
  }

  Future<void> _createOrUpdateUser({
    required String email,
    required String password,
    required String fullName,
    required String id,
    String? firstName,
    String? lastName,
    String? dob,
    String? gender,
    String? profilePicturePath,
  }) async {
    final users = await _getAllUsers();
    users[email] = {
      'password': password,
      'fullName': fullName,
      'id': id,
      if (firstName != null) 'firstName': firstName,
      if (lastName != null) 'lastName': lastName,
      if (dob != null) 'dob': dob,
      if (gender != null) 'gender': gender,
      if (profilePicturePath != null) 'profilePicturePath': profilePicturePath,
    };
    await _saveAllUsers(users);
  }

  Future<void> _createSession(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCurrentEmail, email);
    await prefs.setBool(_keyIsLoggedIn, true);
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 200));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, false);
    await prefs.remove(_keyCurrentEmail);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  Future<String?> getCurrentUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyCurrentEmail);
  }

  Future<String?> getCurrentUserFullName() async {
    final email = await getCurrentUserEmail();
    if (email == null) return null;

    final users = await _getAllUsers();
    if (users.containsKey(email)) {
      return users[email]['fullName'];
    }
    return null;
  }

  Future<String?> getCurrentUserId() async {
    final email = await getCurrentUserEmail();
    if (email == null) return null;

    final users = await _getAllUsers();
    if (users.containsKey(email)) {
      return users[email]['id'];
    }
    return null;
  }

  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
