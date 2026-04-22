part of 'injection_container.dart';

final serviceLocater = GetIt.instance;

Future<void> init() async {
  await cacheInit();
  await authInit();
}

Future<void> cacheInit() async {
  final pref = await SharedPreferences.getInstance();
  serviceLocater
    ..registerLazySingleton(() => CacheHelper(serviceLocater()))
    ..registerLazySingleton(() => pref);
}

Future<void> authInit() async {
  serviceLocater
    ..registerLazySingleton(() => ForgotPassword(serviceLocater()))
    ..registerLazySingleton(() => Login(serviceLocater()))
    ..registerLazySingleton(() => Register(serviceLocater()))
    ..registerLazySingleton(() => ResetPassword(serviceLocater()))
    ..registerLazySingleton(() => VerifyOtp(serviceLocater()))
    ..registerLazySingleton(() => VerifyToken(serviceLocater()))
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepoImpl(serviceLocater()),
    )
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImplementation(serviceLocater()),
    )
    ..registerLazySingleton(http.Client.new);
}
