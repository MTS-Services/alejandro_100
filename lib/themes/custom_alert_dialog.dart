// ignore_for_file: library_private_types_in_public_api

import 'package:cabme/themes/button_them.dart';
import 'package:cabme/themes/constant_colors.dart';
import 'package:cabme/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CustomAlertDialog extends StatefulWidget {
  final String title;
  final Function() onPressPositive;
  final Function() onPressNegative;

  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.onPressPositive,
    required this.onPressNegative,
  });

  @override
  _CustomAlertDialogState createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: themeChange.getThem() ? AppThemeData.surface50Dark : AppThemeData.surface50,
              borderRadius: BorderRadius.circular(0),
              boxShadow: const [
                BoxShadow(color: Colors.black, offset: Offset(0, 5), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: AppThemeData.semiBold,
                  color: themeChange.getThem() ? AppThemeData.grey900Dark : AppThemeData.grey900,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Expanded(
                    child: ButtonThem.buildButton(
                      context,
                      title: 'Yes'.tr,
                      btnWidthRatio: 0.8,
                      onPress: widget.onPressPositive,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: ButtonThem.buildBorderButton(
                      context,
                      title: 'No'.tr,
                      btnWidthRatio: 0.8,
                      btnColor: themeChange.getThem() ? AppThemeData.surface50Dark : AppThemeData.surface50,
                      txtColor: AppThemeData.primary200,
                      btnBorderColor: AppThemeData.primary200,
                      onPress: widget.onPressNegative,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
