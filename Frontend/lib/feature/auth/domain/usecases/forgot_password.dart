import 'package:angkor_store/core/utils/type_defs.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class ForgotPassword extends UseCaseWithParams<void, ForgotPasswordParams> {
  const ForgotPassword(this._repo);

  final AuthRepository _repo;

  @override
  ResultFuture<void> call(ForgotPasswordParams params) =>
      _repo.forgotPassword(email: params.email);
}

class ForgotPasswordParams extends Equatable {
  const ForgotPasswordParams({required this.email});

  final String email;

  @override
  List<Object?> get props => [email];
}
