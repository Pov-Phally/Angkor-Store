import 'package:angkor_store/core/common/widgets/rounded_button.dart';
import 'package:angkor_store/core/extensions/widget_extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/widgets/vertical_label_field.dart';
import '../../../../core/utils/core_utils.dart';
import '../app/adapter/auth_cubit.dart';
import '../views/verify_otp_screen.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state case AuthError(:final message)) {
          CoreUtils.showSnackBar(context, message: message);
        } else if (state is OTPSent) {
          context.push(VerifyOtpScreen.path, extra: emailController.text);
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
                hintText: 'Enter your email',
                keyboardType: TextInputType.emailAddress,
              ),
              const Gap(40),
              RoundedButton(
                text: 'Continue',
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    final email = emailController.text.trim();
                    context.read<AuthCubit>().forgotPassword(email: email);
                  }
                },
              ).loading(state is AuthLoading),
            ],
          ),
        );
      },
    );
  }
}
