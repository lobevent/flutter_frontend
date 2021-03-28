import 'package:flutter/material.dart';

import 'package:flutter_frontend/l10n/app_strings.dart';

import 'package:flutter_frontend/presentation/core/style.dart';
import 'package:flutter_frontend/presentation/pages/login/widgets/country_code_selection_button.dart';


class PhoneNumberTextField extends StatelessWidget {

  final UnderlineInputBorder underlineInputBorder = const UnderlineInputBorder(
    borderSide: BorderSide(
      color: AppColors.white
    ),
  );


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        prefixIcon: CountryCodeSelectionButton(),
        hintText: AppStrings.phoneNumberTextFieldHint,
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
    );
  }
}


