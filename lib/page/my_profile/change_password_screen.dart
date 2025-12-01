// ignore_for_file: must_be_immutable

import 'package:cabme/constant/show_toast_dialog.dart';
import 'package:cabme/controller/dash_board_controller.dart';
import 'package:cabme/controller/my_profile_controller.dart';
import 'package:cabme/themes/appbar_cust.dart';
import 'package:cabme/themes/button_them.dart';
import 'package:cabme/themes/constant_colors.dart';
import 'package:cabme/themes/responsive.dart';
import 'package:cabme/themes/text_field_them.dart';
import 'package:cabme/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});

  final GlobalKey<FormState> _passwordKey = GlobalKey();

  final dashboardController = Get.put(DashBoardController());

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<MyProfileController>(
        init: MyProfileController(),
        builder: (myProfileController) {
          return Scaffold(
            appBar: CustomAppbar(
              title: 'Change Password'.tr,
              bgColor: AppThemeData.primary200,
            ),
            body: Stack(
              alignment: AlignmentDirectional.topStart,
              children: [
                Container(
                  color: AppThemeData.primary200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(flex: 1, child: SizedBox()),
                      Expanded(
                        flex: 9,
                        child: Container(
                          color: themeChange.getThem() ? AppThemeData.surface50Dark : AppThemeData.surface50,
                        ),
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Form(
                          key: _passwordKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              TextFieldWidget(
                                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                                prefix: IconButton(
                                  onPressed: () {},
                                  icon: SvgPicture.asset(
                                    'assets/icons/ic_lock.svg',
                                    width: 20,
                                    height: 20,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                controller: myProfileController.currentPasswordController.value,
                                hintText: 'Current Password'.tr,
                                validators: (String? value) {
                                  if (value!.isNotEmpty) {
                                    return null;
                                  } else {
                                    return "required".tr;
                                  }
                                },
                              ),
                              TextFieldWidget(
                                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                                prefix: IconButton(
                                  onPressed: () {},
                                  icon: SvgPicture.asset(
                                    'assets/icons/ic_lock.svg',
                                    width: 20,
                                    height: 20,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                controller: myProfileController.newPasswordController.value,
                                hintText: 'New Password'.tr,
                                validators: (String? value) {
                                  if (value!.isNotEmpty) {
                                    return null;
                                  } else {
                                    return "required".tr;
                                  }
                                },
                              ),
                              TextFieldWidget(
                                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                                  prefix: IconButton(
                                    onPressed: () {},
                                    icon: SvgPicture.asset(
                                      'assets/icons/ic_lock.svg',
                                      width: 20,
                                      height: 20,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  controller: myProfileController.confirmPasswordController.value,
                                  hintText: 'Confirm Password'.tr,
                                  validators: (String? value) {
                                    if (value!.isNotEmpty) {
                                      if (value == myProfileController.newPasswordController.value.text) {
                                        return null;
                                      } else {
                                        return "Password Field do not match  !!".tr;
                                      }
                                    } else {
                                      return "required".tr;
                                    }
                                  })
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            bottomNavigationBar: SizedBox(
              height: 80,
              width: Responsive.width(100, context),
              child: Center(
                child: ButtonThem.buildButton(context,
                    title: 'Save Password'.tr,
                    btnWidthRatio: 0.7,
                    btnColor: AppThemeData.primary200,
                    txtColor: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey50Dark, onPress: () {
                  if (_passwordKey.currentState!.validate()) {
                    myProfileController.updatePassword({
                      "id_user": myProfileController.userId.value.toString(),
                      "anc_mdp": myProfileController.currentPasswordController.value.text,
                      "new_mdp": myProfileController.newPasswordController.value.text,
                      "user_cat": myProfileController.userCat.value,
                    }).then((value) {
                      if (value != null) {
                        myProfileController.currentPasswordController.value.clear();
                        myProfileController.newPasswordController.value.clear();
                        myProfileController.confirmPasswordController.value.clear();
                        Get.back();
                        ShowToastDialog.showToast("Password Updated!!");
                      } else {
                        ShowToastDialog.showToast('Something went to wrong');
                      }
                    });
                  }
                }),
              ),
            ),
          );
        });
  }

  buildShowDetails({
    required String title,
    required String icon,
    required Function()? onPress,
    required bool isDarkMode,
  }) {
    return ListTile(
      leading: SvgPicture.asset(
        icon,
        width: 20,
        height: 20,
        colorFilter: ColorFilter.mode(
          isDarkMode ? AppThemeData.grey900Dark : AppThemeData.grey900,
          BlendMode.srcIn,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontFamily: AppThemeData.medium,
          color: isDarkMode ? AppThemeData.grey900Dark : AppThemeData.grey900,
        ),
      ),
      onTap: onPress,
      trailing: SvgPicture.asset(
        'assets/icons/ic_right_arrow.svg',
        width: 20,
        height: 20,
        colorFilter: ColorFilter.mode(
          isDarkMode ? AppThemeData.grey300Dark : AppThemeData.grey400,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
