import 'package:angkor_store/core/common/widgets/input_field.dart';
import 'package:angkor_store/core/extensions/text_style_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

import '../../res/style/text.dart';

class VerticalLabelField extends StatelessWidget {
  const VerticalLabelField({
    super.key,
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.defaultValidation = true,
    this.enable = true,
    this.mainFieldFlex = 1,
    this.prefixFlex = 1,
    this.readOnly = false,
    this.suffixIcon,
    this.hintText,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.prefix,
    this.contentPadding,
    this.prefixIcon,
    this.focusNode,
  });

  final String label;
  final Widget? suffixIcon;
  final String? hintText;
  final String? Function(String? value)? validator;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool defaultValidation;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefix;
  final bool enable;
  final bool readOnly;
  final EdgeInsetsGeometry? contentPadding;
  final Widget? prefixIcon;
  final FocusNode? focusNode;
  final int mainFieldFlex;
  final int prefixFlex;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyles.headingMedium4.adaptiveColor(context)),
        Gap(10),
        Row(
          children: [
            if (prefix != null) ...[
              Expanded(flex: prefixFlex, child: prefix!),
              const Gap(8),
            ],
            Expanded(
              flex: mainFieldFlex,
              child: InputField(
                controller: controller,
                focusNode: focusNode,
                enable: enable,
                readOnly: readOnly,
                obscureText: obscureText,
                defaultValidation: defaultValidation,
                validator: validator,
                keyboardType: keyboardType,
                inputFormatters: inputFormatters,
                contentPadding: contentPadding,
                prefixIcon: prefixIcon,
                hintText: hintText,
                suffixIcon: suffixIcon,
                onTap: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }
}
