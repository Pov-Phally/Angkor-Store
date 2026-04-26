import 'package:angkor_store/core/res/style/color.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
    required this.originalWidget,
    required this.isLoading,
    this.loadingWidget,
  });

  final Widget originalWidget;
  final bool isLoading;
  final Widget? loadingWidget;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return loadingWidget ??
          const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colours.lightThemePrimaryColor,
            ),
          );
    }
    return originalWidget;
  }
}
