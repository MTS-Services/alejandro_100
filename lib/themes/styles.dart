import 'package:cabme/themes/constant_colors.dart';
import 'package:flutter/material.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      scaffoldBackgroundColor: isDarkTheme ? AppThemeData.surface50Dark : AppThemeData.surface50,
      primaryColor: isDarkTheme ? AppThemeData.grey900Dark : AppThemeData.grey900,
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      timePickerTheme: TimePickerThemeData(
        backgroundColor: isDarkTheme ? AppThemeData.surface50Dark : AppThemeData.surface50,
        dialTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: isDarkTheme ? AppThemeData.grey900Dark : AppThemeData.grey900,
        ),
        dialTextColor: isDarkTheme ? AppThemeData.grey900Dark : AppThemeData.grey900,
        hourMinuteTextColor: isDarkTheme ? AppThemeData.grey900Dark : AppThemeData.grey900,
        dayPeriodTextColor: isDarkTheme ? AppThemeData.grey900Dark : AppThemeData.grey900,
      ),
    );
  }
}
