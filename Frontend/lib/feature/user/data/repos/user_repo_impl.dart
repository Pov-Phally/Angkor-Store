import 'package:angkor_store/core/common/entities/user.dart';
import 'package:angkor_store/core/errors/exceptions.dart';
import 'package:angkor_store/core/utils/type_defs.dart';
import 'package:angkor_store/feature/user/domain/repos/user_repo.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../datasources/user_remote_datasource.dart';

class UserRepoImpl implements UserRepo {
  const UserRepoImpl(this._remoteDataSource);

  final UserRemoteDatasource _remoteDataSource;

  @override
  ResultFuture<User> getUser(String userId) async {
    try {
      final result = await _remoteDataSource.getUser(userId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailures.fromException(e));
    }
  }

  @override
  ResultFuture<String> getUserPaymentProfile(String userId) async {
    try {
      final result = await _remoteDataSource.getUserPaymentProfile(userId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailures.fromException(e));
    }
  }

  @override
  ResultFuture<User> updateUser({
    required String userId,
    required DataMap updateData,
  }) async {
    try {
      final result = await _remoteDataSource.updateUser(
        userId: userId,
        updateData: updateData,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailures.fromException(e));
    }
  }
}
