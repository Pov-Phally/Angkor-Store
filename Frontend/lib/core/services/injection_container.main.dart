part of 'injection_container.dart';

final serviceLocater = GetIt.instance;

Future<void> init() async {
  await cacheInit();
  await authInit();
  await userInit();
}

Future<void> userInit() async {
  serviceLocater
    ..registerFactory(
      () => UserCubit(
        getUser: serviceLocater(),
        updateUser: serviceLocater(),
        getUserPaymentProfile: serviceLocater(),
        currentUserProvider: serviceLocater(),
      ),
    )
    ..registerLazySingleton(() => GetUser(serviceLocater()))
    ..registerLazySingleton(() => UpdateUser(serviceLocater()))
    ..registerLazySingleton(() => GetUserPaymentProfile(serviceLocater()))
    ..registerLazySingleton<UserRepo>(() => UserRepoImpl(serviceLocater()))
    ..registerLazySingleton<UserRemoteDatasource>(
      () => UserRemoteDatasourceImpl(serviceLocater()),
    );
}

Future<void> authInit() async {
  serviceLocater
    ..registerFactory(
      () => AuthCubit(
        forgotPassword: serviceLocater(),
        login: serviceLocater(),
        register: serviceLocater(),
        verifyOtp: serviceLocater(),
        resetPassword: serviceLocater(),
        verifyToken: serviceLocater(),
      ),
    )
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
    ..registerLazySingleton(() => UserProvider.instance)
    ..registerLazySingleton(http.Client.new);
}

Future<void> cacheInit() async {
  final pref = await SharedPreferences.getInstance();
  serviceLocater
    ..registerLazySingleton(() => CacheHelper(serviceLocater()))
    ..registerLazySingleton(() => pref);
}
