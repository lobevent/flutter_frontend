import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/auth/sign_in_form/sign_in_form_cubit.dart';

import 'package:flutter_frontend/l10n/app_strings.dart';
import 'package:flutter_frontend/presentation/core/style.dart';
import 'package:flutter_frontend/presentation/pages/login/widgets/phone_number_text_field.dart';

class PhoneNumberSignInScreen extends StatefulWidget {

  @override
  _PhoneNumberSignInScreenState createState() => _PhoneNumberSignInScreenState();
}

class _PhoneNumberSignInScreenState extends State<PhoneNumberSignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    child: PhoneNumberTextField(),
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
  }
}
