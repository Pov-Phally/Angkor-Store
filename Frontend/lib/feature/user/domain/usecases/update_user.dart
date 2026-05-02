import 'package:angkor_store/core/common/entities/user.dart';
import 'package:angkor_store/core/usecases/usecase.dart';
import 'package:angkor_store/core/utils/type_defs.dart';
import 'package:angkor_store/feature/user/domain/repos/user_repo.dart';
import 'package:equatable/equatable.dart';

class UpdateUser extends UseCaseWithParams<User, UpdateUserParams> {
  const UpdateUser(this._repo);

  final UserRepo _repo;

  @override
  ResultFuture<User> call(UpdateUserParams params) {
    return _repo.updateUser(
      userId: params.userId,
      updateData: params.updateData,
    );
  }
}

class UpdateUserParams extends Equatable {
  const UpdateUserParams({required this.userId, required this.updateData});

  final String userId;
  final DataMap updateData;

  @override
  List<Object?> get props => [userId, updateData];
}
