import 'package:angkor_store/core/usecases/usecase.dart';
import 'package:angkor_store/core/utils/type_defs.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/common/entities/user.dart';
import '../repositories/auth_repository.dart';

class Login extends UseCaseWithParams<User, LoginParams> {
  const Login(this._repo);

  final AuthRepository _repo;

  @override
  ResultFuture<User> call(LoginParams params) =>
      _repo.login(email: params.email, password: params.password);
}

class LoginParams extends Equatable {
  const LoginParams({required this.email, required this.password});

  const LoginParams.empty() : this(email: "", password: "");

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}
