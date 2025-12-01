import 'package:cabme/constant/show_toast_dialog.dart';
import 'package:cabme/controller/forgot_password_controller.dart';
import 'package:cabme/page/auth_screens/forgot_password_otp_screen.dart';
import 'package:cabme/page/auth_screens/mobile_number_screen.dart';
import 'package:cabme/themes/button_them.dart';
import 'package:cabme/themes/constant_colors.dart';
import 'package:cabme/themes/responsive.dart';
import 'package:cabme/themes/text_field_them.dart';
import 'package:cabme/utils/dark_theme_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final controller = Get.put(ForgotPasswordController());

  static final _formKey = GlobalKey<FormState>();
  static final _emailTextEditController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    bool isDarkMode = themeChange.getThem();

    return Scaffold(
      backgroundColor: AppThemeData.primary200,
      bottomNavigationBar: Container(
        color: isDarkMode ? AppThemeData.surface50Dark : AppThemeData.surface50,
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
            Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: Text.rich(
                textAlign: TextAlign.center,
                TextSpan(
                  text: 'First time in CabMe?'.tr,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: AppThemeData.regular,
                    color: isDarkMode ? AppThemeData.grey800Dark : AppThemeData
                        .grey800,
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
                        ..onTap = () =>
                            Get.to(
                                MobileNumberScreen(
                                  isLogin: false,
                                ),
                                duration: const Duration(milliseconds: 400),
                                //duration of transitions, default 1 sec
                                transition: Transition.rightToLeft),
                      //transition effect);,
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
                        "Forgot Your Password?".tr,
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: AppThemeData.semiBold,
                          color: isDarkMode ? AppThemeData.grey50 : AppThemeData
                              .grey50Dark,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Don’t worry! Enter your email or mobile number, and we’ll help you reset your password."
                            .tr,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: AppThemeData.regular,
                          color: isDarkMode ? AppThemeData.grey50 : AppThemeData
                              .grey50Dark,
                        ),
                      ),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    color: isDarkMode
                        ? AppThemeData.surface50Dark
                        : AppThemeData.surface50,
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 4,
                                  spreadRadius: 2,
                                  color: Colors.grey.shade500,
                                  offset: Offset(1, 1)
                              )
                            ]
                        ),
                        child: TextFieldWidget(
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
                          hintText: 'email address'.tr,
                          controller: _emailTextEditController,
                          textInputType: TextInputType.emailAddress,
                          validators: (String? value) {
                            if (value!.isNotEmpty) {
                              return null;
                            } else {
                              return 'required'.tr;
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: ButtonThem.buildButton(
                          context,
                          title: 'Send'.tr,
                          onPress: () async {
                            FocusScope.of(context).unfocus();
                            if (_formKey.currentState!.validate()) {
                              Map<String, String> bodyParams = {
                                'email': _emailTextEditController.text.trim(),
                                'user_cat': "user_app",
                              };
                              controller.sendEmail(bodyParams).then((value) {
                                if (value != null) {
                                  if (value == true) {
                                    Get.to(ForgotPasswordOtpScreen(
                                        email: _emailTextEditController.text
                                            .trim()),
                                        duration: const Duration(
                                            milliseconds: 400),
                                        //duration of transitions, default 1 sec
                                        transition: Transition.rightToLeft);
                                  } else {
                                    ShowToastDialog.showToast(
                                        "Please try again later");
                                  }
                                }
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
