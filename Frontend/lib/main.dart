import 'package:angkor_store/core/res/style/color.dart';
import 'package:angkor_store/core/res/style/text.dart';
import 'package:flutter/material.dart';

void main() {
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

    return MaterialApp(
      theme: theme,
      themeMode: ThemeMode.system,
      darkTheme: theme.copyWith(
        scaffoldBackgroundColor: Colours.darkThemeBGDark,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colours.darkThemeBGDark,
          foregroundColor: Colours.lightThemeWhiteColor,
        ),
      ),

      title: 'Flutter Demo',
      home: Scaffold(
        body: Text(
          'Hello',
          style: TextStyles.headingBold.copyWith(
            color: Colours.classicAdaptiveTextColor(context),
          ),
        ),
      ),
    );
  }
}
