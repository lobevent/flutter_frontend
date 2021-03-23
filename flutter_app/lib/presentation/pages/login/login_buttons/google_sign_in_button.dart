import 'package:flutter/material.dart';
import 'package:flutter_frontend/constants.dart';

import 'package:flutter_frontend/l10n/app_strings.dart';
import 'package:flutter_frontend/presentation/pages/login/login_buttons/base_login_button.dart';

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;

  /// shape is to specify the custom shape of the widget.
  /// However the flutter widgets contains restriction or bug
  /// on material button, hence, comment out.
  final ShapeBorder? shape;

  const GoogleSignInButton({
    Key? key,
    required this.onPressed,
    this.shape,
  }) : super(key: key);

  /// The build funtion will be help user to build the signin button widget.
  @override
  Widget build(BuildContext context) {
    return BaseLoginButton(
      text: AppStrings.signInWithGoogle, 
      onPressed: onPressed,
      image: const Image(
        image: AssetImage(Constants.googleLogoPath),
      ),
    );
  }
}