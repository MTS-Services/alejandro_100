import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cabme/constant/logdata.dart';
import 'package:cabme/constant/show_toast_dialog.dart';
import 'package:cabme/model/parcel_model.dart';
import 'package:cabme/model/user_model.dart';
import 'package:cabme/service/api.dart';
import 'package:cabme/utils/Preferences.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ParcelOrderController extends GetxController {
  var isLoading = true.obs;
  var newParcelList = <ParcelData>[].obs;
  var completedParcelList = <ParcelData>[].obs;
  var rejectedParcelList = <ParcelData>[].obs;

  Timer? _timer;

  @override
  void onInit() {
    getParcel(isInit: true);
    _startPeriodicFetch();
    super.onInit();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void _startPeriodicFetch() {
    _timer = Timer.periodic(const Duration(seconds: 15), (timer) {
      getParcel();
    });
  }

  // ---------------- GET PARCELS ----------------
  Future<void> getParcel({bool isInit = false}) async {
    try {
      if (isInit) ShowToastDialog.showLoader("Please wait");

      final int userId = Preferences.getInt(Preferences.userId);
      print("Fetching parcels for User ID: $userId");
      showLog("Fetching parcels for User ID: $userId");

      final response = await http.get(
        Uri.parse("${API.getParcel}?id_user_app=$userId"),
        headers: API.header,
      );

      showLog("API :: URL :: ${API.getParcel}?id_user_app=$userId");
      showLog("API :: Request Header :: ${API.header.toString()} ");
      showLog("API :: responseStatus :: ${response.statusCode} ");
      showLog("API :: responseBody :: ${response.body} ");

      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'].toString() == "success") {
        isLoading.value = false;

        ParcelModel model = ParcelModel.fromJson(responseBody);
        newParcelList.clear();
        completedParcelList.clear();
        rejectedParcelList.clear();

        for (var parcel in model.data!) {
          if (parcel.status == "rejected" || parcel.status == "driver_rejected") {
            rejectedParcelList.add(parcel);
          } else if (parcel.status == "completed") {
            completedParcelList.add(parcel);
          } else if (parcel.status != "canceled") {
            newParcelList.add(parcel);
          }
        }

        ShowToastDialog.closeLoader();
      } else {
        rejectedParcelList.clear();
        completedParcelList.clear();
        newParcelList.clear();
        ShowToastDialog.closeLoader();
        isLoading.value = false;
      }
    } on TimeoutException catch (e) {
      isLoading.value = false;
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      isLoading.value = false;
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } catch (e) {
      isLoading.value = false;
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
  }

  // ---------------- SIGNUP ----------------
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

      // Save token
      final token = responseBody["data"]["accesstoken"]?.toString() ?? "";
      if (token.isNotEmpty) {
        await Preferences.setString(Preferences.accesstoken, token);
        API.header["accesstoken"] = token;
      }

      // Save user ID
      final dynamic idValue = responseBody["data"]["id_user_app"] ?? responseBody["data"]["id"] ?? 0;
      final int userIdParsed = (idValue is int) ? idValue : int.tryParse(idValue.toString()) ?? 0;
      if (userIdParsed != 0) {
        await Preferences.setInt(Preferences.userId, userIdParsed);
        API.header["id_user_app"] = userIdParsed.toString();

        // Print user ID
        print("User ID after signup: $userIdParsed");
        showLog("User ID after signup: $userIdParsed");
      }

      // Mark as normal user
      await Preferences.setBoolean(Preferences.isGuestUser, false);

      return UserModel.fromJson(responseBody);
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast("Error: $e");
    }

    return null;
  }

  // ---------------- GUEST CREATE ----------------
  Future<UserModel?> createGuestUser(Map<String, String> bodyParams) async {
    try {
      ShowToastDialog.showLoader("Please wait");

      final response = await http.post(
        Uri.parse(API.userSignUP), // <--- replace with your guest API endpoint
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
        ShowToastDialog.showToast(responseBody["error"] ?? "Guest create failed");
        return null;
      }

      if (responseBody["data"] == null) {
        ShowToastDialog.showToast("Invalid server response");
        return null;
      }

      // Save token
      final token = responseBody["data"]["accesstoken"]?.toString() ?? "";
      if (token.isNotEmpty) {
        await Preferences.setString(Preferences.accesstoken, token);
        API.header["accesstoken"] = token;
      }

      // Save guest user ID
      final dynamic idValue = responseBody["data"]["id_user_app"] ?? responseBody["data"]["id"] ?? 0;
      final int userIdParsed = (idValue is int) ? idValue : int.tryParse(idValue.toString()) ?? 0;
      if (userIdParsed != 0) {
        await Preferences.setInt(Preferences.userId, userIdParsed);
        API.header["id_user_app"] = userIdParsed.toString();

        // Print guest user ID
        print("Guest User ID created: $userIdParsed");
        showLog("Guest User ID created: $userIdParsed");
      }

      // Mark as guest
      await Preferences.setBoolean(Preferences.isGuestUser, true);

      // Save raw guest data
      await Preferences.setString(Preferences.guestUserData, jsonEncode(responseBody["data"]));

      return UserModel.fromJson(responseBody);
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast("Error: $e");
    }

    return null;
  }
}
