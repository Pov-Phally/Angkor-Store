import 'package:angkor_store/core/common/widgets/rounded_button.dart';
import 'package:angkor_store/core/extensions/string_extension.dart';
import 'package:angkor_store/core/utils/core_utils.dart';
import 'package:angkor_store/feature/auth/presentation/app/adapter/auth_cubit.dart';
import 'package:angkor_store/feature/auth/presentation/views/reset_password_screen.dart';
import 'package:angkor_store/feature/auth/presentation/widgets/otp_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/widgets/app_bar_bottom.dart';
import '../../../../core/extensions/text_style_extension.dart';
import '../../../../core/extensions/widget_extention.dart';
import '../../../../core/res/style/text.dart';
import '../widgets/otp_fields.dart';

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key, required this.email});

  static const path = '/verifyOTP';
  final String email;

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final otpController = TextEditingController();

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state case AuthError(:final message)) {
          CoreUtils.showSnackBar(context, message: message);
        } else if (state is OTPVerified) {
          context.pushReplacement(ResetPasswordScreen.path, extra: widget.email);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Verify OTP', style: TextStyles.headingSimiBold),
            bottom: AppBarBottom(),
          ),
          body: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Verification Code', style: TextStyles.headingBold3.adaptiveColor(context)),
                  Text(
                    'Code has been sent to ${widget.email.obscureEmail}',
                    style: TextStyles.paragraphSubTextRegular1.grey,
                  ),
                  Text(
                    'Please check your email and enter the code',
                    style: TextStyles.paragraphSubTextRegular1.grey,
                  ),

                  Gap(40),
                  OTPFields(controller: otpController),
                  const Gap(40),
                  OtpTimer(email: widget.email),
                  const Gap(40),
                  RoundedButton(
                    text: 'verify',
                    onPressed: () {
                      if (otpController.text.length < 4) {
                        CoreUtils.showSnackBar(context, message: 'Invalid verification code');
                      } else {
                        context.read<AuthCubit>().verifyOTP(
                          email: widget.email,
                          otp: otpController.text.trim(),
                        );
                      }
                    },
                  ).loading(state is AuthLoading),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
