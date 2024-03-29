import 'package:flutter/material.dart';
import 'package:flutter_frontend/presentation/core/styles/colors.dart';
import 'package:flutter_frontend/presentation/core/styles/sizes.dart';

class AppTextStyles {
  static const basic = TextStyle(
    color: AppColors.stdTextColor,
  );
  static const basicDark = TextStyle(
    color: AppColors.black,
  );

  static const error = TextStyle(
    color: AppColors.errorColor,
  );

  static const stdText = TextStyle(
    color: AppColors.stdTextColor,
    fontWeight: FontWeight.bold
  );

  static const stdTextDark = TextStyle(
      color: AppColors.textOnAccentColor,
      fontWeight: FontWeight.bold
  );

  static const stdSelectedText = TextStyle(
    color: AppColors.selectedColor,
    fontWeight: FontWeight.bold
  );


  static const loginText = TextStyle(
    color: AppColors.stdTextColor,
    fontWeight: FontWeight.bold,
    fontSize: 25.0,
  );

  static const TextStyle loginTextField =
      TextStyle(fontSize: 20.0, color: AppColors.stdTextColor);

  static const TextStyle stdSubTextStyle = TextStyle(
    color: AppColors.stdTextColor,
    fontSize: AppSizes.metaSubText,
  );

  static const TextStyle stdLittleHeading = TextStyle(
      height: 2,
      fontSize: 30,
      fontWeight: FontWeight.bold,
      color: AppColors.stdTextColor);
}
