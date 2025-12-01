import 'package:cabme/themes/constant_colors.dart';
import 'package:cabme/themes/responsive.dart';
import 'package:cabme/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ButtonThem {
  const ButtonThem({Key? key});

  static buildButton(
    BuildContext context, {
    required String title,
    Color? btnColor,
    Color? txtColor,
    double btnHeight = 50,
    double txtSize = 16,
    double btnWidthRatio = 1,
    double radius = 0,
    required Function() onPress,
    bool isVisible = true,
  }) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Visibility(
      visible: isVisible,
      child: SizedBox(
        width: Responsive.width(100, context) * btnWidthRatio,
        child: MaterialButton(
          onPressed: onPress,
          height: btnHeight,
          elevation: 0.5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          color: btnColor ?? AppThemeData.primary200,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: txtColor ??
                  (themeChange.getThem()
                      ? AppThemeData.grey50
                      : AppThemeData.grey50Dark),
              fontSize: txtSize,
              fontFamily: AppThemeData.medium,
            ),
          ),
        ),
      ),
    );
  }

  static buildBorderButton(
    BuildContext context, {
    required String title,
    Color? btnColor,
    Color? btnBorderColor,
    Color? txtColor,
    double btnHeight = 50,
    double txtSize = 16,
    double btnWidthRatio = 1,
    required Function() onPress,
    bool isVisible = true,
  }) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Visibility(
      visible: isVisible,
      child: SizedBox(
        width: Responsive.width(100, context) * btnWidthRatio,
        height: btnHeight,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(
              btnColor ??
                  (themeChange.getThem()
                      ? Colors.transparent
                      : AppThemeData.surface50),
            ),
            foregroundColor: WidgetStateProperty.all<Color>(
              btnColor ??
                  (themeChange.getThem()
                      ? Colors.transparent
                      : AppThemeData.surface50),
            ),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
                side: BorderSide(
                  color: btnBorderColor ?? AppThemeData.primary200,
                ),
              ),
            ),
          ),
          onPressed: onPress,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: txtColor ??
                  (themeChange.getThem()
                      ? AppThemeData.grey50
                      : AppThemeData.grey200Dark),
              fontSize: txtSize,
              fontFamily: AppThemeData.medium,
            ),
          ),
        ),
      ),
    );
  }

  static buildIconButton(
    BuildContext context, {
    required String title,
    Color? btnColor,
    Color? txtColor,
    required Color iconColor,
    required IconData icon,
    double btnHeight = 50,
    double txtSize = 16,
    double btnWidthRatio = 0.9,
    iconSize = 18.0,
    required Function() onPress,
    double radius = 0.0,
    bool isVisible = true,
  }) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Visibility(
      visible: isVisible,
      child: SizedBox(
        width: Responsive.width(100, context) * btnWidthRatio,
        height: btnHeight,
        child: TextButton.icon(
          style: TextButton.styleFrom(
            backgroundColor: btnColor ?? AppThemeData.primary200,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
          onPressed: onPress,
          label: Text(
            title,
            style: TextStyle(
              color: txtColor ??
                  (themeChange.getThem()
                      ? AppThemeData.grey50
                      : AppThemeData.grey50Dark),
              fontFamily: AppThemeData.medium,
              fontSize: txtSize,
            ),
          ),
          icon: Icon(
            icon,
            color: iconColor,
            size: iconSize,
          ),
        ),
      ),
    );
  }

  static buildIconButtonWidget(
    BuildContext context, {
    required String title,
    Color? btnColor,
    Color? txtColor,
    required Color iconColor,
    required Widget icon,
    double btnHeight = 50,
    double txtSize = 16,
    double btnWidthRatio = 0.9,
    iconSize = 18.0,
    required Function() onPress,
    double radius = 0.0,
    bool isVisible = true,
  }) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Visibility(
      visible: isVisible,
      child: SizedBox(
        width: Responsive.width(100, context) * btnWidthRatio,
        height: btnHeight,
        child: TextButton.icon(
          style: TextButton.styleFrom(
            backgroundColor: btnColor ?? AppThemeData.primary200,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
          onPressed: onPress,
          label: Text(
            title,
            style: TextStyle(
              color: txtColor ??
                  (themeChange.getThem()
                      ? AppThemeData.grey50
                      : AppThemeData.grey50Dark),
              fontFamily: AppThemeData.medium,
              fontSize: txtSize,
            ),
          ),
          icon: icon,
        ),
      ),
    );
  }
}
