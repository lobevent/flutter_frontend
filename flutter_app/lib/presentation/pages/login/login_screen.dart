import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'package:flutter_frontend/presentation/pages/login/login_buttons/google_sign_in_button.dart';
import 'package:flutter_frontend/presentation/pages/login/login_buttons/phone_number_sign_in_button.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/auth/sign_in_form/sign_in_form_cubit.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather Search"),
      ),
      body: ListView(
        children: [
          SignInWithAppleButton(
            onPressed: onAppleSignInPressed,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
          ),
          GoogleSignInButton(
            onPressed: onGoogleSignInPressed,
          ),
          PhoneNumberSignInButton(
            onPressed: onPhoneSignInPressed,
          )
        ],
      ),
    );
  }

  void onAppleSignInPressed() {

  }

  void onGoogleSignInPressed() {

  }

  void onPhoneSignInPressed() {

  }
}
