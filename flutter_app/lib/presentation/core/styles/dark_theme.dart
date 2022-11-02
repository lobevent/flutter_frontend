import 'package:flutter/material.dart';
import 'package:flutter_frontend/presentation/core/styles/text_styles.dart';

import 'colors.dart';

class DarkTheme {
  ThemeData getDarkTheme() {
    return ThemeData(
      /// ----------------------------------------------------------------------COLOR SCHEME-------------------------------------------------------------------------------------------------
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: AppColors.primaryColor,
        onPrimary: AppColors.primaryColor,
        secondary: AppColors.accentColor,
        onSecondary: AppColors.accentColor,
        error: AppColors.lightErrorBackgroundColor,
        onError: AppColors.errorColor,
        background: AppColors.backGroundColor,
        onBackground: AppColors.lightGrey,
        surface: AppColors.lightGrey,
        onSurface: AppColors.white,
      ),
      //appBarTheme: AppBarTheme(),

      /// ----------------------------------------------------------------------BottomNavigation-------------------------------------------------------------------------------------------------
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: AppColors.primaryColor,
          unselectedItemColor: AppColors.lightGrey),

      /// ----------------------------------------------------------------------IconThemeData-------------------------------------------------------------------------------------------------
      iconTheme: IconThemeData(color: AppColors.lightGrey),

      /// ----------------------------------------------------------------------ElevatedButton-------------------------------------------------------------------------------------------------
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              primary: AppColors.accentColor,
              backgroundColor: AppColors.lightGrey)),

      /// ----------------------------------------------------------------------OutlinedButton-------------------------------------------------------------------------------------------------
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
              primary: AppColors.accentColor,
              backgroundColor: AppColors.lightGrey)),

      /// ----------------------------------------------------------------------ButtonTheme-------------------------------------------------------------------------------------------------
      buttonTheme: ButtonThemeData(
        textTheme: ButtonTextTheme.accent,
        disabledColor: AppColors.lightGrey,
        buttonColor: AppColors.accentButtonColor,
      ),

      inputDecorationTheme: InputDecorationTheme(
          focusColor: Colors.red,
          contentPadding: EdgeInsets.all(20),
          labelStyle: TextStyle(decorationColor: Colors.red)),

      /// ----------------------------------------------------------------------TextTheme-------------------------------------------------------------------------------------------------
      textTheme: _textTheme,
    );
  }

  final TextTheme _textTheme = TextTheme(
    bodyText1: AppTextStyles.basic,
    bodyText2: AppTextStyles.stdText,
    caption: TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.bold,
    ),
  );
}
