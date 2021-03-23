import 'package:flutter/material.dart';
import 'package:flutter_frontend/constants.dart';

import 'package:flutter_frontend/l10n/app_strings.dart';

class BaseLoginButton extends StatelessWidget {
  final String text;

  /// set an icon as front logo
  final IconData? icon;

  /// set an image as front logo
  final Widget? image;

  final double fontSize;

  /// backgroundColor is required but textColor is default to `Colors.white`
  /// splashColor is defalt to `Colors.white30`
  final Color textColor;
  final Color iconColor;
  final Color backgroundColor;
  final Color splashColor;
  final Color highlightColor;

  /// onPressed should be specified as a required field to indicate the callback.
  final Function onPressed;

  /// elevation has default value of 2.0
  final double elevation;

  /// the height of the button
  final double height;

  /// width is default to be 1/1.5 of the screen
  final double width;

  /// shape is to specify the custom shape of the widget.
  /// However the flutter widgets contains restriction or bug
  /// on material button, hence, comment out.
  final ShapeBorder? shape;

  const BaseLoginButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.image,
    this.backgroundColor = Colors.white,
    this.textColor = const Color.fromRGBO(0, 0, 0, 0.54),
    this.iconColor = Colors.white,
    this.splashColor = Colors.white30,
    this.highlightColor = Colors.white30,
    this.elevation = 2.0,
    this.height = 36.0,
    this.width = 220,
    this.fontSize = 14.0,
    this.shape,
  }) : assert(icon != null || image != null, "At least an icon or an image must be provided!"),
       super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: height,
      elevation: elevation,
      padding: const EdgeInsets.all(0),
      color: backgroundColor,
      onPressed: onPressed as VoidCallback?,
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
            _iconOrImage(),
            Text(
              text,
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

  Widget _iconOrImage() {
    if (icon != null) {
      return Icon(
        icon,
        size: 20,
        color: iconColor,
      );
    } else {
      return Container(
        padding: const EdgeInsets.only(left: 10.0),
        child: image
      );
    }
  }
}