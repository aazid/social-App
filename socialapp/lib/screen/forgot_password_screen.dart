import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bloc/repository/auth/auth_bloc.dart';
import '../bloc/repository/auth/auth_event.dart';
import '../bloc/repository/auth/auth_state.dart';
import 'change_password_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submitResetRequest() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        ForgotPassword(email: _emailController.text.trim()),
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
          'Reset Password',
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ChangePasswordScreen(email: _emailController.text.trim()),
              ),
            );
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

                  Center(
                    child: Container(
                      padding: EdgeInsets.all(24.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF1877F2).withOpacity(0.1),
                      ),
                      child: Icon(
                        Icons.lock_reset_rounded,
                        size: 64.sp,
                        color: const Color(0xFF1877F2),
                      ),
                    ),
                  ),

                  SizedBox(height: 32.h),

                  Text(
                    'Forgot Your Password?',
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade900,
                    ),
                  ),

                  SizedBox(height: 12.h),

                  Text(
                    'Enter your email address and we\'ll send you instructions to reset your password.',
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: Colors.grey.shade600,
                      height: 1.5,
                    ),
                  ),

                  SizedBox(height: 32.h),

                  Text(
                    'Email Address',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),

                  SizedBox(height: 8.h),

                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: const Color(0xFF1877F2),
                    style: TextStyle(fontSize: 16.sp),
                    decoration: InputDecoration(
                      hintText: 'Enter your email address',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 16.sp,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: Colors.grey.shade600,
                        size: 20.sp,
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
                        return 'Please enter your email address';
                      }
                      if (!value.contains('@') || !value.contains('.')) {
                        return 'Please enter a valid email address';
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
                          onPressed: isLoading ? null : _submitResetRequest,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1877F2),
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: const Color(
                              0xFF1877F2,
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
                                  'Send Reset Link',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 24.h),

                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.arrow_back,
                            size: 18.sp,
                            color: const Color(0xFF1877F2),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Back to Login',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1877F2),
                            ),
                          ),
                        ],
                      ),
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
}
