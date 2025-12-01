import 'dart:convert';
import 'dart:io';
import 'package:cabme/constant/show_toast_dialog.dart';
import 'package:cabme/controller/login_conroller.dart';
import 'package:cabme/page/auth_screens/forgot_password.dart';
import 'package:cabme/page/auth_screens/guest_info_screen.dart';
import 'package:cabme/page/auth_screens/mobile_number_screen.dart';
import 'package:cabme/page/dash_board.dart';
import 'package:cabme/themes/button_them.dart';
import 'package:cabme/themes/constant_colors.dart';
import 'package:cabme/themes/text_field_them.dart';
import 'package:cabme/utils/Preferences.dart';
import 'package:cabme/utils/dark_theme_provider.dart';
import 'package:cabme/widget/permission_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/svg.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static const double buttonHeight = 50;
  static const double buttonFontSize = 16;
  static const double iconSize = 24;

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    bool isDarkMode = themeChange.getThem();

    return GetBuilder(
        init: LoginController(),
        initState: (state) async {
          try {
            PermissionStatus location = await Location().hasPermission();
            if (PermissionStatus.granted != location) {
              showDialogPermission(context);
            }
          } on PlatformException catch (e) {
            ShowToastDialog.showToast("${e.message}");
          }
        },
        builder: (controller) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: AppThemeData.primary200,
            body: SafeArea(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          color: AppThemeData.primary200,
                          child: SingleChildScrollView(
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
                                        "Welcome Back!".tr,
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
                                        "Log in to your Flex account and continue your journey with seamless rides."
                                            .tr,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: AppThemeData.regular,
                                          color: isDarkMode
                                              ? AppThemeData.grey50
                                              : AppThemeData.grey50Dark,
                                        ),
                                      ),
                                      const SizedBox(height: 50),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 130),
                            Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 15 , vertical: 15),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
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
                                  child: Column(
                                    children: [
                                      TextFieldWidget(
                                        prefix: IconButton(
                                          onPressed: () {},
                                          icon: SvgPicture.asset(
                                            "assets/icons/ic_email.svg",
                                            height: iconSize,
                                            width: iconSize,
                                            colorFilter: ColorFilter.mode(
                                              themeChange.getThem()
                                                  ? AppThemeData.grey500Dark
                                                  : AppThemeData.grey300Dark,
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                        ),
                                        hintText: 'email address'.tr,
                                        controller: controller.phoneController.value,
                                        textInputType: TextInputType.emailAddress,
                                      ),
                                      SizedBox(height: 15,),
                                      TextFieldWidget(
                                        prefix: IconButton(
                                          onPressed: () {},
                                          icon: SvgPicture.asset(
                                            'assets/icons/ic_lock.svg',
                                            height: iconSize,
                                            width: iconSize,
                                            colorFilter: ColorFilter.mode(
                                              themeChange.getThem()
                                                  ? AppThemeData.grey500Dark
                                                  : AppThemeData.grey300Dark,
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                        ),
                                        hintText: 'enter password'.tr,
                                        controller: controller.passwordController.value,
                                        textInputType: TextInputType.text,
                                        obscureText: true,
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: GestureDetector(
                                          onTap: () {
                                            Get.to(
                                              ForgotPasswordScreen(),
                                              duration: const Duration(milliseconds: 400),
                                              transition: Transition.rightToLeft,
                                            );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 10),
                                            child: Text(
                                              "forgot password".tr,
                                              style: TextStyle(
                                                fontSize: buttonFontSize,
                                                color: AppThemeData.secondary200,
                                                fontFamily: AppThemeData.regular,
                                                decoration: TextDecoration.underline,
                                                decorationColor: AppThemeData.secondary200,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 50),
                              child: ButtonThem.buildButton(
                                context,
                                title: 'Log in'.tr,
                                onPress: () async {
                                  if (controller.phoneController.value.text.isEmpty) {
                                    ShowToastDialog.showToast('Please enter the email address');
                                  } else if (controller.passwordController.value.text.isEmpty) {
                                    ShowToastDialog.showToast('Please enter the password');
                                  } else {
                                    FocusScope.of(context).unfocus();
                                    Map<String, String> bodyParams = {
                                      'email': controller.phoneController.value.text.trim(),
                                      'mdp': controller.passwordController.value.text,
                                      'user_cat': "customer",
                                    };
                                    print("bodyParams: $bodyParams");
                                    await controller.loginAPI(bodyParams).then((value) {
                                      if (value != null && value.success == "Success") {
                                        Preferences.setInt(Preferences.userId,
                                            int.parse(value.data!.id.toString()));
                                        try {
                                          Preferences.setString(Preferences.user,
                                              jsonEncode(value.toJson()));
                                        } catch (e) {
                                          print("JSON encoding error: $e");
                                        }
                                        controller.phoneController.value.clear();
                                        controller.passwordController.value.clear();
                                        Preferences.setBoolean(Preferences.isLogin, true);
                                        Get.offAll(DashBoard(),
                                            duration: const Duration(milliseconds: 400),
                                            transition: Transition.rightToLeft);
                                      } else {
                                        ShowToastDialog.showToast(value?.error ?? "Login failed");
                                      }
                                    });
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: 35),
                            Text(
                              "or continue with".tr,
                              style: TextStyle(
                                fontSize: buttonFontSize,
                                color: themeChange.getThem()
                                    ? AppThemeData.grey400Dark
                                    : AppThemeData.grey400,
                                fontFamily: AppThemeData.regular,
                              ),
                            ),
                            const SizedBox(height: 45),
                            // Mobile number button
                            ButtonThem.buildIconButtonWidget(
                              context,
                              title: 'Mobile number'.tr,
                              btnColor: themeChange.getThem()
                                  ? AppThemeData.grey300Dark
                                  : AppThemeData.grey300,
                              txtColor: themeChange.getThem()
                                  ? AppThemeData.grey900Dark
                                  : AppThemeData.grey900,
                              iconColor: themeChange.getThem()
                                  ? AppThemeData.grey900Dark
                                  : AppThemeData.grey900,
                              icon: SvgPicture.asset(
                                "assets/icons/ic_phone_line.svg",
                                height: iconSize,
                                width: iconSize,
                              ),
                              onPress: () {
                                FocusScope.of(context).unfocus();
                                Get.to(MobileNumberScreen(isLogin: true),
                                    duration: const Duration(milliseconds: 400),
                                    transition: Transition.rightToLeft);
                              },
                            ),
                            const SizedBox(height: 15),

                            Platform.isAndroid
                                ? ButtonThem.buildIconButtonWidget(
                              context,
                              title: 'Google'.tr,
                              btnColor: themeChange.getThem()
                                  ? AppThemeData.grey300Dark
                                  : AppThemeData.grey300,
                              txtColor: themeChange.getThem()
                                  ? AppThemeData.grey900Dark
                                  : AppThemeData.grey900,
                              iconColor: themeChange.getThem()
                                  ? AppThemeData.grey900Dark
                                  : AppThemeData.grey900,
                              icon: SvgPicture.asset(
                                "assets/icons/ic_google.svg",
                                height: iconSize,
                                width: iconSize,
                              ),
                              onPress: () {
                                FocusScope.of(context).unfocus();
                                controller.signInWithGoogle();
                              },
                            )
                                : Row(
                              children: [
                                Expanded(
                                  child: ButtonThem.buildIconButtonWidget(
                                    context,
                                    title: 'Google'.tr,
                                    btnColor: themeChange.getThem()
                                        ? AppThemeData.grey300Dark
                                        : AppThemeData.grey300,
                                    txtColor: themeChange.getThem()
                                        ? AppThemeData.grey900Dark
                                        : AppThemeData.grey900,
                                    iconColor: themeChange.getThem()
                                        ? AppThemeData.grey900Dark
                                        : AppThemeData.grey900,
                                    icon: SvgPicture.asset(
                                      "assets/icons/ic_google.svg",
                                      height: iconSize,
                                      width: iconSize,
                                    ),
                                    onPress: () {
                                      FocusScope.of(context).unfocus();
                                      controller.signInWithGoogle();
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: ButtonThem.buildIconButtonWidget(
                                    context,
                                    title: 'Apple'.tr,
                                    btnColor: themeChange.getThem()
                                        ? AppThemeData.grey300Dark
                                        : AppThemeData.grey300,
                                    txtColor: themeChange.getThem()
                                        ? AppThemeData.grey900Dark
                                        : AppThemeData.grey900,
                                    iconColor: themeChange.getThem()
                                        ? AppThemeData.grey900Dark
                                        : AppThemeData.grey900,
                                    icon: SvgPicture.asset(
                                      "assets/icons/ic_apple.svg",
                                      height: iconSize,
                                      width: iconSize,
                                    ),
                                    onPress: () {
                                      FocusScope.of(context).unfocus();
                                      controller.loginWithApple();
                                    },
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          children: [
                            Text.rich(
                              textAlign: TextAlign.center,
                              TextSpan(
                                text: 'First time in CabMe?'.tr,
                                style: TextStyle(
                                  fontSize: buttonFontSize,
                                  fontFamily: AppThemeData.regular,
                                  color: isDarkMode
                                      ? AppThemeData.grey800Dark
                                      : AppThemeData.grey800,
                                ),
                                children: <TextSpan>[
                                  TextSpan(text: ' '.tr),
                                  TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => Get.to(
                                          MobileNumberScreen(isLogin: false),
                                          duration: const Duration(milliseconds: 400),
                                          transition: Transition.rightToLeft),
                                    text: 'Create an account'.tr,
                                    style: TextStyle(
                                      fontSize: buttonFontSize,
                                      fontFamily: AppThemeData.medium,
                                      color: AppThemeData.primary200,
                                      decoration: TextDecoration.underline,
                                      decorationColor: AppThemeData.primary200,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: () {
                                Get.to(() => GuestInfoScreen(),
                                    duration: const Duration(milliseconds: 400),
                                    transition: Transition.rightToLeft);
                              },
                              child: Text(
                                'Continue as Guest'.tr,
                                style: TextStyle(
                                  fontSize: buttonFontSize,
                                  fontFamily: AppThemeData.medium,
                                  color: AppThemeData.primary200,
                                  decoration: TextDecoration.underline,
                                  decorationColor: AppThemeData.primary200,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  showDialogPermission(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const LocationPermissionDisclosureDialog(),
    );
  }
}
