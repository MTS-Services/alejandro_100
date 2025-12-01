// ignore_for_file: library_private_types_in_public_api

import 'package:cabme/themes/button_them.dart';
import 'package:cabme/themes/constant_colors.dart';
import 'package:cabme/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CustomDialogBox extends StatefulWidget {
  final String title, descriptions;
  final Image img;
  final Function() onPress;

  const CustomDialogBox({super.key, required this.title, required this.descriptions, required this.img, required this.onPress});

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: themeChange.getThem() ? AppThemeData.surface50Dark : AppThemeData.surface50,
      child: contentBox(context, themeChange.getThem()),
    );
  }

  contentBox(context, isDarkMode) {
    return Container(
      padding: const EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: isDarkMode ? AppThemeData.surface50Dark : AppThemeData.surface50,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
          ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 45,
            child: ClipRRect(borderRadius: const BorderRadius.all(Radius.circular(45)), child: widget.img),
          ),
          Visibility(
            visible: widget.title.isNotEmpty,
            child: Text(
              widget.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Visibility(
            visible: widget.descriptions.isNotEmpty,
            child: Text(
              widget.descriptions,
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ButtonThem.buildButton(
            context,
            title: 'Close'.tr,
            btnWidthRatio: 0.8,
            btnColor: AppThemeData.primary200,
            txtColor: Colors.white,
            onPress: widget.onPress,
          ),
        ],
      ),
    );
  }
}
