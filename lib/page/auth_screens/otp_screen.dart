// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'package:cabme/constant/show_toast_dialog.dart';
import 'package:cabme/controller/otp_controller.dart';
import 'package:cabme/page/auth_screens/login_screen.dart';
import 'package:cabme/page/auth_screens/signup_screen.dart';
import 'package:cabme/page/dash_board.dart';
import 'package:cabme/service/api.dart';
import 'package:cabme/themes/button_them.dart';
import 'package:cabme/themes/responsive.dart';
import 'package:cabme/utils/Preferences.dart';
import 'package:cabme/utils/dark_theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import '../../themes/constant_colors.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    bool isDarkMode = themeChange.getThem();
    return GetX<OTPController>(
        init: OTPController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: AppThemeData.primary200,
            bottomNavigationBar: Container(
              color: isDarkMode ? AppThemeData.surface50Dark : AppThemeData.surface50,
              child: Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  Image.asset(
                    isDarkMode ? 'assets/images/ic_bg_signup_dark.png' : 'assets/images/ic_bg_signup_light.png',
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text.rich(
                      textAlign: TextAlign.center,
                      TextSpan(
                        text: 'Already book rides?'.tr,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: AppThemeData.regular,
                          color: isDarkMode ? AppThemeData.grey800Dark : AppThemeData.grey800,
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
                            recognizer: TapGestureRecognizer()..onTap = () => Get.offAll(LoginScreen()),
                            text: 'Log in'.tr,
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
            body: SafeArea(
              child: Stack(
                alignment: AlignmentDirectional.topStart,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            Text(
                              "Verify Your OTP".tr,
                              style: TextStyle(
                                fontSize: 24,
                                fontFamily: AppThemeData.semiBold,
                                color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey50Dark,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Enter the one-time password sent to your mobile number to verify your account.".tr,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: AppThemeData.regular,
                                color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey50Dark,
                              ),
                            ),
                            const SizedBox(height: 60),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: Responsive.width(100, context),
                          color: themeChange.getThem() ? AppThemeData.surface50Dark : AppThemeData.surface50,
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 140,
                    left: 20,
                    right: 20,
                    child: SizedBox(
                      height: Responsive.height(80, context),
                      width: Responsive.width(85, context),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Pinput(
                            scrollPadding: EdgeInsets.zero,
                            controller: controller.otpController.value,
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
                            length: 6,
                          ),
                          const SizedBox(height: 20),
                          Padding(
                              padding: const EdgeInsets.only(top: 50),
                              child: ButtonThem.buildButton(
                                context,
                                title: 'Verify OTP'.tr,
                                onPress: () async {
                                  FocusScope.of(context).unfocus();

                                  if (controller.otpController.value.text.length == 6) {
                                    ShowToastDialog.showLoader("Verify OTP".tr);
                                    PhoneAuthCredential credential =
                                        PhoneAuthProvider.credential(verificationId: controller.verificationId.toString(), smsCode: controller.otpController.value.text);
                                    await FirebaseAuth.instance.signInWithCredential(credential).then((value) async {
                                      Map<String, String> bodyParams = {
                                        'phone': controller.phoneNumber.value,
                                        'user_cat': "customer",
                                        'login_type' : "phoneNumber"
                                      };
                                      await controller.phoneNumberIsExit(bodyParams).then((value) async {
                                        if (value == true) {
                                          Map<String, String> bodyParams = {
                                            'phone': controller.phoneNumber.value,
                                            'user_cat': "customer",
                                            'login_type': "phoneNumber",
                                          };
                                          await controller.getDataByPhoneNumber(bodyParams).then((value) {
                                            if (value != null) {
                                              if (value.success == "success") {
                                                ShowToastDialog.closeLoader();

                                                Preferences.setInt(Preferences.userId, int.parse(value.data!.id.toString()));
                                                Preferences.setString(Preferences.user, jsonEncode(value));
                                                Preferences.setString(Preferences.accesstoken, value.data!.accesstoken.toString());
                                                Preferences.setString(Preferences.admincommission, value.data!.adminCommission.toString());
                                                API.header['accesstoken'] = Preferences.getString(Preferences.accesstoken);

                                                // if (value.data!.photo == null || value.data!.photoPath.toString().isEmpty) {
                                                //   Get.to(() => AddProfilePhotoScreen());
                                                // } else {
                                                //
                                                // }
                                                Preferences.setBoolean(Preferences.isLogin, true);
                                                Get.offAll(DashBoard());
                                              } else {
                                                ShowToastDialog.showToast(value.error);
                                              }
                                            }
                                          });
                                        } else if (value == false) {
                                          ShowToastDialog.closeLoader();
                                          Get.off(SignupScreen(), arguments: {
                                            'phoneNumber': controller.phoneNumber.value,
                                            'login_type': "phoneNumber",
                                          });
                                        }
                                      });
                                    }).catchError((error) {
                                      ShowToastDialog.closeLoader();
                                      ShowToastDialog.showToast("Code is Invalid");
                                    });
                                  } else {
                                    ShowToastDialog.showToast("Please Enter OTP");
                                  }
                                },
                              )),
                          const SizedBox(height: 30),
                          Text.rich(
                            textAlign: TextAlign.center,
                            TextSpan(
                              text: controller.enableResend.value ? '' : controller.formatTime().tr,
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: AppThemeData.regular,
                                color: themeChange.getThem() ? AppThemeData.grey400Dark : AppThemeData.grey400,
                              ),
                              children: <TextSpan>[
                                if (controller.enableResend.value)
                                  TextSpan(
                                    text: controller.enableResend.value ? '' : ' | '.tr,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: AppThemeData.medium,
                                      color: themeChange.getThem() ? AppThemeData.grey400Dark : AppThemeData.grey400,
                                    ),
                                  ),
                                if (controller.enableResend.value)
                                  TextSpan(
                                    recognizer: TapGestureRecognizer()..onTap = () => controller.resendOTP(),
                                    text: 'Resend OTP'.tr,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: AppThemeData.medium,
                                      color: AppThemeData.secondar300,
                                      decoration: TextDecoration.underline,
                                      decorationColor: AppThemeData.secondar300,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
