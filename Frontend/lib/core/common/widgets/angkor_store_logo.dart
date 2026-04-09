import 'package:angkor_store/core/res/style/text.dart';
import 'package:flutter/material.dart';

import '../../extensions/text_style_extension.dart';
import '../../res/style/color.dart';

class AngKorStoreLogo extends StatelessWidget {
  const AngKorStoreLogo({super.key, this.textStyle});

  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: "Angkor ",
        style: textStyle ?? TextStyles.appLogo.white,
        children: [
          TextSpan(
            text: "Store",
            style: TextStyle(color: Colours.lightThemeSecondaryColor),
          ),
        ],
      ),
    );
  }
}
