import 'dart:io';

import 'package:cabme/constant/show_toast_dialog.dart';
import 'package:cabme/controller/phone_number_controller.dart';
import 'package:cabme/page/auth_screens/login_screen.dart';
import 'package:cabme/themes/button_them.dart';
import 'package:cabme/themes/constant_colors.dart';
import 'package:cabme/utils/dark_theme_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';

class MobileNumberScreen extends StatelessWidget {
  final bool? isLogin;
  final PhoneNumberController controller = Get.put(PhoneNumberController());

  MobileNumberScreen({super.key, this.isLogin});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    bool isDarkMode = themeChange.getThem();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppThemeData.primary200,
      body: SafeArea(
        child: Stack(
          alignment: AlignmentDirectional.topStart,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          isLogin == true
                              ? "Log In with Mobile Number".tr
                              : "Sign Up with Mobile Number".tr,
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
                          isLogin == true
                              ? "Enter your mobile number to log in securely and get access to your CabME account."
                                  .tr
                              : "Register using your mobile number for a fast and simple CabME sign-up process."
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
                        const SizedBox(height: 60),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: Platform.isIOS ? 3 : 4,
                  child: Container(
                    color: isDarkMode
                        ? AppThemeData.surface50Dark
                        : AppThemeData.surface50,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Image.asset(
                          isDarkMode
                              ? 'assets/images/ic_bg_signup_dark.png'
                              : 'assets/images/ic_bg_signup_light.png',
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 130),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 15 , vertical: 15),
                            decoration: BoxDecoration(
                              color: themeChange.getThem()
                                  ? AppThemeData.surface50Dark
                                  : AppThemeData.surface50,
                              border: Border.all(
                                color: themeChange.getThem()
                                    ? AppThemeData.grey200Dark
                                    : AppThemeData.grey200,
                              ),
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.shade500 ,
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                      offset: Offset(1, 1)
                                  )
                                ]
                            ),
                            child: IntlPhoneField(
                              flagsButtonPadding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              textAlign: TextAlign.start,
                              initialValue: controller.phoneNumber.value.text,
                              onChanged: (phone) {
                                controller.phoneNumber.value.text =
                                    phone.completeNumber;
                              },
                              invalidNumberMessage: "number invalid".tr,
                              showDropdownIcon: false,
                              cursorColor: AppThemeData.primary200,
                              disableLengthCheck: true,
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                hintText: 'mobile number'.tr,
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  fontFamily: AppThemeData.regular,
                                  color: themeChange.getThem()
                                      ? AppThemeData.grey500Dark
                                      : AppThemeData.grey500,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                              dropdownTextStyle: TextStyle(
                                fontSize: 16,
                                fontFamily: AppThemeData.medium,
                                color: themeChange.getThem()
                                    ? AppThemeData.grey900Dark
                                    : AppThemeData.grey900,
                              ),
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: AppThemeData.medium,
                                color: themeChange.getThem()
                                    ? AppThemeData.grey900Dark
                                    : AppThemeData.grey900,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: ButtonThem.buildButton(
                              context,
                              title: 'Send OTP'.tr,
                              onPress: () async {
                                FocusScope.of(context).unfocus();
                                if (controller
                                    .phoneNumber.value.text.isNotEmpty) {
                                  ShowToastDialog.showLoader("Code sending");
                                  controller.sendCode();
                                }
                              },
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              child: Text(
                                "or continue with".tr,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: themeChange.getThem()
                                      ? AppThemeData.grey400Dark
                                      : AppThemeData.grey400,
                                  fontFamily: AppThemeData.regular,
                                ),
                              ),
                            ),
                          ),
                          ButtonThem.buildBorderButton(
                            btnColor: themeChange.getThem()
                                ? AppThemeData.grey300Dark
                                : AppThemeData.grey300,
                            txtColor: themeChange.getThem()
                                ? AppThemeData.grey900Dark
                                : AppThemeData.grey900,
                            context,
                            title: 'Log in with email address'.tr,
                            onPress: () {
                              FocusScope.of(context).unfocus();
                              Get.back();
                            },
                            btnBorderColor: themeChange.getThem()
                                ? AppThemeData.grey300Dark
                                : AppThemeData.grey300,
                          ),
                        ],
                      ),
                    ),
                  ),
                  isLogin == true
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Text.rich(
                            textAlign: TextAlign.center,
                            TextSpan(
                              text: 'First time in CabMe?'.tr,
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: AppThemeData.regular,
                                color: isDarkMode
                                    ? AppThemeData.grey800Dark
                                    : AppThemeData.grey800,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: ' '.tr,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: AppThemeData.medium,
                                    color: AppThemeData.primary200,
                                  ),
                                ),
                                TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => Get.offAll(
                                        MobileNumberScreen(
                                          isLogin: false,
                                        ),
                                        duration: const Duration(
                                            milliseconds:
                                                400), //duration of transitions, default 1 sec
                                        transition: Transition.rightToLeft),
                                  text: 'Create an account'.tr,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: AppThemeData.medium,
                                    color: AppThemeData.primary200,
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppThemeData.primary200,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Text.rich(
                            textAlign: TextAlign.center,
                            TextSpan(
                              text: 'Already book rides?'.tr,
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: AppThemeData.regular,
                                color: isDarkMode
                                    ? AppThemeData.grey800Dark
                                    : AppThemeData.grey800,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: ' '.tr,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: AppThemeData.medium,
                                    color: AppThemeData.primary200,
                                  ),
                                ),
                                TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => Get.offAll(LoginScreen(),
                                        duration: const Duration(
                                            milliseconds:
                                                400),
                                        transition: Transition
                                            .rightToLeft), //transition effect);,
                                  text: 'Login'.tr,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: AppThemeData.medium,
                                    color: AppThemeData.primary200,
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppThemeData.primary200,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
