import 'dart:async';

import 'package:angkor_store/core/extensions/text_style_extension.dart';
import 'package:angkor_store/core/res/style/color.dart';
import 'package:angkor_store/core/res/style/text.dart';
import 'package:angkor_store/feature/auth/presentation/app/adapter/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OtpTimer extends StatefulWidget {
  const OtpTimer({super.key, required this.email});

  final String email;

  @override
  State<OtpTimer> createState() => _OtpTimerState();
}

class _OtpTimerState extends State<OtpTimer> {
  int _mainDuration = 60;
  int _duration = 60;
  int increment = 10;
  Timer? _timer;
  bool isResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _duration--;
        if (_duration == 0) {
          if (_mainDuration > 0) {
            increment *= 2;
          }
          _mainDuration += increment;
          _duration = _mainDuration;
          timer.cancel();
          setState(() {
            isResend = true;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final minute = _duration ~/ 60;
    final second = _duration.remainder(60);
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is OTPSent) {
          _startTimer();
          setState(() {
            isResend = false;
          });
        }
      },
      builder: (context, state) {
        return Center(
          child: switch (isResend) {
            true => switch (state) {
              AuthLoading _ => const SizedBox.shrink(),
              _ => TextButton(
                onPressed: () async {
                  context.read<AuthCubit>().forgotPassword(email: widget.email);
                },

                child: Text('Resend', style: TextStyles.headingMedium4.primary),
              ),
            },
            _ => RichText(
              text: TextSpan(
                text: 'Resending code in',
                style: TextStyles.headingMedium4.grey,
                children: [
                  TextSpan(
                    text: ' $minute:$second'.toString().padLeft(2, '0'),
                    style: TextStyle(color: Colours.lightThemePrimaryColor),
                  ),
                  TextSpan(text: ' second.'),
                ],
              ),
            ),
          },
        );
      },
    );
  }
}
