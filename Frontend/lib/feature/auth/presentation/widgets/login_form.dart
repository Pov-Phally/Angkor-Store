import 'package:angkor_store/core/common/widgets/rounded_button.dart';
import 'package:angkor_store/core/extensions/text_style_extension.dart';
import 'package:angkor_store/core/extensions/widget_extention.dart';
import 'package:angkor_store/core/res/style/text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../core/common/widgets/vertical_label_field.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final obscurePasswordNotifier = ValueNotifier(true);

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    obscurePasswordNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          VerticalLabelField(
            label: 'Email',
            controller: emailController,
            hintText: "Enter your email",
            keyboardType: TextInputType.emailAddress,
          ),
          Gap(20),
          ValueListenableBuilder(
            valueListenable: obscurePasswordNotifier,
            builder: (_, value, _) {
              return VerticalLabelField(
                label: 'Password',
                controller: passwordController,
                hintText: "Enter your password",
                keyboardType: TextInputType.visiblePassword,
                obscureText: value,
                suffixIcon: GestureDetector(
                  onTap: () {
                    obscurePasswordNotifier.value =
                        !obscurePasswordNotifier.value;
                  },
                  child: Icon(
                    value
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                ),
              );
            },
          ),
          Gap(20),
          SizedBox(
            width: double.maxFinite,
            child: Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {
                  //TODO : Navigate to forgot password screen
                },
                child: Text(
                  "Forgot password?",
                  style: TextStyles.paragraphSubTextRegular1.primary,
                ),
              ),
            ),
          ),
          const Gap(40),
          RoundedButton(
            text: 'Sign In',
            onPressed: () {
              //TODO : Navigate to home screen
            },
          ).loading(false),
        ],
      ),
    );
  }
}
