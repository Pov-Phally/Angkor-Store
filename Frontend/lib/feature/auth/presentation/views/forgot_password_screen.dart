import 'package:angkor_store/core/common/widgets/app_bar_bottom.dart';
import 'package:angkor_store/core/extensions/text_style_extension.dart';
import 'package:angkor_store/core/res/style/text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../widgets/forgot_password_form.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  static const path = "/forgotPassword";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recovery', style: TextStyles.headingSimiBold),
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
                  'Forgot your password?',
                  style: TextStyles.headingBold3.adaptiveColor(context),
                ),
                Text(
                  'Recover your account with an email address.',
                  style: TextStyles.paragraphSubTextRegular1.grey,
                ),
                Gap(40),
                ForgotPasswordForm(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
