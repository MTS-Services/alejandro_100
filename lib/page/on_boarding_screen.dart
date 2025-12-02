// ignore_for_file: implicit_call_tearoffs

import 'package:cabme/constant/constant.dart';
import 'package:cabme/controller/on_boarding_controller.dart';
import 'package:cabme/page/auth_screens/guest_info_screen.dart';
import 'package:cabme/page/auth_screens/login_screen.dart';
import 'package:cabme/page/auth_screens/mobile_number_screen.dart';
import 'package:cabme/themes/button_them.dart';
import 'package:cabme/themes/constant_colors.dart';
import 'package:cabme/themes/responsive.dart';
import 'package:cabme/utils/Preferences.dart';
import 'package:cabme/utils/dark_theme_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return GetX<OnBoardingController>(
      init: OnBoardingController(),
      builder: (controller) {
        final dataList = controller.onboardingModel.value.data;
        final hasData = dataList != null && dataList.isNotEmpty;

        return Scaffold(
          appBar: AppBar(
            leading: controller.selectedPageIndex.value != 0
                ? IconButton(
              onPressed: controller.goToPreviousPage,
              icon: SvgPicture.asset(
                "assets/icons/ic_back_arrow.svg",
                colorFilter: ColorFilter.mode(
                  themeChange.getThem()
                      ? AppThemeData.grey900Dark
                      : AppThemeData.grey900,
                  BlendMode.srcIn,
                ),
              ),
            )
                : null,
            backgroundColor: themeChange.getThem()
                ? AppThemeData.surface50Dark
                : AppThemeData.surface50,
            elevation: 0,
            actions: [
              if (hasData &&
                  controller.selectedPageIndex.value !=
                      dataList!.length - 1)
                InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    Preferences.setBoolean(
                        Preferences.isFinishOnBoardingKey, true);
                    Get.offAll(const LoginScreen());
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                        decorationColor: AppThemeData.secondary200,
                        color: AppThemeData.secondary200,
                        fontFamily: AppThemeData.regular,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          body: controller.isLoading.value
              ? Center(child: Constant.loader(context))
              : !hasData
              ? const Center(
            child: Text(
              "No onboarding data found",
              textAlign: TextAlign.center,
            ),
          )
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: PageView.builder(
                  controller: controller.pageController,
                  onPageChanged: controller.onPageChanged,
                  itemCount: dataList!.length,
                  itemBuilder: (context, index) {
                    final item = dataList[index];
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Column(
                            children: [
                              Text(
                                item.title ?? '',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 24,
                                  color: themeChange.getThem()
                                      ? AppThemeData.grey900Dark
                                      : AppThemeData.grey900,
                                  fontFamily:
                                  AppThemeData.semiBold,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 40.0,
                                  vertical: 12,
                                ),
                                child: Text(
                                  item.description ?? '',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey900Dark
                                        : AppThemeData.grey900,
                                    letterSpacing: 1.5,
                                    fontFamily:
                                    AppThemeData.regular,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: CachedNetworkImage(
                              filterQuality: FilterQuality.high,
                              fit: BoxFit.cover,
                              width: Responsive.width(
                                  100, context),
                              height: Responsive.width(
                                  100, context),
                              imageUrl: item.image ?? '',
                              placeholder: (context, url) =>
                                  Constant.loader(context),
                              errorWidget:
                                  (context, url, error) {
                                final localImages =
                                    controller.localImage;
                                final safeIndex = index <
                                    localImages.length
                                    ? index
                                    : 0;
                                return Image.asset(
                                  localImages[safeIndex],
                                  fit: BoxFit.cover,
                                  width: Responsive.width(
                                      100, context),
                                  height: Responsive.width(
                                      100, context),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              /// LAST PAGE BUTTONS
              if (controller.selectedPageIndex.value ==
                  dataList.length - 1)
                Column(
                  children: [
                    Center(
                      child: ButtonThem.buildButton(
                        btnColor: AppThemeData.primary200,
                        txtColor: themeChange.getThem()
                            ? AppThemeData.grey900
                            : AppThemeData.grey900Dark,
                        context,
                        title: 'Sign in',
                        btnWidthRatio: 0.6,
                        onPress: () async {
                          Preferences.setBoolean(
                            Preferences.isFinishOnBoardingKey,
                            true,
                          );
                          Get.offAll(const LoginScreen());
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: ButtonThem.buildBorderButton(
                        context,
                        title: 'Continue as Guest',
                        btnWidthRatio: 0.6,
                        onPress: () async {
                          Preferences.setBoolean(
                            Preferences.isFinishOnBoardingKey,
                            true,
                          );
                          Get.offAll(()=>
                            const GuestInfoScreen(),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Preferences.setBoolean(
                            Preferences.isFinishOnBoardingKey,
                            true,
                          );
                          Get.offAll(
                            MobileNumberScreen(isLogin: false),
                          );
                        },
                        child: Text(
                          'Create Account',
                          style: TextStyle(
                            color: AppThemeData.primary200,
                            fontSize: 16,
                            fontFamily: AppThemeData.medium,
                            decoration:
                            TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

              /// NON-LAST PAGE: NEXT BUTTON
              if (controller.selectedPageIndex.value !=
                  dataList.length - 1)
                Center(
                  heightFactor: 1,
                  child: ButtonThem.buildButton(
                    btnColor: AppThemeData.primary200,
                    txtColor: themeChange.getThem()
                        ? AppThemeData.grey900
                        : AppThemeData.grey900Dark,
                    context,
                    title: 'Next',
                    btnWidthRatio: 0.6,
                    onPress: controller.goToNextPage,
                  ),
                ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  /// Old borderRadius helper (jodi pore indicator er jonno dorkar hoy)
  BorderRadiusGeometry borderRadius(int index, int currentIndex) {
    if (index == 0 && currentIndex == 0) {
      return const BorderRadius.all(Radius.circular(10.0));
    }
    if (index == 0 && currentIndex == 1) {
      return const BorderRadius.only(
        topLeft: Radius.circular(40.0),
        bottomLeft: Radius.circular(40.0),
      );
    }
    if (index == 0 && currentIndex == 2) {
      return const BorderRadius.only(
        topRight: Radius.circular(40.0),
        bottomRight: Radius.circular(40.0),
      );
    }
    if (index == 1 && currentIndex == 1) {
      return const BorderRadius.all(Radius.circular(10.0));
    }
    if (index == 1 && currentIndex == 2) {
      return const BorderRadius.all(Radius.circular(10.0));
    }
    if (index == 2 && currentIndex == 2) {
      return const BorderRadius.all(Radius.circular(10.0));
    }
    if (index == 2 && currentIndex == 0) {
      return const BorderRadius.only(
        topLeft: Radius.circular(40.0),
        bottomLeft: Radius.circular(40.0),
      );
    }
    if (index == 2 && currentIndex == 1) {
      return const BorderRadius.only(
        topRight: Radius.circular(40.0),
        bottomRight: Radius.circular(40.0),
      );
    }
    return const BorderRadius.all(Radius.circular(10.0));
  }
}
