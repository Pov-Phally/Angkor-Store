import 'package:angkor_store/core/common/widgets/app_bar_bottom.dart';
import 'package:angkor_store/core/extensions/text_style_extension.dart';
import 'package:angkor_store/core/res/style/color.dart';
import 'package:angkor_store/core/res/style/text.dart';
import 'package:angkor_store/feature/auth/presentation/views/register_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../widgets/login_form.dart';

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
      body: Column(
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 30,
              ),
              children: [
                Text(
                  'Welcome',
                  style: TextStyles.headingBold3.adaptiveColor(context),
                ),
                Text(
                  'sign in with your account',
                  style: TextStyles.paragraphSubTextRegular1.grey,
                ),
                Gap(40),
                LoginForm(),
              ],
            ),
          ),
          const Gap(8),
          RichText(
            text: TextSpan(
              text: "Don't have an account? ",
              style: TextStyles.paragraphSubTextRegular3.grey,
              children: [
                TextSpan(
                  text: "Sign Up",
                  style: TextStyle(color: Colours.lightThemePrimaryColor),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      context.go(RegisterScreen.path);
                    },
                ),
              ],
            ),
          ),
          const Gap(20),
        ],
      ),
    );
  }
}
