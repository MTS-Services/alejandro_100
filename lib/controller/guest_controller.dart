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

  // FIXED: Do NOT use TextEditingController().obs ❌
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final idNumberController = TextEditingController();
  final addressController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadGuestInfo();
  }

  /// ---------------------------------------------------------------
  /// LOAD GUEST INFO FROM LOCAL STORAGE
  /// ---------------------------------------------------------------
  void loadGuestInfo() {
    isGuestUser.value = Preferences.getBoolean(Preferences.isGuestUser);

    String? guestData = Preferences.getString(Preferences.guestUserData);

    if (guestData != null && guestData.isNotEmpty) {
      try {
        Map<String, dynamic> userMap = jsonDecode(guestData);
        guestUserData.value = GuestUserModel.fromJson(userMap);

        fullNameController.text = guestUserData.value.fullName ?? '';
        phoneController.text = guestUserData.value.phone ?? '';
        emailController.text = guestUserData.value.email ?? '';
        idNumberController.text = guestUserData.value.idNumber ?? '';
        addressController.text = guestUserData.value.address ?? '';
      } catch (e) {
        showLog("Guest Load Error: $e");
      }
    }
  }

  /// ---------------------------------------------------------------
  /// SET GUEST MODE
  /// ---------------------------------------------------------------
  void setGuestMode(bool value) {
    isGuestUser.value = value;
    Preferences.setBoolean(Preferences.isGuestUser, value);
    update();
  }

  /// ---------------------------------------------------------------
  /// SAVE GUEST INFO LOCALLY
  /// ---------------------------------------------------------------
  Future<void> saveGuestInfo() async {
    GuestUserModel guestUser = GuestUserModel(
      fullName: fullNameController.text.trim(),
      phone: phoneController.text.trim(),
      email: emailController.text.trim(),
      idNumber: idNumberController.text.trim(),
      address: addressController.text.trim(),
    );

    guestUserData.value = guestUser;

    await Preferences.setString(
      Preferences.guestUserData,
      jsonEncode(guestUser.toJson()),
    );

    update();
  }

  /// ---------------------------------------------------------------
  /// CLEAR GUEST DATA
  /// ---------------------------------------------------------------
  void clearGuestData() {
    isGuestUser.value = false;
    guestUserData.value = GuestUserModel();

    fullNameController.clear();
    phoneController.clear();
    emailController.clear();
    idNumberController.clear();
    addressController.clear();

    Preferences.setBoolean(Preferences.isGuestUser, false);
    Preferences.setString(Preferences.guestUserData, "");

    update();
  }

  /// ---------------------------------------------------------------
  /// VALIDATION
  /// ---------------------------------------------------------------
  bool validateGuestInfo() {
    if (fullNameController.text.trim().isEmpty) return false;
    if (phoneController.text.trim().isEmpty) return false;

    if (emailController.text.trim().isNotEmpty &&
        !GetUtils.isEmail(emailController.text.trim())) return false;

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
    showLog("API :: Status :: ${response.statusCode}");
    showLog("API :: Body :: ${response.body}");

    ShowToastDialog.closeLoader();

    Map<String, dynamic> responseBody = json.decode(response.body);

    if (responseBody["success"] == "Failed") {
      ShowToastDialog.showToast(responseBody["error"] ?? "Signup failed");
      return null;
    }

    if (responseBody["data"] == null) {
      ShowToastDialog.showToast("Invalid server response");
      return null;
    }

    // -------------------------------
    // 🔥 SAVE TOKEN
    // -------------------------------
    final data = responseBody["data"];
    final token = data["accesstoken"]?.toString() ?? "";

    if (token.isNotEmpty) {
      Preferences.setString(Preferences.accesstoken, token);
      API.header["accesstoken"] = token;
    }

    // -------------------------------
    // 🔥 MOST IMPORTANT FIX
    // SAVE GUEST ID LOCALLY
    // -------------------------------
    Preferences.setBoolean(Preferences.isGuestUser, true);

    Preferences.setInt(
      Preferences.userId,
      int.parse(data["id"].toString()),
    );

    // Save full guest info JSON
    Preferences.setString(
      Preferences.guestUserData,
      jsonEncode({
        "id": data["id"],
        "fullName": bodyParams["firstname"],
        "phone": bodyParams["phone"],
        "email": bodyParams["email"],
        "idNumber": bodyParams["cnib"],
        "address": bodyParams["address"],
      }),
    );

    // Also store in controller
    guestUserData.value = GuestUserModel(
      fullName: bodyParams["firstname"],
      phone: bodyParams["phone"],
      email: bodyParams["email"],
      idNumber: bodyParams["cnib"],
      address: bodyParams["address"],
    );

    return UserModel.fromJson(responseBody);

  } catch (e) {
    ShowToastDialog.closeLoader();
    ShowToastDialog.showToast("Error: $e");
    return null;
  }
}

}
