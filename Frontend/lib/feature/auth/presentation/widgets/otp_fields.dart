import 'package:angkor_store/core/extensions/context_extension.dart';
import 'package:angkor_store/core/res/style/color.dart';
import 'package:angkor_store/core/res/style/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTPFields extends StatelessWidget {
  const OTPFields({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MaterialPinField(
        length: 4,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        autoFocus: true,
        enablePaste: true,
        autofillHints: [AutofillHints.oneTimeCode],
        theme: MaterialPinTheme(
          fillColor: Colors.transparent,
          focusedFillColor: Colors.transparent,
          filledBorderColor: context.theme.primaryColor,
          filledFillColor: Colors.transparent,
          showCursor: true,
          spacing: 5,
          textStyle: TextStyles.headingMedium3.copyWith(
            fontWeight: FontWeight.bold,
            color: Colours.classicAdaptiveTextColor(context),
          ),
          cellSize: Size(86, 59),
          borderWidth: 2.5,
          borderRadius: BorderRadius.circular(12),
        ),
        onChanged: (_) {},
        onCompleted: (pin) {
          controller.text = pin;
        },
      ),
    );
  }
}
