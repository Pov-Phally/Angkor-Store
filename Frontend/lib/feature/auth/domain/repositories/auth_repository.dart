import 'package:angkor_store/core/common/entities/user.dart';

import '../../../../core/utils/type_defs.dart';

abstract class AuthRepository {
  const AuthRepository();

  ResultFuture<void> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  });

  ResultFuture<User> login({required String email, required String password});

  ResultFuture<void> forgotPassword({required String email});

  ResultFuture<void> verifyOTP({required String email, required String otp});

  ResultFuture<void> resetPassword({
    required String email,
    required String newPassword,
  });

  ResultFuture<bool> verifyToken();

  ResultFuture<void> logout();
}
