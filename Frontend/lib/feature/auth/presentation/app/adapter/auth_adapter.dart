import 'package:angkor_store/core/services/injection_container.dart';
import 'package:angkor_store/feature/auth/domain/usecases/login.dart';
import 'package:angkor_store/feature/auth/domain/usecases/verify_otp.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/common/app/riverpod/current_user_provider.dart';
import '../../../../../core/common/entities/user.dart';
import '../../../domain/usecases/forgot_password.dart';
import '../../../domain/usecases/register.dart';
import '../../../domain/usecases/reset_password.dart';
import '../../../domain/usecases/verify_token.dart';

part "auth_adapter.g.dart";
part 'auth_state.dart';

@riverpod
class AuthAdapter extends _$AuthAdapter {
  @override
  AuthState build([GlobalKey? familyKey]) {
    _forgotPassword = serviceLocater<ForgotPassword>();
    _login = serviceLocater<Login>();
    _register = serviceLocater<Register>();
    _verifyOTP = serviceLocater<VerifyOtp>();
    _resetPassword = serviceLocater<ResetPassword>();
    _verifyToken = serviceLocater<VerifyToken>();
    return const AuthInitial();
  }

  late Login _login;
  late Register _register;
  late ForgotPassword _forgotPassword;
  late VerifyOtp _verifyOTP;
  late ResetPassword _resetPassword;
  late VerifyToken _verifyToken;

  Future<void> login(String email, String password) async {
    state = const AuthLoading();
    final result = await _login(LoginParams(email: email, password: password));
    result.fold((failure) => state = AuthError(failure.errorMessage), (user) {
      ref.read(currentUserProvider.notifier).setUser(user);
      state = loggedIn(user);
    });
  }

  Future<void> register(
    String name,
    String email,
    String password,
    String phone,
  ) async {
    state = const AuthLoading();
    final result = await _register(
      RegisterParams(
        name: name,
        email: email,
        password: password,
        phone: phone,
      ),
    );
    result.fold((failure) => state = AuthError(failure.errorMessage), (_) {
      state = const Registered();
    });
  }

  Future<void> forgotPassword(String email) async {
    state = const AuthLoading();
    final result = await _forgotPassword(ForgotPasswordParams(email: email));
    result.fold((failure) => state = AuthError(failure.errorMessage), (_) {
      state = const OTPSent();
    });
  }

  Future<void> verifyOTP(String email, String otp) async {
    state = const AuthLoading();
    final result = await _verifyOTP(VerifyOtpParams(email: email, otp: otp));
    result.fold((failure) => state = AuthError(failure.errorMessage), (_) {
      state = const OTPVerified();
    });
  }

  Future<void> resetPassword(String email, String newPassword) async {
    state = const AuthLoading();
    final result = await _resetPassword(
      ResetPasswordParams(email: email, newPassword: newPassword),
    );
    result.fold((failure) => state = AuthError(failure.errorMessage), (_) {
      state = const PasswordReset();
    });
  }

  Future<void> verifyToken() async {
    state = const AuthLoading();
    final result = await _verifyToken();
    result.fold((failure) => state = AuthError(failure.errorMessage), (
      isValid,
    ) {
      state = TokenVerified(isValid);
      if (!isValid) ref.read(currentUserProvider.notifier).setUser(null);
    });
  }
}
