import 'package:cabme/constant/show_toast_dialog.dart';
import 'package:cabme/controller/guest_controller.dart';
import 'package:cabme/page/dash_board.dart';
import 'package:cabme/themes/button_them.dart';
import 'package:cabme/themes/constant_colors.dart';
import 'package:cabme/themes/text_field_them.dart';
import 'package:cabme/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class GuestInfoScreen extends StatelessWidget {
  const GuestInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    bool isDarkMode = themeChange.getThem();

    return GetBuilder<GuestController>(
      init: Get.find<GuestController>(tag: 'guest'),
      builder: (controller) => Scaffold(
          backgroundColor: AppThemeData.primary200,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    color: AppThemeData.primary200,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            Text(
                              "Continue as Guest".tr,
                              style: TextStyle(
                                fontSize: 24,
                                fontFamily: AppThemeData.semiBold,
                                color: isDarkMode
                                    ? AppThemeData.grey50
                                    : AppThemeData.grey50Dark,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Please provide your personal information to continue"
                                  .tr,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: AppThemeData.regular,
                                color: isDarkMode
                                    ? AppThemeData.grey50
                                    : AppThemeData.grey50Dark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      color: themeChange.getThem()
                          ? AppThemeData.surface50Dark
                          : AppThemeData.surface50,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFieldWidget(
                              prefix: IconButton(
                                onPressed: () {},
                                icon: SvgPicture.asset(
                                  "assets/icons/ic_user.svg",
                                  colorFilter: ColorFilter.mode(
                                    themeChange.getThem()
                                        ? AppThemeData.grey500Dark
                                        : AppThemeData.grey300Dark,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                              controller: controller.fullNameController,
                              // labelText: "Full Name".tr,
                              hintText: "Enter full name".tr,
                            ),
                            TextFieldWidget(
                              prefix: IconButton(
                                onPressed: () {},
                                icon: SvgPicture.asset(
                                  "assets/icons/ic_phone_line.svg",
                                  colorFilter: ColorFilter.mode(
                                    themeChange.getThem()
                                        ? AppThemeData.grey500Dark
                                        : AppThemeData.grey300Dark,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                              controller: controller.phoneController,
                              // labelText: "Phone Number".tr,
                              hintText: "Enter phone number".tr,
                              textInputType: TextInputType.phone,
                            ),
                            TextFieldWidget(
                              prefix: IconButton(
                                onPressed: () {},
                                icon: SvgPicture.asset(
                                  "assets/icons/ic_email.svg",
                                  colorFilter: ColorFilter.mode(
                                    themeChange.getThem()
                                        ? AppThemeData.grey500Dark
                                        : AppThemeData.grey300Dark,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                              controller: controller.emailController,
                              // labelText: "Email (Optional)".tr,
                              hintText: "Enter email address".tr,
                              textInputType: TextInputType.emailAddress,
                            ),
                            TextFieldWidget(
                              prefix: IconButton(
                                onPressed: () {},
                                icon: SvgPicture.asset(
                                  "assets/icons/ic_card.svg",
                                  colorFilter: ColorFilter.mode(
                                    themeChange.getThem()
                                        ? AppThemeData.grey500Dark
                                        : AppThemeData.grey300Dark,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                              controller: controller.idNumberController,
                              // labelText: "ID Number".tr,
                              hintText: "Enter ID number".tr,
                            ),
                            TextFieldWidget(
                              prefix: IconButton(
                                onPressed: () {},
                                icon: SvgPicture.asset(
                                  "assets/icons/ic_location.svg",
                                  colorFilter: ColorFilter.mode(
                                    themeChange.getThem()
                                        ? AppThemeData.grey500Dark
                                        : AppThemeData.grey300Dark,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                              controller: controller.addressController,
                              // labelText: "Address".tr,
                              hintText: "Enter address".tr,
                            ),
                            const SizedBox(height: 24),
                            ButtonThem.buildButton(
                              context,
                              title: "Continue".tr,
                              onPress: () async {
                                if (controller.validateGuestInfo()) {
                                  controller.setGuestMode(true);
                                  await controller.saveGuestInfo();

                                  Map<String, String> bodyParams = {
                                    "firstname": controller.fullNameController.value.text.trim(),
                                    "lastname": "Guest",
                                    "phone": controller.phoneController.value.text.trim(),
                                    "email": controller.emailController.value.text.trim(),
                                    "password": "123456",
                                    "login_type": "email",
                                    "tonotify": "1",
                                    "account_type": "customer",
                                    "referral_code": "",
                                    "cnib": controller.idNumberController.value.text.trim(),
                                    "address": controller.addressController.value.text.trim(),
                                  };
                                  final user =
                                  await controller.signUp(bodyParams);

                                  if (user != null) {
                                    Get.offAll(() => DashBoard());
                                  }
                                } else {
                                  ShowToastDialog.showToast(
                                      "Please fill in all required fields correctly"
                                          .tr);
                                }
                              },
                            ),
                            const SizedBox(height: 16),
                            Center(
                              child: TextButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: Text(
                                  "Back to Login".tr,
                                  style: TextStyle(
                                    color: AppThemeData.primary200,
                                    fontFamily: AppThemeData.medium,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}
