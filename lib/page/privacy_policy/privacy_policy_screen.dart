import 'package:cabme/controller/privacy_policy_controller.dart';
import 'package:cabme/themes/appbar_cust.dart';
import 'package:cabme/themes/constant_colors.dart';
import 'package:cabme/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<PrivacyPolicyController>(
        init: PrivacyPolicyController(),
        builder: (controller) {
          return Scaffold(
            appBar: CustomAppbar(
              textColor: themeChange.getThem() ? AppThemeData.grey900Dark : AppThemeData.grey900,
              title: 'Privacy & Policy'.tr,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: controller.privacyData.value.isNotEmpty
                    ? Html(
                        data: controller.privacyData.value,
                      )
                    : const Offstage(),
              ),
            ),
          );
        });
  }
}
