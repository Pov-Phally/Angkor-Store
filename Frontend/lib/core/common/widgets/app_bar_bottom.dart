import 'package:angkor_store/core/res/style/color.dart';
import 'package:flutter/material.dart';

class AppBarBottom extends StatelessWidget implements PreferredSizeWidget {
  const AppBarBottom({super.key});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: ColoredBox(
        color: Colours.classicAdaptiveTextColor(context),
        child: SizedBox(height: 1, width: double.maxFinite),
      ),
    );
  }

  @override
  Size get preferredSize => Size.zero;
}
