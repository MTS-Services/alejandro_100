import 'dart:convert';
import 'dart:io';

import 'package:cabme/constant/show_toast_dialog.dart';
import 'package:cabme/controller/sign_up_controller.dart';
import 'package:cabme/page/auth_screens/login_screen.dart';
import 'package:cabme/page/auth_screens/signup_success_screen.dart';
import 'package:cabme/themes/button_them.dart';
import 'package:cabme/themes/constant_colors.dart';
import 'package:cabme/themes/text_field_them.dart';
import 'package:cabme/utils/Preferences.dart';
import 'package:cabme/utils/dark_theme_provider.dart';
import 'package:cabme/widget/permission_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    bool isDarkMode = themeChange.getThem();

    return GetBuilder<SignUpController>(
        init: SignUpController(),
        builder: (controller) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          color: AppThemeData.primary200,
                        ),
                      ),
                      Expanded(
                        flex: Platform.isIOS ? 3 : 4,
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          color: isDarkMode
                              ? AppThemeData.surface50Dark
                              : AppThemeData.surface50,
                          child: Image.asset(
                            isDarkMode
                                ? 'assets/images/ic_bg_signup_dark.png'
                                : 'assets/images/ic_bg_signup_light.png',
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Form(
                          key: _formKey,
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 20),
                                      Text(
                                        "Create Your Account".tr,
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontFamily: AppThemeData.semiBold,
                                          color: isDarkMode
                                              ? AppThemeData.grey50
                                              : AppThemeData.grey50Dark,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        "Sign up for a personalized CabME experience. Start booking your rides in just a few taps."
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
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                  Container(
                                    color: themeChange.getThem()
                                        ? AppThemeData.surface50Dark
                                        : AppThemeData.surface50,
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextFieldWidget(
                                                prefix: IconButton(
                                                  onPressed: () {},
                                                  icon: SvgPicture.asset(
                                                    'assets/icons/ic_user.svg',
                                                    colorFilter: ColorFilter.mode(
                                                      themeChange.getThem()
                                                          ? AppThemeData
                                                              .grey500Dark
                                                          : AppThemeData
                                                              .grey300Dark,
                                                      BlendMode.srcIn,
                                                    ),
                                                  ),
                                                ),
                                                hintText: 'Name'.tr,
                                                controller: controller
                                                    .firstNameController.value,
                                                textInputType: TextInputType.text,
                                                maxLength: 22,
                                                validators: (String? value) {
                                                  if (value!.isNotEmpty) {
                                                    return null;
                                                  } else {
                                                    return 'required'.tr;
                                                  }
                                                },
                                              ),
                                            ),
                                            Expanded(
                                              child: TextFieldWidget(
                                                prefix: IconButton(
                                                  onPressed: () {},
                                                  icon: SvgPicture.asset(
                                                    'assets/icons/ic_user.svg',
                                                    colorFilter: ColorFilter.mode(
                                                      themeChange.getThem()
                                                          ? AppThemeData
                                                              .grey500Dark
                                                          : AppThemeData
                                                              .grey300Dark,
                                                      BlendMode.srcIn,
                                                    ),
                                                  ),
                                                ),
                                                hintText: 'Last Name'.tr,
                                                controller: controller
                                                    .lastNameController.value,
                                                textInputType: TextInputType.text,
                                                maxLength: 22,
                                                validators: (String? value) {
                                                  if (value!.isNotEmpty) {
                                                    return null;
                                                  } else {
                                                    return 'required'.tr;
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: themeChange.getThem()
                                                      ? AppThemeData.grey200Dark
                                                      : AppThemeData.grey200,
                                                ),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(0))),
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: IntlPhoneField(
                                              flagsButtonPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8),
                                              textAlign: TextAlign.start,
                                              onChanged: (number) {
                                                controller.phoneNumber.value
                                                    .text = number.completeNumber;
                                              },
                                              showDropdownIcon: false,
                                              initialValue: controller
                                                  .phoneNumber.value.text,
                                              readOnly:
                                                  controller.loginType.value ==
                                                              "google" ||
                                                          controller.loginType
                                                                  .value ==
                                                              "apple"
                                                      ? false
                                                      : true,
                                              invalidNumberMessage:
                                                  "number invalid".tr,
                                              disableLengthCheck: true,
                                              validator: (p0) {
                                                if (p0!.number.isNotEmpty) {
                                                  return null;
                                                } else {
                                                  return 'required'.tr;
                                                }
                                              },
                                              decoration: InputDecoration(
                                                hintStyle: TextStyle(
                                                  fontSize: 16,
                                                  color: themeChange.getThem()
                                                      ? AppThemeData.grey400Dark
                                                      : AppThemeData.grey400,
                                                  fontFamily:
                                                      AppThemeData.regular,
                                                ),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 14),
                                                hintText: 'mobile number'.tr,
                                                border: InputBorder.none,
                                                isDense: true,
                                              ),
                                            )),
                                        TextFieldWidget(
                                          prefix: IconButton(
                                            onPressed: () {},
                                            icon: SvgPicture.asset(
                                              'assets/icons/ic_email.svg',
                                              colorFilter: ColorFilter.mode(
                                                themeChange.getThem()
                                                    ? AppThemeData.grey500Dark
                                                    : AppThemeData.grey300Dark,
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                          ),
                                          hintText: 'email'.tr,
                                          controller:
                                              controller.emailController.value,
                                          textInputType:
                                              TextInputType.emailAddress,
                                          isReadOnly: controller
                                                          .loginType.value ==
                                                      "google" ||
                                                  controller.loginType.value ==
                                                      "apple"
                                              ? true
                                              : false,
                                          validators: (String? value) {
                                            bool emailValid = RegExp(
                                                    r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                                                .hasMatch(value!);
                                            if (!emailValid) {
                                              return 'email not valid'.tr;
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                        controller.loginType.value == "google" ||
                                                controller.loginType.value ==
                                                    "apple"
                                            ? SizedBox()
                                            : TextFieldWidget(
                                                prefix: IconButton(
                                                  onPressed: () {},
                                                  icon: SvgPicture.asset(
                                                    'assets/icons/ic_lock.svg',
                                                    colorFilter: ColorFilter.mode(
                                                      themeChange.getThem()
                                                          ? AppThemeData
                                                              .grey500Dark
                                                          : AppThemeData
                                                              .grey300Dark,
                                                      BlendMode.srcIn,
                                                    ),
                                                  ),
                                                ),
                                                hintText: 'password'.tr,
                                                controller: controller
                                                    .passwordController.value,
                                                textInputType: TextInputType.text,
                                                obscureText: false,
                                                validators: (String? value) {
                                                  if (value!.length >= 6) {
                                                    return null;
                                                  } else {
                                                    return 'Password required at least 6 characters'
                                                        .tr;
                                                  }
                                                },
                                              ),
                                        controller.loginType.value == "google" ||
                                                controller.loginType.value ==
                                                    "apple"
                                            ? SizedBox()
                                            : TextFieldWidget(
                                                prefix: IconButton(
                                                  onPressed: () {},
                                                  icon: SvgPicture.asset(
                                                    'assets/icons/ic_lock.svg',
                                                    colorFilter: ColorFilter.mode(
                                                      themeChange.getThem()
                                                          ? AppThemeData
                                                              .grey500Dark
                                                          : AppThemeData
                                                              .grey300Dark,
                                                      BlendMode.srcIn,
                                                    ),
                                                  ),
                                                ),
                                                hintText: 'Confirm Password'.tr,
                                                controller: controller
                                                    .conformPasswordController
                                                    .value,
                                                textInputType: TextInputType.text,
                                                obscureText: false,
                                                validators: (String? value) {
                                                  if (controller
                                                          .passwordController
                                                          .value
                                                          .text !=
                                                      value) {
                                                    return 'Confirm password is invalid'
                                                        .tr;
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                              ),
                                        TextFieldWidget(
                                          validators: (v) {
                                            return null;
                                          },
                                          prefix: IconButton(
                                            onPressed: () {},
                                            icon: SvgPicture.asset(
                                              'assets/icons/ic_referral.svg',
                                              colorFilter: ColorFilter.mode(
                                                themeChange.getThem()
                                                    ? AppThemeData.grey500Dark
                                                    : AppThemeData.grey300Dark,
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                          ),
                                          hintText: 'Referral Code (Optional)'.tr,
                                          controller: controller
                                              .referralCodeController.value,
                                          textInputType: TextInputType.text,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(top: 50),
                                      child: ButtonThem.buildButton(
                                        context,
                                        title: 'Sign up'.tr,
                                        onPress: () async {
                                          FocusScope.of(context).unfocus();
                                          if (_formKey.currentState!.validate()) {
                                            if (controller.phoneNumber.value.value
                                                .text.isEmpty) {
                                              ShowToastDialog.showToast(
                                                  "Phone number is empty");
                                            } else {
                                              Map<String, String> bodyParams = {
                                                'firstname': controller
                                                    .firstNameController
                                                    .value
                                                    .text
                                                    .trim()
                                                    .toString(),
                                                'lastname': controller
                                                    .lastNameController.value.text
                                                    .trim()
                                                    .toString(),
                                                'phone': controller
                                                    .phoneNumber.value.text
                                                    .trim(),
                                                'email': controller
                                                    .emailController.value.text
                                                    .trim(),
                                                'password': controller
                                                    .passwordController
                                                    .value
                                                    .text,
                                                'referral_code': controller
                                                    .referralCodeController
                                                    .value
                                                    .text
                                                    .toString(),
                                                'login_type':
                                                    controller.loginType.value,
                                                'tonotify': 'yes',
                                                'account_type': 'customer',
                                              };
                                              await controller
                                                  .signUp(bodyParams)
                                                  .then((value) {
                                                if (value != null) {
                                                  if (value.success ==
                                                      "success") {
                                                    Preferences.setInt(
                                                        Preferences.userId,
                                                        int.parse(value.data!.id
                                                            .toString()));
                                                    Preferences.setString(
                                                        Preferences.user,
                                                        jsonEncode(value));
                                                    Preferences.setBoolean(
                                                        Preferences.isLogin,
                                                        true);
                                                    ShowToastDialog.showToast(
                                                        "Signup successful!".tr);
                                                    Get.offAll(
                                                        const SignUpSuccessScreen());
                                                  } else {
                                                    ShowToastDialog.showToast(
                                                        value.error);
                                                  }
                                                }
                                              });
                                            }
                                          }
                                        },
                                      )),
                                ],
                              ),
                            ),
                          ),
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
                                        duration:
                                            const Duration(milliseconds: 400),
                                        transition: Transition.rightToLeft),
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
        });
  }

  showDialogPermission(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const LocationPermissionDisclosureDialog(),
    );
  }
}
