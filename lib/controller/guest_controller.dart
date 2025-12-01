import 'dart:convert';
import 'package:cabme/model/guest_user_model.dart';
import 'package:cabme/utils/Preferences.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constant/logdata.dart';
import '../constant/show_toast_dialog.dart';
import '../model/user_model.dart';
import '../service/api.dart';

class GuestController extends GetxController {
  var isGuestUser = false.obs;
  var guestUserData = GuestUserModel().obs;

  var fullNameController = TextEditingController().obs;
  var phoneController = TextEditingController().obs;
  var emailController = TextEditingController().obs;
  var idNumberController = TextEditingController().obs;
  var addressController = TextEditingController().obs;

  @override
  void onInit() {
    super.onInit();
    loadGuestInfo();
  }

  void loadGuestInfo() {
    isGuestUser.value = Preferences.getBoolean(Preferences.isGuestUser);
    if (isGuestUser.value) {
      String? guestData = Preferences.getString(Preferences.guestUserData);
      if (guestData.isNotEmpty) {
        Map<String, dynamic> userMap = jsonDecode(guestData);
        guestUserData.value = GuestUserModel.fromJson(userMap);

        // Load data into controllers
        fullNameController.value.text = guestUserData.value.fullName ?? '';
        phoneController.value.text = guestUserData.value.phone ?? '';
        emailController.value.text = guestUserData.value.email ?? '';
        idNumberController.value.text = guestUserData.value.idNumber ?? '';
        addressController.value.text = guestUserData.value.address ?? '';
      }
    }
  }

  void setGuestMode(bool isGuest) {
    isGuestUser.value = isGuest;
    Preferences.setBoolean(Preferences.isGuestUser, isGuest);
    update();
  }

  void saveGuestInfo() {
    GuestUserModel guestUser = GuestUserModel(
      fullName: fullNameController.value.text.trim(),
      phone: phoneController.value.text.trim(),
      email: emailController.value.text.trim(),
      idNumber: idNumberController.value.text.trim(),
      address: addressController.value.text.trim(),
    );

    guestUserData.value = guestUser;
    Preferences.setString(
        Preferences.guestUserData, jsonEncode(guestUser.toJson()));
    update();
  }

  void clearGuestData() {
    isGuestUser.value = false;
    guestUserData.value = GuestUserModel();
    fullNameController.value.clear();
    phoneController.value.clear();
    emailController.value.clear();
    idNumberController.value.clear();
    addressController.value.clear();

    Preferences.setBoolean(Preferences.isGuestUser, false);
    Preferences.languageCodeKey;
    update();
  }

  bool validateGuestInfo() {
    // Validate required fields
    if (fullNameController.value.text.trim().isEmpty) {
      return false;
    }
    if (phoneController.value.text.trim().isEmpty) {
      return false;
    }
    // Email validation is optional but should be valid format if provided
    if (emailController.value.text.trim().isNotEmpty &&
        !GetUtils.isEmail(emailController.value.text.trim())) {
      return false;
    }
    return true;
  }
  Future<UserModel?> signUp(Map<String, String> bodyParams) async {
    try {
      ShowToastDialog.showLoader("Please wait");

      final response = await http.post(
        Uri.parse(API.userSignUP),
        headers: API.authheader,
        body: jsonEncode(bodyParams),
      );

      showLog("API :: URL :: ${API.userSignUP}");
      showLog("API :: Request Body :: ${jsonEncode(bodyParams)} ");
      showLog("API :: Request Header :: ${API.authheader.toString()} ");
      showLog("API :: responseStatus :: ${response.statusCode} ");
      showLog("API :: responseBody :: ${response.body} ");

      Map<String, dynamic> responseBody = json.decode(response.body);

      ShowToastDialog.closeLoader();

      if (responseBody["success"] == "Failed") {
        ShowToastDialog.showToast(responseBody["error"] ?? "Signup failed");
        return null;
      }


      if (responseBody["data"] == null) {
        ShowToastDialog.showToast("Invalid server response");
        return null;
      }

      // Fetch token safely
      final token = responseBody["data"]["accesstoken"]?.toString() ?? "";

      if (token.isNotEmpty) {
        Preferences.setString(Preferences.accesstoken, token);
        API.header["accesstoken"] = token;
      }

      return UserModel.fromJson(responseBody);

    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast("Error: $e");
    }

    return null;
  }


}
