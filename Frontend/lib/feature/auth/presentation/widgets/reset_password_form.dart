import 'package:angkor_store/core/extensions/widget_extention.dart';
import 'package:angkor_store/core/utils/core_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/widgets/rounded_button.dart';
import '../../../../core/common/widgets/vertical_label_field.dart';
import '../app/adapter/auth_cubit.dart';

class ResetPasswordForm extends StatefulWidget {
  const ResetPasswordForm({super.key, required this.email});

  final String email;

  @override
  State<ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  final form = GlobalKey<FormState>();

  final newPasswordController = TextEditingController();

  final confirmNewPasswordController = TextEditingController();

  final obscureNewPasswordNotifier = ValueNotifier(true);

  final obscureConfirmNewPasswordNotifier = ValueNotifier(true);

  @override
  void dispose() {
    super.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    obscureNewPasswordNotifier.dispose();
    obscureConfirmNewPasswordNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state case AuthError(:final message)) {
          CoreUtils.showSnackBar(context, message: message);
        } else if (state is PasswordReset) {
          CoreUtils.showSnackBar(context, message: 'Password reset successfully');
          context.go('/');
        }
      },
      builder: (context, state) {
        return Form(
          key: form,
          child: Column(
            children: [
              ValueListenableBuilder(
                valueListenable: obscureNewPasswordNotifier,
                builder: (context, newPassword, child) {
                  return VerticalLabelField(
                    label: 'New Password',
                    controller: newPasswordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: newPassword,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        obscureNewPasswordNotifier.value = !obscureNewPasswordNotifier.value;
                      },
                      child: Icon(
                        newPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      ),
                    ),
                  );
                },
              ),
              const Gap(20),
              ValueListenableBuilder(
                valueListenable: obscureConfirmNewPasswordNotifier,
                builder: (context, confirmNewPassword, child) {
                  return VerticalLabelField(
                    label: 'Confirm New Password',
                    controller: confirmNewPasswordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: confirmNewPassword,
                    validator: (value) {
                      if (value != newPasswordController.text.trim()) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    suffixIcon: GestureDetector(
                      onTap: () {
                        obscureConfirmNewPasswordNotifier.value =
                            !obscureConfirmNewPasswordNotifier.value;
                      },
                      child: Icon(
                        confirmNewPassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                    ),
                  );
                },
              ),
              const Gap(40),

              RoundedButton(
                text: 'Confirm reset password',
                onPressed: () {
                  if (form.currentState!.validate()) {
                    context.read<AuthCubit>().resetPassword(
                      email: widget.email,
                      newPassword: newPasswordController.text.trim(),
                    );
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
