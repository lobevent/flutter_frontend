import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_frontend/l10n/app_strings.dart';
import 'package:flutter_frontend/presentation/core/style.dart';
import 'package:flutter_frontend/application/auth/sign_in_form/sign_in_form_cubit.dart';
import 'package:flutter_frontend/presentation/pages/login/widgets/country_code_selection_button.dart';
import 'package:flutter_frontend/presentation/pages/login/widgets/login_text_field.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';

class PhoneNumberSignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.6),
      appBar: AppBar(
        title: Text("Weather Seaerch"),
      ),
      body: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          ),

          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(top: 75.0),
                    child: const Text(
                      AppStrings.phoneNumberVerificationTitle,
                      style: AppTextStyles.loginText
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: LoginTextField(
                      hintText: AppStrings.phoneNumberTextFieldHint,
                      prefixIcon: CountryCodeSelectionButton(),
                      onChanged: (phoneNumber) => _onPhoneNumberChanged(context, phoneNumber),
                    ),
                  ),

                  Expanded(
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: AppColors.lightGrey,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                        ),
                        onPressed: () => _startPhoneVerification(context),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(
                            AppStrings.sendPhoneNumberVerification,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.loginText
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _startPhoneVerification(BuildContext context) {
    context.read<SignInFormCubit>().startPhoneNumberSignIn();
    context.router.push(const PhoneNumberVerificationCodeScreenRoute());
  }

  void _onPhoneNumberChanged(BuildContext context, String phoneNumber) {
    context.read<SignInFormCubit>().phoneNumberChanged(phoneNumber);
  }
}
