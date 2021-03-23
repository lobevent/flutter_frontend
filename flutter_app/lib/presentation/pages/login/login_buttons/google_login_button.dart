import 'package:flutter/material.dart';
import 'package:flutter_frontend/constants.dart';

import 'package:flutter_frontend/l10n/app_strings.dart';

class GoogleLoginButton extends StatelessWidget {
  final double fontSize;

  /// backgroundColor is required but textColor is default to `Colors.white`
  /// splashColor is defalt to `Colors.white30`
  final Color textColor,
      iconColor,
      backgroundColor,
      splashColor,
      highlightColor;

  /// onPressed should be specified as a required field to indicate the callback.
  final Function onPressed;

  /// elevation has defalt value of 2.0
  final double elevation;

  /// the height of the button
  final double height;

  /// width is default to be 1/1.5 of the screen
  final double width;

  /// shape is to specify the custom shape of the widget.
  /// However the flutter widgets contains restriction or bug
  /// on material button, hence, comment out.
  final ShapeBorder? shape;

  const GoogleLoginButton({
    Key? key,
    required this.onPressed,
    this.backgroundColor = Colors.white,
    this.textColor = const Color.fromRGBO(0, 0, 0, 0.54),
    this.iconColor = Colors.white,
    this.splashColor = Colors.white30,
    this.highlightColor = Colors.white30,
    this.elevation = 2.0,
    this.height = 36.0,
    this.width = 220,
    this.shape,
    this.fontSize = 14.0,
  }) : super(key: key);

  /// The build funtion will be help user to build the signin button widget.
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: height,
      elevation: elevation,
      padding: const EdgeInsets.all(0),
      color: backgroundColor,
      onPressed: onPressed as void Function()?,
      splashColor: splashColor,
      highlightColor: highlightColor,
      shape: shape ?? ButtonTheme.of(context).shape,
      child: _getButtonChild(context),
    );
  }

  /// Get the inner content of a button
  Container _getButtonChild(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: width,
      ),
      child: Center(
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: const Image(
                image: AssetImage(Constants.googleLogoPath),
              ),
            ),
            Text(
              signInWithGoogle,
              style: TextStyle(
                color: textColor,
                fontSize: fontSize,
                backgroundColor: Color.fromRGBO(0, 0, 0, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}