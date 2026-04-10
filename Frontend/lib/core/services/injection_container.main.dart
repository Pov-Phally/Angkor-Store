part of 'injection_container.dart';

final serviceLocater = GetIt.instance;

Future<void> init() async {
  final pref = await SharedPreferences.getInstance();
  serviceLocater
    ..registerLazySingleton(() => CacheHelper(serviceLocater()))
    ..registerLazySingleton(() => pref);
}
