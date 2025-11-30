import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/bloc/repository/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository = AuthRepository();

  AuthBloc() : super(AuthInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<SignUp>(_onSignUp);
    on<ForgotPassword>(_onForgotPasswordsub);
    on<ResetPassword>(_onResetPassword);
    on<ChangePassword>(_onChangePasswordsub);
    on<UpdateProfile>(_onUpdateProfilesub);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final userId = await _authRepository.login(event.email, event.password);
      emit(AuthAuthenticated(userId!, userId: ''));
    } catch (e) {
      emit(AuthError(message: ''));
    }
  }

  Future<void> _onSignUp(SignUp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final userId = await _authRepository.signUp(
        event.email,
        event.password,
        event.confirmPassword,
        event.fullName,
      );
      emit(AuthAuthenticated(userId!, userId: ''));
      emit(AuthSuccess('Account created successfully!', message: ''));
    } catch (e) {
      emit(AuthError(message: ''));
    }
  }

  Future<void> _onForgotPasswordsub(
    ForgotPassword event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.forgotPassword(event.email);
      emit(
        AuthSuccess(
          'Email verified successfully!',
          message: 'Email verified successfully!',
        ),
      );
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

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
      emit(
        AuthSuccess(
          'Password reset successfully!',
          message:
              'Password reset successfully! Please login with your new password.',
        ),
      );
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onChangePasswordsub(
    ChangePassword event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.changePassword(
        event.oldPassword,
        event.newPassword,
        event.confirmPassword,
      );
      emit(AuthSuccess('Password changed successfully!', message: ''));
    } catch (e) {
      emit(AuthError(message: ''));
    }
  }

  Future<void> _onUpdateProfilesub(
    UpdateProfile event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.updateProfile(event.fullName, event.bio);
      emit(AuthSuccess('Profile updated!', message: ''));
    } catch (e) {
      emit(AuthError(message: ''));
    }
  }
}
