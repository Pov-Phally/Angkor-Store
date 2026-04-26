import 'package:angkor_store/core/common/widgets/app_bar_bottom.dart';
import 'package:angkor_store/core/extensions/text_style_extension.dart';
import 'package:angkor_store/core/res/style/color.dart';
import 'package:angkor_store/core/res/style/text.dart';
import 'package:angkor_store/feature/auth/presentation/views/login.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../widgets/register_form.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  static const path = "/register";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register', style: TextStyles.headingSimiBold),
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
                  'Create new account',
                  style: TextStyles.headingBold3.adaptiveColor(context),
                ),
                Text(
                  'Create new account with Angkor Store',
                  style: TextStyles.paragraphSubTextRegular1.grey,
                ),
                Gap(40),
                RegisterForm(),
              ],
            ),
          ),
          const Gap(8),
          RichText(
            text: TextSpan(
              text: "Already have an account? ",
              style: TextStyles.paragraphSubTextRegular3.grey,
              children: [
                TextSpan(
                  text: "Sign in",
                  style: TextStyle(color: Colours.lightThemePrimaryColor),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      context.go(LoginScreen.path);
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
