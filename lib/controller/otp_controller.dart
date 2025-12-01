import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cabme/constant/logdata.dart';
import 'package:cabme/constant/show_toast_dialog.dart';
import 'package:cabme/model/user_model.dart';
import 'package:cabme/service/api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class OTPController extends GetxController {
  RxString phoneNumber = "".obs;

  var otpController = TextEditingController().obs;
  var verificationId = ''.obs;
  var resendToken = 0.obs;

  @override
  void onInit() {
    super.onInit();
    otpController.value.clear();
    getArgument();
    startTimer();
  }

  getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      phoneNumber.value = argumentData['phoneNumber'];
      verificationId.value = argumentData['verificationId'];
      resendToken.value = argumentData['resendTokenData'];
    }
  }

  resendOTP() async {
    await sendOTP();
    secondsRemaining.value = 60;
    enableResend.value = false;
    startTimer();
    otpController.value = TextEditingController();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
        update();
      } else {
        timer.cancel();
        enableResend.value = true;
        update();
      }
    });
  }

  RxInt secondsRemaining = 60.obs;
  Timer? timer;
  RxBool enableResend = false.obs;

  Future<bool> sendOTP() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber.value,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId0, int? resendToken0) async {
        verificationId.value = verificationId0;
        resendToken.value = resendToken0!;
        ShowToastDialog.showToast("OTP sent");
      },
      timeout: const Duration(seconds: 25),
      forceResendingToken: resendToken.value,
      codeAutoRetrievalTimeout: (String verificationId0) {
        verificationId0 = verificationId.value;
      },
    );
    return true;
  }

  Future<bool?> phoneNumberIsExit(Map<String, String> bodyParams) async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.post(Uri.parse(API.getExistingUserOrNot), headers: API.authheader, body: jsonEncode(bodyParams));
      showLog("API :: URL :: ${API.getExistingUserOrNot}");
      showLog("API :: Request Body :: ${jsonEncode(bodyParams)} ");
      showLog("API :: Response Status :: ${response.statusCode} ");
      showLog("API :: Response Body :: ${response.body} ");
      Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == 200 && responseBody['success'] == "success") {
        ShowToastDialog.closeLoader();
        if (responseBody['data'] == true) {
          return true;
        } else {
          return false;
        }
      } else if (response.statusCode == 200 && responseBody['success'] == "Failed") {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(responseBody['error']);
        return false;
      } else {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast('Something want wrong. Please try again later');
        throw Exception('Failed to load album');
      }
    } on TimeoutException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }

  Future<UserModel?> getDataByPhoneNumber(Map<String, String> bodyParams) async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.post(Uri.parse(API.getProfileByPhone), headers: API.header, body: jsonEncode(bodyParams));
      showLog("API :: URL :: ${API.getProfileByPhone}");
      showLog("API :: Request Body :: ${jsonEncode(bodyParams)} ");
      showLog("API :: Response Status :: ${response.statusCode} ");
      showLog("API :: Response Body :: ${response.body} ");
      Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == 200 && responseBody['success'] == "success") {
        ShowToastDialog.closeLoader();
        return UserModel.fromJson(responseBody);
      } else if (response.statusCode == 200 && responseBody['success'] == "Failed") {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(responseBody['error']);
      } else {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast('Something want wrong. Please try again later');
        throw Exception('Failed to load album');
      }
    } on TimeoutException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }

  @override
  void onClose() {
    secondsRemaining.value = 60;
    timer?.cancel();
    super.onClose();
  }

  String formatTime() {
    final minutes = secondsRemaining.value ~/ 60;
    final remainingSeconds = secondsRemaining.value % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
