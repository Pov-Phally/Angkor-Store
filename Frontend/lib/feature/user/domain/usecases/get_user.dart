import 'package:angkor_store/core/common/entities/user.dart';
import 'package:angkor_store/core/usecases/usecase.dart';
import 'package:angkor_store/core/utils/type_defs.dart';
import 'package:angkor_store/feature/user/domain/repos/user_repo.dart';

class GetUser extends UseCaseWithParams<User, String> {
  const GetUser(this._repo);

  final UserRepo _repo;

  @override
  ResultFuture<User> call(String params) {
    return _repo.getUser(params);
  }
}
