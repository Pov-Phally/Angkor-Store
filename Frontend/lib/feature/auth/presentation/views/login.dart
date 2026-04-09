import 'package:angkor_store/core/common/widgets/app_bar_bottom.dart';
import 'package:angkor_store/core/res/style/text.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static const path = "/login";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login', style: TextStyles.headingSimiBold),
        bottom: AppBarBottom(),
      ),
      body: Container(),
    );
  }
}
