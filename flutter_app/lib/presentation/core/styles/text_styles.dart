import 'package:flutter/material.dart';
import 'package:flutter_frontend/presentation/core/styles/colors.dart';

class AppTextStyles {
    static const basic = TextStyle(
    color: AppColors.black,
  );

  static const loginTitle = TextStyle(
    color: AppColors.white,
    fontWeight: FontWeight.bold,
    fontSize: 25.0,
  );

  static const TextStyle loginTextField = TextStyle(
    fontSize: 20.0,
    color: AppColors.white
  );
}