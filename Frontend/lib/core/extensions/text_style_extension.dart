import 'package:angkor_store/core/res/style/color.dart';
import 'package:flutter/material.dart';

extension TextStyleExtension on TextStyle {
  TextStyle get orange => copyWith(color: Colours.lightThemeSecondaryColor);

  TextStyle get darl => copyWith(color: Colours.lightThemePrimaryTextColor);

  TextStyle get grey => copyWith(color: Colours.lightThemeSecondaryTextColor);

  TextStyle get white => copyWith(color: Colours.lightThemeWhiteColor);

  TextStyle get primary => copyWith(color: Colours.lightThemePrimaryColor);

  TextStyle adaptiveColor(BuildContext context) =>
      copyWith(color: Colours.classicAdaptiveTextColor(context));
}
