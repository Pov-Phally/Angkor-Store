import 'package:flutter/material.dart';

import '../../utils/core_utils.dart';

abstract class Colours {
  static const Color lightThemePrimaryTint = Color(0xff9e9cdc);

  static const Color lightThemePrimaryColor = Color(0xff524eb7);

  static const Color lightThemeSecondaryColor = Color(0xfff76631);

  static const Color lightThemePrimaryTextColor = Color(0xff282344);

  static const Color lightThemeSecondaryTextColor = Color(0xff9491a1);

  static const Color lightThemePinkColor = Color(0xfff08e98);

  static const Color lightThemeWhiteColor = Color(0xffffffff);

  static const Color lightThemeTintStockColor = Color(0xfff6f6f9);

  static const Color lightThemeYellowColor = Color(0xfffec613);

  static const Color lightTHemeStockColor = Color(0xffe4e4e9);

  static const Color darkThemeDarkSharpColor = Color(0xff191821);

  static const Color darkThemeBGDark = Color(0xff0e0d11);

  static const Color darkThemeDarkNavBarColor = Color(0xff201f27);

  static Color classicAdaptiveTextColor(BuildContext context) =>
      CoreUtils.adaptiveColor(
        context,
        lightModeColor: lightThemePrimaryTextColor,
        darkModeColor: lightThemeWhiteColor,
      );
}
