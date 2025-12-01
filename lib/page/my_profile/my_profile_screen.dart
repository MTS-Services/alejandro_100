// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'dart:io';
import 'package:cabme/constant/constant.dart';
import 'package:cabme/constant/show_toast_dialog.dart';
import 'package:cabme/controller/dash_board_controller.dart';
import 'package:cabme/controller/my_profile_controller.dart';
import 'package:cabme/page/auth_screens/login_screen.dart';
import 'package:cabme/themes/appbar_cust.dart';
import 'package:cabme/themes/button_them.dart';
import 'package:cabme/themes/constant_colors.dart';
import 'package:cabme/themes/responsive.dart';
import 'package:cabme/themes/text_field_them.dart';
import 'package:cabme/utils/Preferences.dart';
import 'package:cabme/utils/dark_theme_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';

class MyProfileScreen extends StatelessWidget {
  MyProfileScreen({super.key});

  final GlobalKey<FormState> _profileKey = GlobalKey();

  final dashboardController = Get.put(DashBoardController());

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<MyProfileController>(
        init: MyProfileController(),
        builder: (myProfileController) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: CustomAppbar(
              title: 'My Profile'.tr,
              bgColor: AppThemeData.primary200,
            ),
            bottomNavigationBar: SizedBox(
              height: 80,
              child: Column(
                children: [
                  buildShowDetails(
                    isTrailingShow: false,
                    textIconColor: AppThemeData.error200,
                    isDarkMode: themeChange.getThem(),
                    title: "Delete Account".tr,
                    icon: 'assets/icons/ic_delete.svg',
                    onPress: () async {
                      await showDialog(
                          context: context,
                          useSafeArea: true,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                'Are you sure you want to delete account?'.tr,
                                style: const TextStyle(fontSize: 16),
                              ),
                              actions: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: ButtonThem.buildButton(
                                        context,
                                        title: 'No'.tr,
                                        btnColor: Colors.red,
                                        txtColor: Colors.white,
                                        onPress: () {
                                          Get.back();
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: ButtonThem.buildButton(
                                        context,
                                        title: 'Yes'.tr,
                                        btnColor: AppThemeData.primary200,
                                        txtColor: Colors.white,
                                        onPress: () {
                                          myProfileController
                                              .deleteAccount(Preferences.getInt(
                                                      Preferences.userId)
                                                  .toString())
                                              .then((value) {
                                            if (value != null) {
                                              if (value["success"] ==
                                                  "success") {
                                                ShowToastDialog.showToast(
                                                    value['message']);
                                                Get.back();
                                                Preferences
                                                    .clearSharPreference();
                                                Get.offAll(const LoginScreen());
                                              }
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            );
                          });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            body: Stack(
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
                      flex: 8,
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        color: themeChange.getThem()
                            ? AppThemeData.surface50Dark
                            : AppThemeData.surface50,
                      ),
                    ),
                  ],
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Form(
                              key: _profileKey,
                              child: Column(
                                children: [
                                  const SizedBox(height: 20),
                                  Align(
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      height: 120,
                                      width: 120,
                                      child: Stack(
                                        alignment: Alignment.bottomCenter,
                                        children: [
                                          Center(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              child: myProfileController
                                                      .imageData
                                                      .value
                                                      .path
                                                      .isNotEmpty
                                                  ? Center(
                                                      child: Image.file(
                                                        File(myProfileController
                                                            .imageData
                                                            .value
                                                            .path),
                                                        height: 120,
                                                        width: 120,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    )
                                                  : myProfileController
                                                          .photoPath.isEmpty
                                                      ? CachedNetworkImage(
                                                          imageUrl: Constant
                                                              .placeholderUrl,
                                                          height: 120,
                                                          width: 120,
                                                          fit: BoxFit.cover,
                                                          progressIndicatorBuilder:
                                                              (context, url,
                                                                      downloadProgress) =>
                                                                  Center(
                                                            child: CircularProgressIndicator(
                                                                value: downloadProgress
                                                                    .progress),
                                                          ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Image.asset(
                                                            "assets/images/appIcon.png",
                                                          ),
                                                        )
                                                      : CachedNetworkImage(
                                                          imageUrl:
                                                              myProfileController
                                                                  .photoPath
                                                                  .toString(),
                                                          height: 120,
                                                          width: 120,
                                                          fit: BoxFit.cover,
                                                          progressIndicatorBuilder:
                                                              (context, url,
                                                                      downloadProgress) =>
                                                                  Center(
                                                            child: CircularProgressIndicator(
                                                                value: downloadProgress
                                                                    .progress),
                                                          ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Image.asset(
                                                            "assets/images/appIcon.png",
                                                          ),
                                                        ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: InkWell(
                                              onTap: () => buildBottomSheet(
                                                  context, myProfileController),
                                              child: ClipOval(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: AppThemeData
                                                          .primary200,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: SvgPicture.asset(
                                                      'assets/icons/ic_edit.svg',
                                                      width: 22,
                                                      height: 22,
                                                      colorFilter:
                                                          ColorFilter.mode(
                                                        themeChange.getThem()
                                                            ? AppThemeData
                                                                .grey900
                                                            : AppThemeData
                                                                .grey900Dark,
                                                        BlendMode.srcIn,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 50),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
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
                                                          colorFilter:
                                                              ColorFilter.mode(
                                                            themeChange
                                                                    .getThem()
                                                                ? AppThemeData
                                                                    .grey500Dark
                                                                : AppThemeData
                                                                    .grey300Dark,
                                                            BlendMode.srcIn,
                                                          ),
                                                        ),
                                                      ),
                                                      hintText: 'Name'.tr,
                                                      controller:
                                                          myProfileController
                                                              .fullNameController
                                                              .value,
                                                      textInputType:
                                                          TextInputType.text,
                                                      maxLength: 22,
                                                      validators:
                                                          (String? value) {
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
                                                          colorFilter:
                                                              ColorFilter.mode(
                                                            themeChange
                                                                    .getThem()
                                                                ? AppThemeData
                                                                    .grey500Dark
                                                                : AppThemeData
                                                                    .grey300Dark,
                                                            BlendMode.srcIn,
                                                          ),
                                                        ),
                                                      ),
                                                      hintText: 'Last Name'.tr,
                                                      controller:
                                                          myProfileController
                                                              .lastNameController
                                                              .value,
                                                      textInputType:
                                                          TextInputType.text,
                                                      maxLength: 22,
                                                      validators:
                                                          (String? value) {
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
                                                  width: 0.8,
                                                )),
                                                child: IntlPhoneField(
                                                  textAlign: TextAlign.start,
                                                  flagsButtonPadding:
                                                      EdgeInsets.only(
                                                          left: 10, right: 10),
                                                  readOnly: true,
                                                  initialValue:
                                                      myProfileController
                                                          .phoneController
                                                          .value
                                                          .text,
                                                  onChanged: (phone) {
                                                    myProfileController
                                                            .phoneController
                                                            .value
                                                            .text =
                                                        phone.completeNumber;
                                                  },
                                                  invalidNumberMessage:
                                                      "number invalid".tr,
                                                  showDropdownIcon: false,
                                                  disableLengthCheck: true,
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(),
                                                      borderSide: BorderSide(
                                                        color: AppThemeData
                                                            .primary200,
                                                        width: 0.8,
                                                      ),
                                                    ),
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            vertical: 14),
                                                    hintText: 'Phone Number'.tr,
                                                    isDense: true,
                                                  ),
                                                ),
                                              ),
                                              TextFieldWidget(
                                                isReadOnly: true,
                                                prefix: IconButton(
                                                  onPressed: () {},
                                                  icon: SvgPicture.asset(
                                                    'assets/icons/ic_email.svg',
                                                    colorFilter:
                                                        ColorFilter.mode(
                                                      themeChange.getThem()
                                                          ? AppThemeData
                                                              .grey500Dark
                                                          : AppThemeData
                                                              .grey300Dark,
                                                      BlendMode.srcIn,
                                                    ),
                                                  ),
                                                ),
                                                hintText: 'email'.tr,
                                                controller: myProfileController
                                                    .emailController.value,
                                                textInputType:
                                                    TextInputType.emailAddress,
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
                                              // TextFieldWidget(
                                              //   prefix: IconButton(
                                              //     onPressed: () {},
                                              //     icon: SvgPicture.asset(
                                              //       'assets/icons/ic_lock.svg',
                                              //       colorFilter: ColorFilter.mode(
                                              //         themeChange.getThem() ? AppThemeData.grey500Dark : AppThemeData.grey300Dark,
                                              //         BlendMode.srcIn,
                                              //       ),
                                              //     ),
                                              //   ),
                                              //   hintText: 'password'.tr,
                                              //   controller: myProfileController.currentPasswordController.value,
                                              //   textInputType: TextInputType.text,
                                              //   obscureText: false,
                                              //   validators: (String? value) {
                                              //     return null;
                                              //   },
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        ButtonThem.buildButton(context,
                            title: 'Save Details'.tr, onPress: () async {
                          FocusScope.of(context).unfocus();
                          if (_profileKey.currentState!.validate()) {
                            await myProfileController
                                .updateUser(
                              image: File(
                                  myProfileController.imageData.value.path),
                              name: myProfileController
                                  .fullNameController.value.text
                                  .trim(),
                              lname: myProfileController
                                  .lastNameController.value.text
                                  .trim(),
                              email: myProfileController
                                  .emailController.value.text
                                  .trim(),
                              phoneNum: myProfileController
                                  .phoneController.value.text
                                  .trim(),
                              password: myProfileController
                                  .currentPasswordController.value.text
                                  .trim(),
                            )
                                .then((value) {
                              if (value != null) {
                                if (value.success == "success") {
                                  Preferences.setInt(Preferences.userId,
                                      int.parse(value.data!.id.toString()));
                                  Preferences.setString(
                                      Preferences.user, jsonEncode(value));
                                  Get.back();
                                } else {
                                  ShowToastDialog.showToast(value.error);
                                }
                              }
                            });
                          }
                        }),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  buildShowDetails({
    required String title,
    required String icon,
    required Function()? onPress,
    required bool isDarkMode,
    Color? textIconColor,
    bool? isTrailingShow = true,
  }) {
    return ListTile(
      splashColor: Colors.transparent,
      leading: SvgPicture.asset(
        icon,
        width: 20,
        height: 20,
        colorFilter: ColorFilter.mode(
          textIconColor ??
              (isDarkMode ? AppThemeData.grey900Dark : AppThemeData.grey900),
          BlendMode.srcIn,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontFamily: AppThemeData.medium,
          color: textIconColor ??
              (isDarkMode ? AppThemeData.grey900Dark : AppThemeData.grey900),
        ),
      ),
      onTap: onPress,
      trailing: isTrailingShow == false
          ? null
          : SvgPicture.asset(
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

  buildAlertChangeData(
    BuildContext context, {
    required String title,
    required TextEditingController controller,
    required IconData iconData,
    required String? Function(String?) validators,
    required Function() onSubmitBtn,
  }) {
    return Get.defaultDialog(
      titlePadding: const EdgeInsets.only(top: 20),
      radius: 6,
      title: "Change Information".tr,
      titleStyle: const TextStyle(
        fontSize: 20,
      ),
      content: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFieldThem.boxBuildTextField(
                conext: context,
                hintText: title,
                controller: controller,
                validators: validators),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                ButtonThem.buildButton(context,
                    title: "Save".tr,
                    btnColor: AppThemeData.primary200,
                    txtColor: Colors.white,
                    onPress: onSubmitBtn,
                    btnWidthRatio: 0.3),
                const SizedBox(
                  width: 15,
                ),
                ButtonThem.buildButton(context,
                    title: "cancel".tr,
                    btnWidthRatio: 0.3,
                    btnColor: AppThemeData.secondary200,
                    txtColor: Colors.black,
                    onPress: () => Get.back()),
              ],
            )
          ],
        ),
      ),
    );
  }

  buildBottomSheet(BuildContext context, MyProfileController controller) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Container(
              height: Responsive.height(22, context),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      "Please Select".tr,
                      style: TextStyle(
                        color: const Color(0XFF333333).withOpacity(0.8),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () => pickFile(controller,
                                    source: ImageSource.camera),
                                icon: const Icon(
                                  Icons.camera_alt,
                                  size: 32,
                                )),
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text("camera".tr),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () => pickFile(controller,
                                    source: ImageSource.gallery),
                                icon: const Icon(
                                  Icons.photo_library_sharp,
                                  size: 32,
                                )),
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text("gallery".tr),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          });
        });
  }

  final ImagePicker _imagePicker = ImagePicker();

  Future pickFile(MyProfileController controller,
      {required ImageSource source}) async {
    try {
      XFile? image = await _imagePicker.pickImage(source: source);
      if (image == null) return;
      Get.back();
      controller.imageData.value = image;
      // controller.uploadPhoto(File(image.path)).then((value) {
      //   if (value != null) {
      //     if (value["success"] == "Success") {
      //       UserModel userModel = Constant.getUserData();
      //       userModel.data!.photoPath = value['data']['photo_path'];
      //       Preferences.setString(Preferences.user, jsonEncode(userModel.toJson()));
      //       controller.getUsrData();
      //       dashboardController.getUsrData();
      //       ShowToastDialog.showToast("Upload successfully!".tr);
      //     } else {
      //       ShowToastDialog.showToast(value['error']);
      //     }
      //   }
      // });
    } on PlatformException catch (e) {
      ShowToastDialog.showToast("${"Failed to Pick :".tr}\n $e");
    }
  }
}
