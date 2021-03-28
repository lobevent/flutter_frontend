import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'package:flutter_frontend/presentation/pages/login/widgets/login_buttons/google_sign_in_button.dart';
import 'package:flutter_frontend/presentation/pages/login/widgets/login_buttons/phone_number_sign_in_button.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/auth/sign_in_form/sign_in_form_cubit.dart';

class LoginScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.6),
      appBar: AppBar(
        title: Text("Weather Seaerch"),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        children: [
          SignInWithAppleButton(
            onPressed: () => onAppleSignInPressed(context),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
          ),
          GoogleSignInButton(
            onPressed: () => onGoogleSignInPressed(context),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
          ),
          PhoneNumberSignInButton(
            onPressed: () => onPhoneSignInPressed(context),
          )
        ],
      ),
    );
  }

  void onAppleSignInPressed(BuildContext context) {
    context.read<SignInFormCubit>().startAppleSignIn();
  }

  void onGoogleSignInPressed(BuildContext context) {
    context.read<SignInFormCubit>().startGoogleSignIn();
  }

  void onPhoneSignInPressed(BuildContext context) {
    context.router.push(const PhoneNumberSignInScreenRoute());
  }
}


