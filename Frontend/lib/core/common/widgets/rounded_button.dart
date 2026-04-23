import 'package:angkor_store/core/extensions/text_style_extension.dart';
import 'package:flutter/material.dart';

import '../../res/style/text.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    super.key,
    this.onPressed,
    required this.text,
    this.backGroundColor,
    this.textStyle,
    this.height,
    this.padding,
  });

  final VoidCallback? onPressed;
  final String text;
  final Color? backGroundColor;
  final TextStyle? textStyle;
  final double? height;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 67,
      width: double.maxFinite,
      child: FilledButton(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: backGroundColor,
          padding: padding,
        ),
        onPressed: () {
          FocusManager.instance.primaryFocus?.unfocus();
          onPressed?.call();
        },
        child: Text(
          text,
          style: textStyle ?? TextStyles.buttonTextHeadingSemiBold.white,
        ),
      ),
    );
  }
}
