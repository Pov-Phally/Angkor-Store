import 'package:angkor_store/feature/auth/domain/usecases/forgot_password.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../feature/auth/data/datasources/auth_remote_data_source.dart';
import '../../feature/auth/data/repositories/auth_repo_impl.dart';
import '../../feature/auth/domain/repositories/auth_repository.dart';
import '../../feature/auth/domain/usecases/login.dart';
import '../../feature/auth/domain/usecases/register.dart';
import '../../feature/auth/domain/usecases/reset_password.dart';
import '../../feature/auth/domain/usecases/verify_otp.dart';
import '../../feature/auth/domain/usecases/verify_token.dart';
import '../common/app/cache_helper.dart';

part 'injection_container.main.dart';
