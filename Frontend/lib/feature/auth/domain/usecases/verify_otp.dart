import 'package:angkor_store/core/usecases/usecase.dart';
import 'package:angkor_store/core/utils/type_defs.dart';
import 'package:equatable/equatable.dart';

import '../repositories/auth_repository.dart';

class VerifyOtp extends UseCaseWithParams<void, VerifyOtpParams> {
  const VerifyOtp(this._repo);

  final AuthRepository _repo;

  @override
  ResultFuture<void> call(VerifyOtpParams params) =>
      _repo.verifyOTP(email: params.email, otp: params.otp);
}

class VerifyOtpParams extends Equatable {
  const VerifyOtpParams({required this.email, required this.otp});

  final String email;
  final String otp;

  @override
  List<Object?> get props => [email, otp];
}
