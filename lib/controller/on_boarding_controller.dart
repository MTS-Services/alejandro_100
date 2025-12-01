import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cabme/constant/show_toast_dialog.dart';
import 'package:cabme/model/onboarding_model.dart';
import 'package:cabme/page/auth_screens/login_screen.dart';
import 'package:cabme/page/auth_screens/mobile_number_screen.dart';
import 'package:cabme/service/api.dart';
import 'package:cabme/utils/Preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class OnBoardingController extends GetxController {
  /// Current page index
  final RxInt selectedPageIndex = 0.obs;

  /// Last page status (reactive)
  final RxBool isLastPage = false.obs;

  /// Loader for whole screen
  final RxBool isLoading = true.obs;

  /// PageView controller
  final PageController pageController = PageController();

  /// API data model
  final Rx<OnboardingModel> onboardingModel = OnboardingModel().obs;

  /// Local fallback images (jodi API theke na ashbe)
  final RxList<String> localImage = <String>[
    'assets/images/intro_1.png',
    'assets/images/intro_2.png',
  ].obs;

  @override
  void onInit() {
    super.onInit();
    getBoardingData();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  /// API theke onboarding data ana
  Future<Map<String, dynamic>?> getBoardingData() async {
    try {
      isLoading.value = true;
      ShowToastDialog.showLoader("Please wait");

      final uri = Uri.parse(API.onBoarding);
      final obBoardingData = await http
          .get(uri, headers: API.header)
          .timeout(const Duration(seconds: 30));

      log("API :: URL :: ${API.onBoarding}");
      log("API :: Request Header :: ${API.header.toString()}");
      log("API :: Response Status :: ${obBoardingData.statusCode} ");
      log("API :: Response Body :: ${obBoardingData.body} ");

      if (obBoardingData.statusCode != 200) {
        isLoading.value = false;
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(
          "Server error: ${obBoardingData.statusCode}",
        );
        return null;
      }

      final decodedResponse =
      jsonDecode(obBoardingData.body) as Map<String, dynamic>;

      final success = decodedResponse['success'];
      if (success == 'success' || success == true) {
        onboardingModel.value = OnboardingModel.fromJson(decodedResponse);

        final total = onboardingModel.value.data?.length ?? 0;
        isLastPage.value = total > 0 &&
            selectedPageIndex.value == (total - 1);

        isLoading.value = false;
        ShowToastDialog.closeLoader();
        return decodedResponse;
      } else {
        isLoading.value = false;
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(
          decodedResponse['message']?.toString() ?? "Something went wrong",
        );
        return null;
      }
    } on TimeoutException catch (e) {
      log("API :: Timeout Exception :: ${e.message}");
      isLoading.value = false;
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      log("API :: Socket Exception :: ${e.message}");
      isLoading.value = false;
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast("No internet connection");
    } on Error catch (e) {
      log("API :: Error :: ${e.toString()}");
      isLoading.value = false;
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      log("API :: Exception :: ${e.toString()}");
      isLoading.value = false;
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }

  /// Page change hole ei method call hobe
  void onPageChanged(int index) {
    selectedPageIndex.value = index;
    final total = onboardingModel.value.data?.length ?? localImage.length;
    isLastPage.value = total > 0 && index == total - 1;
  }

  /// Next button press
  void goToNextPage() {
    final total = onboardingModel.value.data?.length ?? localImage.length;

    if (selectedPageIndex.value < total - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Last page hole direct login e niye jao
      navigateToLogin();
    }
  }

  /// Back button (AppBar leading) press
  void goToPreviousPage() {
    if (selectedPageIndex.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Skip button press
  void skipOnBoarding() {
    navigateToLogin();
  }

  /// Navigate to Login screen
  void navigateToLogin() {
    Preferences.setBoolean(Preferences.isFinishOnBoardingKey, true);
    Get.offAll(() => const LoginScreen());
  }

  /// Navigate to Create Account (Mobile number screen)
  void navigateToCreateAccount() {
    Preferences.setBoolean(Preferences.isFinishOnBoardingKey, true);
    Get.offAll(() => MobileNumberScreen(isLogin: false));
  }
}
