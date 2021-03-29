import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_frontend/application/auth/sign_in_form/sign_in_form_cubit.dart';
import 'package:flutter_frontend/l10n/app_strings.dart';
import 'package:flutter_frontend/presentation/core/style.dart';
import 'package:flutter_frontend/presentation/pages/login/widgets/login_text_field.dart';

class PhoneNumberVerificationCodeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather Seaerch"),
      ),
      body: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: <Widget>[
          GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          ),

          LoginTextField(
            hintText: AppStrings.verificationCodeTextFieldHint, 
            onChanged: (verificationCode) => _onVerificationCodeChanged(context, verificationCode),
          ),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
            ),
            onPressed: () => _verifySmsCode(context),
            child: Text(
              AppStrings.verificationCodeButton,
              style: AppTextStyles.loginText,
            ),
          )
        ],
      ),
    );
  }

  void _handleBackPress(BuildContext context) {
    // TODO implement
  }

  void _onVerificationCodeChanged(BuildContext context, String verificationCode) {
    context.read<SignInFormCubit>().verificationCodeChanged(verificationCode);
  }

  void _verifySmsCode(BuildContext context) {
    context.read<SignInFormCubit>().verifyPhoneCode();
  }

  void _resendSmsCode(BuildContext context) {
    // TODO implement
  }


}
