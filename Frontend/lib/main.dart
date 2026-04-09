import 'package:angkor_store/core/res/style/color.dart';
import 'package:angkor_store/core/services/injection_container.dart';
import 'package:flutter/material.dart';

import 'core/services/router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      colorScheme: .fromSeed(seedColor: Colours.lightThemePrimaryColor),
      fontFamily: "Switzer",
      scaffoldBackgroundColor: Colours.lightThemeTintStockColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colours.lightThemeTintStockColor,
        foregroundColor: Colours.lightThemePrimaryTextColor,
      ),
      useMaterial3: true,
    );

    return MaterialApp.router(
      theme: theme,
      routerConfig: router,
      themeMode: ThemeMode.system,
      darkTheme: theme.copyWith(
        scaffoldBackgroundColor: Colours.darkThemeBGDark,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colours.darkThemeBGDark,
          foregroundColor: Colours.lightThemeWhiteColor,
        ),
      ),
    );
  }
}
