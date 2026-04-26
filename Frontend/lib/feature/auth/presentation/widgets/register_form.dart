import 'package:angkor_store/core/common/widgets/input_field.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:gap/gap.dart';

import '../../../../core/common/widgets/rounded_button.dart';
import '../../../../core/common/widgets/vertical_label_field.dart';
import '../../../../core/extensions/widget_extention.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final userNameController = TextEditingController();
  final phoneController = TextEditingController();
  final countryController = TextEditingController();
  final obscurePasswordNotifier = ValueNotifier(true);
  final obscureConfirmPasswordNotifier = ValueNotifier(true);
  final countryNotifier = ValueNotifier<Country?>(null);

  void pickCountry() {
    showCountryPicker(
      context: context,
      onSelect: (country) {
        if (country != countryNotifier.value) {
          countryNotifier.value = country;
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    countryNotifier.addListener(() {
      if (countryNotifier.value == null) {
        phoneController.clear();
        countryController.clear();
      } else {
        countryController.text = '+${countryNotifier.value!.phoneCode}';
      }
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    obscurePasswordNotifier.dispose();
    obscureConfirmPasswordNotifier.dispose();
    userNameController.dispose();
    phoneController.dispose();
    countryController.dispose();
    confirmPasswordController.dispose();
    countryNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          VerticalLabelField(
            label: 'Username',
            controller: userNameController,
            hintText: "Enter your username",
            keyboardType: TextInputType.name,
          ),
          Gap(20),
          VerticalLabelField(
            label: 'Email',
            controller: emailController,
            hintText: "Enter your email",
            keyboardType: TextInputType.emailAddress,
          ),
          Gap(20),
          ValueListenableBuilder(
            valueListenable: countryNotifier,
            builder: (_, country, _) {
              return VerticalLabelField(
                label: 'Phone',
                controller: phoneController,
                hintText: "Enter your phone number",
                keyboardType: TextInputType.phone,
                enable: country != null,
                validator: (value) {
                  if (countryController.text.isEmpty) {
                    return 'Please select a country';
                  }
                  if (!isPhoneValid(
                    value!,
                    defaultCountryCode: country?.countryCode,
                  )) {
                    return 'Invalid phone number';
                  } else {
                    return null;
                  }
                },
                inputFormatters: [
                  PhoneInputFormatter(defaultCountryCode: country?.countryCode),
                ],
                mainFieldFlex: 2,
                prefix: InputField(
                  defaultValidation: false,
                  controller: countryController,
                  readOnly: true,
                  contentPadding: EdgeInsets.only(left: 10),
                  suffixIcon: GestureDetector(
                    onTap: pickCountry,
                    child: const Icon(Icons.arrow_drop_down),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !isPhoneValid(
                          value,
                          defaultCountryCode: country?.countryCode,
                        )) {
                      return '';
                    }
                    return null;
                  },
                ),
              );
            },
          ),
          Gap(20),
          ValueListenableBuilder(
            valueListenable: obscurePasswordNotifier,
            builder: (_, password, _) {
              return VerticalLabelField(
                label: 'Password',
                controller: passwordController,
                hintText: "Enter your password",
                keyboardType: TextInputType.visiblePassword,
                obscureText: password,
                suffixIcon: GestureDetector(
                  onTap: () {
                    obscurePasswordNotifier.value =
                        !obscurePasswordNotifier.value;
                  },
                  child: Icon(
                    password
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                ),
              );
            },
          ),
          Gap(20),
          ValueListenableBuilder(
            valueListenable: obscureConfirmPasswordNotifier,
            builder: (_, confirmPassword, _) {
              return VerticalLabelField(
                label: 'ConfirmPassword',
                controller: confirmPasswordController,
                hintText: "Enter your confirm password",
                keyboardType: TextInputType.visiblePassword,
                obscureText: confirmPassword,
                validator: (value) {
                  if (value != passwordController.text.trim()) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
                suffixIcon: GestureDetector(
                  onTap: () {
                    obscureConfirmPasswordNotifier.value =
                        !obscureConfirmPasswordNotifier.value;
                  },
                  child: Icon(
                    confirmPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                ),
              );
            },
          ),

          const Gap(40),
          RoundedButton(
            text: 'Sign up',
            onPressed: () {
              if (!formKey.currentState!.validate()) ;
              //TODO : Navigate to home screen
            },
          ).loading(false),
        ],
      ),
    );
  }
}
