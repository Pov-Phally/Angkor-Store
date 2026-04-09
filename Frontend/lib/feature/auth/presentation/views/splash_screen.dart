import 'package:angkor_store/core/common/widgets/angkor_store_logo.dart';
import 'package:angkor_store/core/res/style/color.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.lightThemePrimaryColor,
      body: Center(child: AngKorStoreLogo()),
    );
  }
}
