import 'package:angkor_store/core/utils/type_defs.dart';

import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class ForgotPassword extends UseCaseWithParams<void, String> {
  const ForgotPassword(this._repo);

  final AuthRepository _repo;

  @override
  ResultFuture<void> call(String params) => _repo.forgotPassword(email: params);
}
