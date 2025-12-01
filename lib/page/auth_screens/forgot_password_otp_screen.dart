// ignore_for_file: must_be_immutable

import 'package:cabme/constant/show_toast_dialog.dart';
import 'package:cabme/controller/forgot_password_controller.dart';
import 'package:cabme/page/auth_screens/login_screen.dart';
import 'package:cabme/themes/button_them.dart';
import 'package:cabme/themes/text_field_them.dart';
import 'package:cabme/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import '../../themes/constant_colors.dart';

class ForgotPasswordOtpScreen extends StatelessWidget {
  final String? email;
  ForgotPasswordOtpScreen({super.key, required this.email});

  final controller = Get.put(ForgotPasswordController());
  static final _formKey = GlobalKey<FormState>();

  final textEditingController = TextEditingController();
  final _passwordController = TextEditingController();
  final _conformPasswordController = TextEditingController();

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
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    color: AppThemeData.primary200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              Text(
                                "Reset Your Password".tr,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: AppThemeData.semiBold,
                                  color: isDarkMode ? AppThemeData.grey50 : AppThemeData.grey50Dark,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Enter the one-time password sent to your mobile number to verify your account, then set a new password.".tr,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: AppThemeData.regular,
                                  color: isDarkMode ? AppThemeData.grey50 : AppThemeData.grey50Dark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Container(
                    color: isDarkMode ? AppThemeData.surface50Dark : AppThemeData.surface50,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Image.asset(
                          isDarkMode ? 'assets/images/ic_bg_signup_dark.png' : 'assets/images/ic_bg_signup_light.png',
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 150),
                    Pinput(
                      scrollPadding: EdgeInsets.zero,
                      controller: textEditingController,
                      defaultPinTheme: PinTheme(
                        margin: EdgeInsets.zero,
                        padding: EdgeInsets.zero,
                        height: 50,
                        width: 55,
                        textStyle: TextStyle(
                            letterSpacing: 0.60, fontSize: 16, color: themeChange.getThem() ? AppThemeData.grey900Dark : AppThemeData.grey900, fontWeight: FontWeight.w600),
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: themeChange.getThem() ? AppThemeData.surface50Dark : AppThemeData.surface50,
                          border: Border.all(color: themeChange.getThem() ? AppThemeData.grey200Dark : AppThemeData.grey200, width: 0.8),
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                      length: 4,
                    ),
                    const SizedBox(height: 40),
                    TextFieldWidget(
                      prefix: IconButton(
                        onPressed: () {},
                        icon: SvgPicture.asset(
                          'assets/icons/ic_lock.svg',
                          colorFilter: ColorFilter.mode(
                            themeChange.getThem() ? AppThemeData.grey500Dark : AppThemeData.grey300Dark,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      hintText: 'password'.tr,
                      controller: _passwordController,
                      textInputType: TextInputType.text,
                      obscureText: false,
                      validators: (String? value) {
                        if (value!.length >= 6) {
                          return null;
                        } else {
                          return 'Password required at least 6 characters'.tr;
                        }
                      },
                    ),
                    TextFieldWidget(
                      prefix: IconButton(
                        onPressed: () {},
                        icon: SvgPicture.asset(
                          'assets/icons/ic_lock.svg',
                          colorFilter: ColorFilter.mode(
                            themeChange.getThem() ? AppThemeData.grey500Dark : AppThemeData.grey300Dark,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      hintText: 'Confirm Password'.tr,
                      controller: _conformPasswordController,
                      textInputType: TextInputType.text,
                      obscureText: false,
                      validators: (String? value) {
                        if (_passwordController.text != value) {
                          return 'Confirm password is invalid'.tr;
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: ButtonThem.buildButton(
                          context,
                          title: 'Done'.tr,
                          onPress: () async {
                            FocusScope.of(context).unfocus();
                            if (_formKey.currentState!.validate()) {
                              Map<String, String> bodyParams = {
                                'email': email.toString(),
                                'otp': textEditingController.text.trim(),
                                'new_password': _passwordController.text.trim(),
                                'confirm_password': _passwordController.text.trim(),
                                'user_cat': "user_app",
                              };
                              controller.resetPassword(bodyParams).then((value) {
                                if (value != null) {
                                  if (value == true) {
                                    Get.offAll(LoginScreen(),
                                        duration: const Duration(milliseconds: 400), //duration of transitions, default 1 sec
                                        transition: Transition.rightToLeft);
                                    ShowToastDialog.showToast("Password change successfully!");
                                  } else {
                                    ShowToastDialog.showToast("Please try again later");
                                  }
                                }
                              });
                            }
                          },
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
