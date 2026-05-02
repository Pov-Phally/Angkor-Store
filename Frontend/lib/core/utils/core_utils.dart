import 'package:angkor_store/core/extensions/context_extension.dart';
import 'package:angkor_store/core/extensions/text_style_extension.dart';
import 'package:angkor_store/core/res/style/color.dart';
import 'package:angkor_store/core/res/style/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

abstract class CoreUtils {
  const CoreUtils();

  static void showSnackBar(
    BuildContext context, {
    required String message,
    Color? backgroundColor,
  }) {
    final snackBar = SnackBar(
      backgroundColor: backgroundColor ?? Colours.lightThemePrimaryColor,
      content: Text(message, style: TextStyles.paragraphSubTextRegular1.white),
    );
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static void postFrameCallback(VoidCallback callback) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  static Color adaptiveColor(
    BuildContext context, {

    required Color lightModeColor,

    required Color darkModeColor,
  }) {
    return context.isDarkMode ? darkModeColor : lightModeColor;
  }
}
