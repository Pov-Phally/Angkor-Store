import 'package:angkor_store/core/usecases/usecase.dart';
import 'package:angkor_store/core/utils/type_defs.dart';
import 'package:equatable/equatable.dart';

import '../repositories/auth_repository.dart';

class ResetPassword extends UseCaseWithParams<void, ResetPasswordParams> {
  const ResetPassword(this._repo);

  final AuthRepository _repo;

  @override
  ResultFuture<void> call(ResetPasswordParams params) =>
      _repo.resetPassword(email: params.email, newPassword: params.newPassword);
}

class ResetPasswordParams extends Equatable {
  const ResetPasswordParams({required this.email, required this.newPassword});

  final String email;
  final String newPassword;

  @override
  List<Object?> get props => [email, newPassword];
}
