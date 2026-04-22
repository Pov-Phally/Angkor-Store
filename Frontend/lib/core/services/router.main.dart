part of 'router.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: rootNavigatorKey,
  debugLogDiagnostics: true,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: "/",
      redirect: (context, state) {
        final cacheHelper = serviceLocater<CacheHelper>()
          ..getSessionToken()
          ..getUserId();
        if ((Cache.instance.sessionToken == null ||
                Cache.instance.userID == null) &&
            !cacheHelper.isFirstTimer()) {
          return LoginScreen.path;
        }
        if (state.extra == "home") return HomeScreen.part;
        return null;
      },
      builder: (_, _) {
        final cacheHelper = serviceLocater<CacheHelper>()
          ..getSessionToken()
          ..getUserId();
        if (cacheHelper.isFirstTimer()) {
          return const OnBoardingScreen();
        } else {
          return const SplashScreen();
        }
      },
    ),
    GoRoute(path: LoginScreen.path, builder: (_, _) => LoginScreen()),
    ShellRoute(
      builder: (context, state, child) {
        return DashboardScreen(state: state, child: child);
      },
      routes: [
        GoRoute(path: HomeScreen.part, builder: (_, _) => const HomeScreen()),
      ],
    ),
  ],
);
