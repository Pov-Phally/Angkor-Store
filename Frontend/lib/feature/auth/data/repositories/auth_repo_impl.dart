import 'package:angkor_store/core/common/entities/user.dart';
import 'package:angkor_store/core/errors/failures.dart';
import 'package:angkor_store/core/utils/type_defs.dart';
import 'package:angkor_store/feature/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepoImpl implements AuthRepository {
  const AuthRepoImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  ResultFuture<void> forgotPassword({required String email}) async {
    try {
      await _remoteDataSource.forgotPassword(email: email);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailures.fromException(e));
    }
  }

  @override
  ResultFuture<User> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _remoteDataSource.login(
        email: email,
        password: password,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailures.fromException(e));
    }
  }

  @override
  ResultFuture<void> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      await _remoteDataSource.register(
        name: name,
        email: email,
        password: password,
        phone: phone,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailures.fromException(e));
    }
  }

  @override
  ResultFuture<void> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    try {
      await _remoteDataSource.resetPassword(
        email: email,
        newPassword: newPassword,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailures.fromException(e));
    }
  }

  @override
  ResultFuture<void> verifyOTP({
    required String email,
    required String otp,
  }) async {
    try {
      await _remoteDataSource.verifyOTP(email: email, otp: otp);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailures.fromException(e));
    }
  }

  @override
  ResultFuture<bool> verifyToken() async {
    try {
      final result = await _remoteDataSource.verifyToken();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailures.fromException(e));
    }
  }

  @override
  ResultFuture<void> logout() async {
    try {
      await _remoteDataSource.logout();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailures.fromException(e));
    }
  }
}
