import 'package:angkor_store/core/common/widgets/rounded_button.dart';
import 'package:angkor_store/core/extensions/text_style_extension.dart';
import 'package:angkor_store/core/extensions/widget_extention.dart';
import 'package:angkor_store/core/res/style/text.dart';
import 'package:angkor_store/core/utils/core_utils.dart';
import 'package:angkor_store/feature/auth/presentation/app/adapter/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/common/widgets/vertical_label_field.dart';
import '../views/forgot_password_screen.dart';

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
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state case AuthError(:final message)) {
          CoreUtils.showSnackBar(context, message: message);
        } else if (state is LoggedIn) {
          context.go("/", extra: 'home');
        }
      },
      builder: (context, state) {
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
                      context.push(ForgotPasswordScreen.path);
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
                  if (!formKey.currentState!.validate()) {
                    return;
                  }
                  final email = emailController.text.trim();
                  final password = passwordController.text.trim();
                  context.read<AuthCubit>().login(
                    email: email,
                    password: password,
                  );
                },
              ).loading(state is AuthLoading),
            ],
          ),
        );
      },
    );
  }
}
