import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cabme/constant/constant.dart';
import 'package:cabme/constant/logdata.dart';
import 'package:cabme/constant/show_toast_dialog.dart';
import 'package:cabme/model/settings_model.dart';
import 'package:cabme/service/api.dart';
import 'package:cabme/themes/constant_colors.dart';
import 'package:cabme/utils/Preferences.dart';
import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SettingsController extends GetxController {
  @override
  void onInit() {
    API.header['accesstoken'] = Preferences.getString(Preferences.accesstoken);
    getSettingsData();
    super.onInit();
  }

  Future<SettingsModel?> getSettingsData() async {
    try {
      // ShowToastDialog.showLoader("Please wait");
      final response = await http.get(
        Uri.parse(API.settings),
        headers: API.authheader,
      );
      showLog("API :: URL :: ${API.settings}");
      showLog("API :: Request Header :: ${API.header.toString()} ");
      showLog("API :: responseStatus :: ${response.statusCode} ");
      showLog("API :: responseBody :: ${response.body} ");
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "success") {
        // ShowToastDialog.closeLoader();
        SettingsModel model = SettingsModel.fromJson(responseBody);
        Constant.liveTrackingMapType = model.data?.mapType ?? "";
        Constant.selectedMapType = model.data?.mapForApplication != null ? '${model.data?.mapForApplication?.toLowerCase()}' : '';
        AppThemeData.primary200 = Color(int.parse(model.data!.websiteColor!.replaceFirst("#", "0xff")));
        Constant.distanceUnit = model.data!.deliveryDistance!;
        Constant.driverRadius = model.data!.driverRadios!;
        Constant.appVersion = model.data!.appVersion.toString();
        Constant.decimal = model.data!.decimalDigit!;
        Constant.driverLocationUpdate = model.data!.driverLocationUpdate!;
        Constant.deliverChargeParcel = model.data!.deliverChargeParcel!;
        Constant.parcelActive = model.data!.parcelActive!;
        Constant.parcelPerWeightCharge = model.data!.parcelPerWeightCharge!;
        Constant.allTaxList = model.data!.taxModel!;
        // Constant.taxType = model.data!.taxType!;
        // Constant.taxName = model.data!.taxName!;
        // Constant.taxValue = model.data!.taxValue!;
        Constant.currency = model.data!.currency!;
        Constant.symbolAtRight = model.data?.symbolAtRight == 'true' ? true : false;
        Constant.kGoogleApiKey = model.data!.googleMapApiKey!;
        Constant.contactUsEmail = model.data!.contactUsEmail!;
        Constant.contactUsAddress = model.data!.contactUsAddress!;
        Constant.contactUsPhone = model.data!.contactUsPhone!;
        Constant.rideOtp = model.data!.showRideOtp!;
        Constant.senderId = model.data!.senderId!;
        Constant.jsonNotificationFileURL = model.data!.serviceJson!;
        Constant.homeScreenType = model.data!.homeScreenType; //OlaHome
        log("HomeScreenType :: ${Constant.homeScreenType} || MapTYpe :: ${Constant.selectedMapType}");
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
}
