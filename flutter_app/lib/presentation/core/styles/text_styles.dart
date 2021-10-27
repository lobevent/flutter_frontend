import 'package:flutter/material.dart';
import 'package:flutter_frontend/presentation/core/styles/colors.dart';
import 'package:flutter_frontend/presentation/core/styles/sizes.dart';

class AppTextStyles {
  static const basic = TextStyle(
    color: AppColors.black,
  );

  static const loginText = TextStyle(
    color: AppColors.white,
    fontWeight: FontWeight.bold,
    fontSize: 25.0,
  );

  static const TextStyle loginTextField =
      TextStyle(fontSize: 20.0, color: AppColors.black);

  static const TextStyle stdSubTextStyle = TextStyle(
    color: AppColors.stdTextColor,
    fontSize: AppSizes.metaSubText,
  );
}
