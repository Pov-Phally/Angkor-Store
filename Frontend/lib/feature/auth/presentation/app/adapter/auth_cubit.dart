import 'package:angkor_store/feature/auth/domain/usecases/forgot_password.dart';
import 'package:angkor_store/feature/auth/domain/usecases/verify_token.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/common/app/provider/user_provider.dart';
import '../../../../../core/common/entities/user.dart';
import '../../../domain/usecases/login.dart';
import '../../../domain/usecases/register.dart';
import '../../../domain/usecases/reset_password.dart';
import '../../../domain/usecases/verify_otp.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required ForgotPassword forgotPassword,
    required Login login,
    required Register register,
    required VerifyOtp verifyOtp,
    required ResetPassword resetPassword,
    required VerifyToken verifyToken,
  }) : _forgotPassword = forgotPassword,
       _login = login,
       _register = register,
       _verifyOtp = verifyOtp,
       _resetPassword = resetPassword,
       _verifyToken = verifyToken,
       super(AuthInitial());

  final ForgotPassword _forgotPassword;
  final Login _login;
  final Register _register;
  final VerifyOtp _verifyOtp;
  final ResetPassword _resetPassword;
  final VerifyToken _verifyToken;

  Future<void> login(String email, String password) async {
    emit(const AuthLoading());
    final result = await _login(LoginParams(email: email, password: password));
    result.fold((failure) => emit(AuthError(failure.errorMessage)), (user) {
      UserProvider.instance.setUser(user);
      emit(loggedIn(user));
    });
  }

  Future<void> register(
    String name,
    String email,
    String password,
    String phone,
  ) async {
    emit(const AuthLoading());
    final result = await _register(
      RegisterParams(
        name: name,
        email: email,
        password: password,
        phone: phone,
      ),
    );
    result.fold((failure) => emit(AuthError(failure.errorMessage)), (_) {
      emit(const Registered());
    });
  }

  Future<void> forgotPassword(String email) async {
    emit(const AuthLoading());
    final result = await _forgotPassword(ForgotPasswordParams(email: email));
    result.fold((failure) => emit(AuthError(failure.errorMessage)), (_) {
      emit(const OTPSent());
    });
  }

  Future<void> verifyOTP(String email, String otp) async {
    emit(const AuthLoading());
    final result = await _verifyOtp(VerifyOtpParams(email: email, otp: otp));
    result.fold((failure) => emit(AuthError(failure.errorMessage)), (_) {
      emit(const OTPVerified());
    });
  }

  Future<void> resetPassword(String email, String newPassword) async {
    emit(const AuthLoading());
    final result = await _resetPassword(
      ResetPasswordParams(email: email, newPassword: newPassword),
    );
    result.fold((failure) => emit(AuthError(failure.errorMessage)), (_) {
      emit(const PasswordReset());
    });
  }

  Future<void> verifyToken() async {
    emit(const AuthLoading());
    final result = await _verifyToken();
    result.fold((failure) => emit(AuthError(failure.errorMessage)), (isValid) {
      emit(TokenVerified(isValid));
      if (!isValid) UserProvider.instance.setUser(null);
    });
  }
}
