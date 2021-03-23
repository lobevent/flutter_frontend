import 'package:flutter/material.dart';

import 'package:sign_in_with_apple/sign_in_with_apple.dart';
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

        ],
      ),
    );
  }

  void onAppleSignInPressed() {

  }

  void onGoogleSignInPressed() {
    
  }
}
