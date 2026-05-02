import 'package:angkor_store/feature/auth/presentation/widgets/reset_password_form.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/common/widgets/app_bar_bottom.dart';
import '../../../../core/extensions/text_style_extension.dart';
import '../../../../core/res/style/text.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key, required this.email});

  static const path = '/resetPassword';
  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password', style: TextStyles.headingSimiBold),
        bottom: AppBarBottom(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30),
              children: [
                Text('Reset Your Password', style: TextStyles.headingBold3.adaptiveColor(context)),
                Text(
                  'Easy and secure way to reset your password',
                  style: TextStyles.paragraphSubTextRegular1.grey,
                ),
                Gap(40),
                ResetPasswordForm(email: email),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
