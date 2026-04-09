import 'package:angkor_store/core/extensions/context_extension.dart';
import 'package:flutter/cupertino.dart';

abstract class CoreUtils {
  const CoreUtils();

  static Color adaptiveColor(
    BuildContext context, {

    required Color lightModeColor,

    required Color darkModeColor,
  }) {
    return context.isDarkMode ? darkModeColor : lightModeColor;
  }
}
