import 'package:flutter/material.dart';
import 'package:flutter_frontend/infrastructure/core/local/common_hive/common_hive.dart';
import 'package:flutter_frontend/l10n/app_strings.dart';
import 'package:flutter_frontend/presentation/core/styles/text_styles.dart';

import 'colors.dart';

class DarkTheme with ChangeNotifier{
  static bool _isDark=CommonHive.getDarkMode();

  ThemeMode currentTheme(){
    return _isDark ?ThemeMode.dark : ThemeMode.light;
  }

  void switchTheme(){
    _isDark =!_isDark;
    CommonHive.safeThemeMode(_isDark);
    notifyListeners();
  }
  ///------------------DARK THEME------------------------------
  ThemeData getDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      /// ----------------------------------------------------------------------COLOR SCHEME-------------------------------------------------------------------------------------------------
      colorScheme: const ColorScheme.dark(
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

        ///---------------------------------------------------------------------------TAB BAR THEME--------------------------------------------------------------------------------------------------
        tabBarTheme: TabBarTheme(
            unselectedLabelColor: AppColors.lightGrey,
            labelColor: AppColors.white,
            indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
                    width: 1,
                    color: AppColors.lightGrey)
            )
        ),
        ///-----------------------------------------------------------------------------SLIDER THEME------------------------------------------------------------------------------------------------
        sliderTheme: SliderThemeData(
          activeTickMarkColor: AppColors.lightGrey,
            thumbColor: AppColors.white,
            overlayColor: AppColors.primaryColor,
            activeTrackColor: AppColors.primaryColor,
            valueIndicatorTextStyle: _darkTextTheme.bodyText1
        ),

      /// ----------------------------------------------------------------------BottomNavigation-------------------------------------------------------------------------------------------------
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: AppColors.primaryColor,
          unselectedItemColor: AppColors.lightGrey),

      /// ----------------------------------------------------------------------IconThemeData-------------------------------------------------------------------------------------------------
      iconTheme: IconThemeData(color: AppColors.darkGrey),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.accentButtonColor,
        foregroundColor: AppColors.primaryColor
      ),
      /// ----------------------------------------------------------------------ElevatedButton-------------------------------------------------------------------------------------------------
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              primary: AppColors.accentColor,
              foregroundColor:  AppColors.accentButtonColor,
              backgroundColor: AppColors.darkGrey)),

      /// ----------------------------------------------------------------------OutlinedButton-------------------------------------------------------------------------------------------------
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
              primary: AppColors.accentColor,
              foregroundColor:  AppColors.accentButtonColor,
              backgroundColor: AppColors.darkGrey)),

      /// ----------------------------------------------------------------------ButtonTheme-------------------------------------------------------------------------------------------------
      buttonTheme: ButtonThemeData(
        textTheme: ButtonTextTheme.accent,
        disabledColor: AppColors.darkGrey,
        buttonColor: AppColors.accentButtonColor,
      ),

      inputDecorationTheme: InputDecorationTheme(


          errorStyle: TextStyle(fontSize: 11, color: AppColors.errorColor),
          helperStyle: TextStyle(fontSize: 10),
          focusColor: Colors.red,
          contentPadding: EdgeInsets.all(20),
          labelStyle: TextStyle(decorationColor: Colors.red)),

      /// ----------------------------------------------------------------------TextTheme-------------------------------------------------------------------------------------------------
      textTheme: _darkTextTheme,
    );
  }

  final TextTheme _darkTextTheme = TextTheme(
    bodyText1: AppTextStyles.basic,
    bodyText2: AppTextStyles.stdText,
    subtitle1: TextStyle(
      fontSize: 20.0,
      color: AppTextStyles.stdText.color,
    ),
    subtitle2: TextStyle(
      fontSize: 10.0,
      color: AppTextStyles.stdText.color,
    ),
    caption: TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.bold,
    ),
      headline1: TextStyle(
          height: 2,
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: AppTextStyles.stdText.color),
      headline5: TextStyle(height: 2,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppTextStyles.stdText.color)
  );

  ///------------------Light THEME------------------------------
  ThemeData getLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      /// ----------------------------------------------------------------------COLOR SCHEME-------------------------------------------------------------------------------------------------
      colorScheme: const ColorScheme.light(
        brightness: Brightness.light,
        primary: AppColors.primaryColor,
        onPrimary: AppColors.primaryColor,
        secondary: AppColors.accentColor,
        onSecondary: AppColors.accentColor,
        error: AppColors.lightErrorBackgroundColor,
        onError: AppColors.errorColor,
        background: AppColors.backGroundColor,
        onBackground: AppColors.lightGrey,
        surface: AppColors.lightGrey,
        onSurface: AppColors.lightGrey,
      ),

      appBarTheme: AppBarTheme(
          color: AppColors.lightGrey),

      ///---------------------------------------------------------------------------TAB BAR THEME--------------------------------------------------------------------------------------------------
      tabBarTheme: TabBarTheme(
        unselectedLabelColor: AppColors.lightGrey,
        labelColor: AppColors.black,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
              width: 1,
              color: AppColors.lightGrey)
        )
      ),
      ///-----------------------------------------------------------------------------SLIDER THEME------------------------------------------------------------------------------------------------
      sliderTheme: SliderThemeData(
        thumbColor: AppColors.accentButtonColor,
        overlayColor: AppColors.white,
        activeTrackColor: AppColors.accentButtonColor,
        valueIndicatorTextStyle: _darkTextTheme.bodyText1
      ),

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
        //textTheme: ButtonTextTheme.accent,
        disabledColor: AppColors.lightGrey,
        buttonColor: AppColors.accentButtonColor,
      ),

      inputDecorationTheme: InputDecorationTheme(
          focusColor: Colors.red,
          contentPadding: EdgeInsets.all(20),
          labelStyle: TextStyle(decorationColor: Colors.red)),

      /// ----------------------------------------------------------------------TextTheme-------------------------------------------------------------------------------------------------
      textTheme: _lightTextTheme,
    );
  }
  final TextTheme _lightTextTheme = TextTheme(
    bodyText1: AppTextStyles.basicDark,
    bodyText2: AppTextStyles.stdTextDark,
    subtitle1: TextStyle(
        fontSize: 10.0,
      color: AppTextStyles.basicDark.color,
    ),
    caption: TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.bold,
    ),
    headline1: TextStyle(
        height: 2,
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: AppTextStyles.basicDark.color),
    headline5: TextStyle(height: 2,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppTextStyles.basicDark.color)
  );
}


