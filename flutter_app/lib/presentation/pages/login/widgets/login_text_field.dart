import 'package:flutter/material.dart';

import 'package:flutter_frontend/l10n/app_strings.dart';

import 'package:flutter_frontend/presentation/core/style.dart';
import 'package:flutter_frontend/presentation/pages/login/widgets/country_code_selection_button.dart';


class LoginTextField extends StatelessWidget {
  final String hintText;
  final ValueChanged<String> onChanged;

  final UnderlineInputBorder underlineInputBorder = const UnderlineInputBorder(
    borderSide: BorderSide(
      color: AppColors.white
    ),
  );

  const LoginTextField({required this.hintText, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        prefixIcon: CountryCodeSelectionButton(),
        hintText: hintText,
        hintStyle: AppTextStyles.loginTextField,
        contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
        disabledBorder: underlineInputBorder,
        enabledBorder: underlineInputBorder,
        focusedBorder: underlineInputBorder,
        errorBorder: underlineInputBorder,
        focusedErrorBorder: underlineInputBorder,
      ),
      style: AppTextStyles.loginTextField,
      keyboardType: TextInputType.number,
      onChanged: onChanged,
    );
  }
}


