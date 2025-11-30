import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bloc/repository/auth/auth_bloc.dart';
import '../bloc/repository/auth/auth_event.dart';
import '../bloc/repository/auth/auth_state.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'test@example.com');
  final _passwordController = TextEditingController(text: 'password');
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        LoginSubmitted(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Something went wrong',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green.shade600,
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else if (state is AuthAuthenticated) {}
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 396.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 60.h),

                    Text(
                      'Social App',
                      style: TextStyle(
                        fontSize: 56.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1877F2),
                        letterSpacing: -2,
                      ),
                    ),

                    SizedBox(height: 16.h),

                    Text(
                      'Connect with friends and the world\naround you on Social App.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: Colors.grey.shade800,
                        height: 1.4,
                      ),
                    ),

                    SizedBox(height: 32.h),

                    Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 0,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              cursorColor: Colors.black,
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(fontSize: 16.sp),
                              decoration: InputDecoration(
                                hintText: 'Email address or phone number',
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 16.sp,
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade100,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: BorderSide(
                                    color: const Color(0xFF1877F2),
                                    width: 1.5,
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 16.h,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email or phone number';
                                }
                                return null;
                              },
                            ),

                            SizedBox(height: 12.h),

                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              style: TextStyle(fontSize: 16.sp),
                              decoration: InputDecoration(
                                hintText: 'Password',
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 16.sp,
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade100,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: BorderSide(
                                    color: const Color(0xFF1877F2),
                                    width: 1.5,
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 16.h,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.grey.shade600,
                                    size: 20.sp,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                            ),

                            SizedBox(height: 20.h),

                            BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, state) {
                                final isLoading = state is AuthLoading;
                                return SizedBox(
                                  width: double.infinity,
                                  height: 48.h,
                                  child: ElevatedButton(
                                    onPressed: isLoading ? null : _submitLogin,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF1877F2),
                                      foregroundColor: Colors.white,
                                      disabledBackgroundColor: const Color(
                                        0xFF1877F2,
                                      ).withOpacity(0.6),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                      ),
                                    ),
                                    child: isLoading
                                        ? SizedBox(
                                            height: 20.h,
                                            width: 20.w,
                                            child:
                                                const CircularProgressIndicator(
                                                  strokeWidth: 2.5,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                        Color
                                                      >(Colors.white),
                                                ),
                                          )
                                        : Text(
                                            'Log In',
                                            style: TextStyle(
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                  ),
                                );
                              },
                            ),

                            SizedBox(height: 16.h),

                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ForgotPasswordScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                'Forgot password?',
                                style: TextStyle(
                                  color: const Color(0xFF1877F2),
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),

                            SizedBox(height: 20.h),
                            Divider(color: Colors.grey.shade300, thickness: 1),
                            SizedBox(height: 8.h),

                            SizedBox(
                              height: 48.h,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF00A400),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 24.w,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                ),
                                child: Text(
                                  'Create new account',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 60.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
