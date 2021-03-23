import 'package:flutter/material.dart';
import 'package:flutter_frontend/l10n/app_strings.dart';
import 'package:flutter_frontend/presentation/pages/login/login_buttons/base_login_button.dart';

class PhoneNumberSignInButton extends StatelessWidget {
  final VoidCallback onPressed;

  /// shape is to specify the custom shape of the widget.
  /// However the flutter widgets contains restriction or bug
  /// on material button, hence, comment out.
  final ShapeBorder? shape;

  const PhoneNumberSignInButton({
    required this.onPressed,
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    return BaseLoginButton(
      text: AppStrings.signInWithPhone, 
      onPressed: onPressed,
      icon: Icons.phone,
    );
  }
}