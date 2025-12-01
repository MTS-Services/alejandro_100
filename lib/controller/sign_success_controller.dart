import 'package:cabme/page/dash_board.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignSuccessController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) => redirectScreen());
  }

  redirectScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    Get.offAll(DashBoard());
  }
}
