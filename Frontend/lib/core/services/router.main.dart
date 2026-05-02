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
        if ((Cache.instance.sessionToken == null || Cache.instance.userId == null) &&
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
        }
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => serviceLocater<AuthCubit>()),
            BlocProvider(create: (_) => serviceLocater<UserCubit>()),
          ],
          child: const SplashScreen(),
        );
      },
    ),
    GoRoute(
      path: LoginScreen.path,
      builder: (_, _) =>
          BlocProvider(create: (context) => serviceLocater<AuthCubit>(), child: LoginScreen()),
    ),
    GoRoute(
      path: RegisterScreen.path,
      builder: (_, _) =>
          BlocProvider(create: (context) => serviceLocater<AuthCubit>(), child: RegisterScreen()),
    ),
    GoRoute(
      path: ResetPasswordScreen.path,
      builder: (_, state) => BlocProvider(
        create: (context) => serviceLocater<AuthCubit>(),
        child: ResetPasswordScreen(email: state.extra as String),
      ),
    ),
    GoRoute(
      path: VerifyOtpScreen.path,
      builder: (_, state) => BlocProvider(
        create: (context) => serviceLocater<AuthCubit>(),
        child: VerifyOtpScreen(email: state.extra as String),
      ),
    ),
    GoRoute(
      path: ForgotPasswordScreen.path,
      builder: (_, _) => BlocProvider(
        create: (context) => serviceLocater<AuthCubit>(),
        child: ForgotPasswordScreen(),
      ),
    ),

    ShellRoute(
      builder: (context, state, child) {
        return DashboardScreen(state: state, child: child);
      },
      routes: [GoRoute(path: HomeScreen.part, builder: (_, _) => const HomeScreen())],
    ),
  ],
);
