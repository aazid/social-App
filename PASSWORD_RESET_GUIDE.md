# Password Reset with SharedPreferences - Complete Guide

## Overview
Your app now uses **SharedPreferences** to store user credentials locally. This allows password reset functionality that persists across app sessions.

## How It Works

### 📦 **Data Storage Structure**

The following data is stored in SharedPreferences:

```
- user_email: String (user's email address)
- user_password: String (user's password - encrypted in production!)
- user_full_name: String (user's full name)
- user_id: String (unique user identifier)
- is_logged_in: Boolean (login status)
```

## 🔐 Authentication Flow

### 1. **Sign Up**
```dart
// User registers with email, password, and full name
signUp(email, password, confirmPassword, fullName)
```
- Validates email format
- Checks password length (min 6 characters)
- Verifies password confirmation matches
- Checks if email already exists
- **Stores credentials in SharedPreferences**
- Generates unique user ID
- Marks user as logged in

### 2. **Login**
```dart
// User logs in with email and password
login(email, password)
```
- Retrieves stored email and password from SharedPreferences
- Compares provided credentials with stored ones
- If match: marks user as logged in
- If no match: throws error
- **Password must match the currently stored password**

### 3. **Forgot Password Flow**
```dart
// Step 1: Validate email
forgotPassword(email)

// Step 2: Reset password (you'll need to add this)
resetPassword(email, newPassword, confirmPassword)
```
- Verifies email exists in storage
- Validates new password requirements
- **Updates stored password**
- **Logs user out** (forces re-login with new password)

### 4. **Change Password (While Logged In)**
```dart
changePassword(oldPassword, newPassword, confirmPassword)
```
- Validates old password is correct
- Checks new password meets requirements
- Ensures new password is different from old
- **Updates stored password**
- Keeps user logged in

## 🔄 Password Reset Implementation

### Current Implementation Status

✅ **Completed:**
- SharedPreferences integration
- Login validates against stored password
- Sign up stores password
- Forgot password validates email
- `resetPassword()` method added to repository

⚠️ **To Implement:**
You need to create a password reset screen that uses the `resetPassword()` method.

### How to Complete Password Reset

Your forgot password screen currently only validates the email. To complete it:

1. After email validation, show a new screen to enter new password
2. Call the `resetPassword()` method
3. User will be logged out and redirected to login

## 📝 Example: Enhanced Forgot Password Flow

### Option 1: Two-Step Process (Recommended)

**Step 1:** ForgotPasswordScreen (current)
- User enters email
- Validates email exists
- Navigates to ResetPasswordScreen

**Step 2:** ResetPasswordScreen (new - you need to create)
- Shows new password and confirm password fields
- Calls `resetPassword(email, newPassword, confirmPassword)`
- Shows success message
- Navigates back to login

### Option 2: Single Screen

Update `ForgotPasswordScreen` to include:
- Email field
- New password field
- Confirm password field
- Call `resetPassword()` instead of `forgotPassword()`

## 🔍 How Password Changes Affect Login

### **IMPORTANT: Password Changes Are Immediate**

When a password is reset or changed:

1. ✅ New password is stored in SharedPreferences
2. ✅ All subsequent login attempts MUST use the new password
3. ✅ User is logged out (for forgot password)
4. ✅ Old password no longer works

**Example:**
```dart
// Initial signup
signUp('user@example.com', 'password123', 'password123', 'John')

// Login works with original password
login('user@example.com', 'password123') // ✅ Success

// Reset password
resetPassword('user@example.com', 'newpass456', 'newpass456')

// Old password no longer works
login('user@example.com', 'password123') // ❌ Fails

// Must use new password
login('user@example.com', 'newpass456') // ✅ Success
```

## 🛠️ Available Repository Methods

### Authentication Methods
- `login(email, password)` - Validate and login user
- `signUp(email, password, confirmPassword, fullName)` - Create new account
- `logout()` - Log out current user

### Password Management
- `forgotPassword(email)` - Validate email for reset
- `resetPassword(email, newPassword, confirmPassword)` - Reset password
- `changePassword(oldPassword, newPassword, confirmPassword)` - Change password while logged in

### User Data
- `updateProfile(fullName, bio)` - Update user profile
- `isLoggedIn()` - Check if user is logged in
- `getCurrentUserEmail()` - Get logged-in user's email
- `getCurrentUserFullName()` - Get user's full name
- `getCurrentUserId()` - Get user's ID

### Utility
- `clearAllData()` - Clear all stored data (for testing)

## 🎯 Next Steps

### To Complete Password Reset:

1. **Add Reset Password Event** (in auth_event.dart):
```dart
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
```

2. **Add Event Handler** (in auth_bloc.dart):
```dart
on<ResetPassword>(_onResetPassword);

Future<void> _onResetPassword(
  ResetPassword event,
  Emitter<AuthState> emit,
) async {
  emit(AuthLoading());
  try {
    await _authRepository.resetPassword(
      event.email,
      event.newPassword,
      event.confirmPassword,
    );
    emit(AuthSuccess('Password reset successfully!', message: 'Please login with your new password'));
  } catch (e) {
    emit(AuthError(message: e.toString()));
  }
}
```

3. **Create Reset Password Screen** (or modify existing)

## ⚠️ Security Notes

### Current Implementation (Development)
- Passwords stored as plain text in SharedPreferences
- **NOT suitable for production**

### For Production Apps
You should:
1. **Never store plain text passwords**
2. Use proper backend authentication (Firebase, etc.)
3. Implement token-based authentication
4. Hash passwords before storing
5. Use secure storage for sensitive data
6. Implement password reset via email

### This Implementation Is Good For:
- ✅ Learning and prototyping
- ✅ Offline-first apps with local data
- ✅ Understanding authentication flow
- ❌ Production apps with sensitive data

## 🧪 Testing the Implementation

### Test Scenario 1: Sign Up and Login
```
1. Sign up with email: test@example.com, password: test123
2. Logout
3. Login with same credentials
4. ✅ Should succeed
```

### Test Scenario 2: Password Reset
```
1. Create account
2. Logout
3. Go to forgot password
4. Enter email
5. Reset password to new value
6. Try to login with old password ❌ Should fail
7. Login with new password ✅ Should succeed
```

### Test Scenario 3: Multiple Users
```
Currently, the system supports ONE user at a time.
Signing up with a different email will replace the existing user.
For multi-user support, you'd need a different storage approach.
```

## 📱 User Experience

### What Users Experience:

1. **First Time**: Sign up creates account
2. **Returning**: Login with stored credentials
3. **Forgot Password**: 
   - Enter email
   - Create new password
   - Must login again with new password
4. **All Logins**: System checks against current password in storage

This creates a complete, self-contained authentication system with password persistence!
