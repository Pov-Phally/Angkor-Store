import 'package:flutter/material.dart';

import '../../../../core/res/style/text.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const part = "/home";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Welcome to Angkor Store!',
          style: TextStyles.headingSimiBold,
        ),
      ),
    );
  }
}
