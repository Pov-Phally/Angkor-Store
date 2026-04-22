import 'package:angkor_store/core/usecases/usecase.dart';

import '../../../../core/utils/type_defs.dart';
import '../repos/user_repo.dart';

class GetUserPaymentProfile extends UseCaseWithParams<String, String> {
  const GetUserPaymentProfile(this._repo);

  final UserRepo _repo;

  @override
  ResultFuture<String> call(String params) {
    return _repo.getUserPaymentProfile(params);
  }
}
