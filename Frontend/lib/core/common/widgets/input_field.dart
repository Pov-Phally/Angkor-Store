import 'package:angkor_store/core/extensions/context_extension.dart';
import 'package:angkor_store/core/extensions/text_style_extension.dart';
import 'package:angkor_store/core/res/style/text.dart';
import 'package:angkor_store/core/utils/core_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../res/style/color.dart';

class InputField extends StatelessWidget {
  const InputField({
    super.key,
    required this.controller,
    this.enable = true,
    this.readOnly = false,
    this.obscureText = false,
    this.defaultValidation = true,
    this.expandable = false,
    this.keyboardType,
    this.suffixIcon,
    this.hintText,
    this.validator,
    this.inputFormatters,
    this.prefix,
    this.contentPadding,
    this.prefixIcon,
    this.focusNode,
    this.onTap,
  });

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
  final VoidCallback? onTap;
  final bool expandable;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      focusNode: focusNode,
      readOnly: readOnly,
      obscureText: obscureText,
      enabled: enable,
      maxLines: expandable ? 5 : 1,
      minLines: expandable ? null : 1,
      style: TextStyles.paragraphSubTextRegular3.adaptiveColor(context),
      onTap: onTap,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: context.theme.primaryColor),
        ),
        hintText: hintText,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        prefix: prefix,
        contentPadding: contentPadding ?? EdgeInsets.symmetric(horizontal: 16),
        hintStyle: TextStyles.paragraphSubTextRegular3.grey,
        suffixIconColor: Colours.lightThemeSecondaryTextColor,
        filled: true,
        fillColor: CoreUtils.adaptiveColor(
          context,
          lightModeColor: Colours.lightTHemeStockColor,
          darkModeColor: Colours.darkThemeDarkSharpColor,
        ),
      ),
      inputFormatters: inputFormatters,
      validator: defaultValidation
          ? (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
              return validator?.call(value);
            }
          : validator,
    );
  }
}
