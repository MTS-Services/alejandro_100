import 'package:cabme/constant/show_toast_dialog.dart';
import 'package:cabme/page/auth_screens/otp_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhoneNumberController extends GetxController {
  var phoneNumber = TextEditingController().obs;
  var resendTokenData = 0.obs;

  sendCode() async {
    await FirebaseAuth.instance
        .verifyPhoneNumber(
      phoneNumber: phoneNumber.value.text.trim(),
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        ShowToastDialog.closeLoader();
        if (e.code == 'invalid-phone-number') {
          ShowToastDialog.showToast("The provided phone number is not valid.");
        } else {
          print(e.message.toString());
          ShowToastDialog.showToast(e.message.toString());
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        resendTokenData.value = resendToken ?? 0;
        ShowToastDialog.closeLoader();
        Get.to(
          const OtpScreen(),
          arguments: {
            'phoneNumber': phoneNumber.value.text,
            'verificationId': verificationId,
            'resendTokenData': resendTokenData.value,
          },
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
      forceResendingToken: resendTokenData.value,
    )
        .catchError((error) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast("You have try many time please send otp after some time");
    });
  }
}
