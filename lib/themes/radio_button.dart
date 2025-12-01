import 'package:cabme/themes/constant_colors.dart';
import 'package:cabme/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class RadioButtonCustom extends StatelessWidget {
  final String name;
  final String? subName;
  final String groupValue;
  final bool isSelected;
  final Function(String?) onClick;
  final bool isEnabled;
  final String image;

  const RadioButtonCustom({
    super.key,
    required this.image,
    required this.name,
    this.subName,
    required this.groupValue,
    required this.isSelected,
    required this.onClick,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Visibility(
      visible: isEnabled,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: isSelected ? AppThemeData.secondary50 : Colors.transparent,
              borderRadius: BorderRadius.circular(0),
            ),
            child: RadioListTile(
              activeColor: AppThemeData.primary200,
              tileColor: Colors.transparent,
              controlAffinity: ListTileControlAffinity.trailing,
              value: name,
              groupValue: groupValue,
              onChanged: onClick,
              selected: isSelected,
              contentPadding: const EdgeInsets.symmetric(horizontal: 6),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: Image.asset(
                        image,
                        width: 25,
                        height: 25,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name.tr,
                        style: TextStyle(
                          color: isSelected
                              ? AppThemeData.grey900
                              : themeChange.getThem()
                                  ? AppThemeData.grey900Dark
                                  : AppThemeData.grey900,
                          fontSize: 16,
                          fontFamily: AppThemeData.medium,
                        ),
                      ),
                      Visibility(
                        visible: subName != null,
                        child: Text(
                          subName?.tr ?? '',
                          style: TextStyle(
                            color: AppThemeData.secondary200,
                            fontSize: 12,
                            fontFamily: AppThemeData.semiBold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: themeChange.getThem() ? AppThemeData.grey300Dark : AppThemeData.grey300,
            height: 1,
          ),
        ],
      ),
    );
  }
}
