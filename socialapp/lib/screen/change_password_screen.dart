import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bloc/repository/auth/auth_bloc.dart';
import '../bloc/repository/auth/auth_event.dart';
import '../bloc/repository/auth/auth_state.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String email;

  const ChangePasswordScreen({super.key, required this.email});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitReset() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        ResetPassword(
          email: widget.email,
          newPassword: _newPasswordController.text,
          confirmPassword: _confirmPasswordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.grey.shade800,
            size: 24.sp,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Create New Password',
          style: TextStyle(
            color: Colors.grey.shade900,
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.green.shade600,
                behavior: SnackBarBehavior.floating,
              ),
            );

            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) {
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            });
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),

                  // Icon
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(24.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF00A400).withOpacity(0.1),
                      ),
                      child: Icon(
                        Icons.check_circle_outline,
                        size: 64.sp,
                        color: const Color(0xFF00A400),
                      ),
                    ),
                  ),

                  SizedBox(height: 32.h),

                  Text(
                    'Create New Password',
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade900,
                    ),
                  ),

                  SizedBox(height: 12.h),

                  Text(
                    'Your email has been verified. Now create a strong password for your account.',
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: Colors.grey.shade600,
                      height: 1.5,
                    ),
                  ),

                  SizedBox(height: 8.h),

                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.email,
                          size: 16.sp,
                          color: const Color(0xFF1877F2),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          widget.email,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: const Color(0xFF1877F2),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 32.h),

                  Text(
                    'New Password',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),

                  SizedBox(height: 8.h),

                  TextFormField(
                    controller: _newPasswordController,
                    obscureText: _obscureNewPassword,
                    cursorColor: const Color(0xFF1877F2),
                    style: TextStyle(fontSize: 16.sp),
                    decoration: InputDecoration(
                      hintText: 'Enter new password',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 16.sp,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: Colors.grey.shade600,
                        size: 20.sp,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureNewPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey.shade600,
                          size: 20.sp,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureNewPassword = !_obscureNewPassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: const Color(0xFF1877F2),
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: Colors.red.shade400),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: Colors.red.shade400,
                          width: 2,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 16.h,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 20.h),

                  Text(
                    'Confirm Password',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),

                  SizedBox(height: 8.h),

                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    cursorColor: const Color(0xFF1877F2),
                    style: TextStyle(fontSize: 16.sp),
                    decoration: InputDecoration(
                      hintText: 'Re-enter new password',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 16.sp,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: Colors.grey.shade600,
                        size: 20.sp,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey.shade600,
                          size: 20.sp,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: const Color(0xFF1877F2),
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: Colors.red.shade400),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: Colors.red.shade400,
                          width: 2,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 16.h,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _newPasswordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 32.h),

                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      final isLoading = state is AuthLoading;
                      return SizedBox(
                        width: double.infinity,
                        height: 52.h,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _submitReset,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00A400),
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: const Color(
                              0xFF00A400,
                            ).withOpacity(0.6),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: isLoading
                              ? SizedBox(
                                  height: 20.h,
                                  width: 20.w,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Text(
                                  'Reset Password',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 16.h),

                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Password Requirements:',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        _buildRequirement('At least 6 characters long'),
                        _buildRequirement('Must match confirmation'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRequirement(String text) {
    return Padding(
      padding: EdgeInsets.only(top: 4.h),
      child: Row(
        children: [
          Icon(Icons.check_circle, size: 14.sp, color: Colors.grey.shade600),
          SizedBox(width: 8.w),
          Text(
            text,
            style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }
}
