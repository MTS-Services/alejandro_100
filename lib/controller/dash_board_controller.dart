import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cabme/constant/constant.dart';
import 'package:cabme/constant/show_toast_dialog.dart';
import 'package:cabme/model/user_model.dart';
import 'package:cabme/page/auth_screens/login_screen.dart';

import 'package:cabme/page/localization_screens/localization_screen.dart';
import 'package:cabme/page/my_profile/change_password_screen.dart';
import 'package:cabme/page/my_profile/my_profile_screen.dart';
import 'package:cabme/page/parcel_service_screen/all_parcel_screen.dart';
import 'package:cabme/page/privacy_policy/privacy_policy_screen.dart';
import 'package:cabme/page/referral_screen/referral_screen.dart';
import 'package:cabme/page/terms_service/terms_of_service_screen.dart';
import 'package:cabme/page/wallet/wallet_screen.dart';
import 'package:cabme/service/api.dart';
import 'package:cabme/utils/Preferences.dart';
import 'package:cabme/utils/dark_theme_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:cabme/constant/logdata.dart';
import 'package:cabme/controller/guest_controller.dart';
import 'package:cabme/page/contact_us/contact_us_screen.dart';
import 'package:flutter/material.dart';

class DrawerItems {
  String? title;
  String icon;
  String? section;
  bool? isSwitch;

  DrawerItems({this.title, required this.icon, this.section, this.isSwitch});
}

class DashBoardController extends GetxController {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  RxInt selectedDrawerIndex = 0.obs;
  RxBool darkModel = false.obs;
  UserModel? userModel;
  List<DrawerItems> drawerItems = [];

  @override
  void onInit() {
    print("=+++++++++========${Constant.selectedMapType}");
    print("=+++++++++========${Constant.homeScreenType}");
    // try {
    //   getGuestController;
    // } catch (e) {
    //   Get.put(GuestController(), tag: 'guest');
    // }
    getUsrData();
    super.onInit();
  }

  GuestController get getGuestController =>
      Get.find<GuestController>(tag: 'guest');

  setThemeMode(bool isDarkMode) async {
    var themeProvider = Provider.of<DarkThemeProvider>(Get.context!);
    themeProvider.darkTheme = (isDarkMode == true ? 0 : 1);
  }

  getUsrData() async {
  print(":::::::::::::DashBoardController:::::::::::::::");
  String userData = Preferences.getString(Preferences.user);

  if (userData.isNotEmpty) {
    userModel = UserModel.fromJson(jsonDecode(userData));
    await updateToken();
  } 
  else {
    // 👇 **THIS PART WAS MISSING — LOAD GUEST USER DATA**
    String guestData = Preferences.getString(Preferences.guestUserData);
    if (guestData.isNotEmpty) {
      print("✅ Loaded Guest User Data");
      userModel = UserModel.fromJson(jsonDecode(guestData));  // FIXED
    } else {
      print("⚠️ No user data found at all.");
    }
  }

  await getPaymentSettingData();
}


  updateToken() async {
    // use the returned token to send messages to users from your custom server
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      updateFCMToken(token);
    }
  }

  List<DrawerItems> getDrawerItems() {
    bool isGuestUser = Preferences.getBoolean(Preferences.isGuestUser);
    List<DrawerItems> drawerItems = [];

    if (isGuestUser) {
      // Limited menu items for guest users
      drawerItems = [
        DrawerItems(
            title: "FLEX".tr,
            icon: 'assets/icons/ic_home.svg',
            section: 'GENERAL'.tr),
        DrawerItems(title: "Services".tr, icon: 'assets/icons/ic_my_rides.svg'),
        DrawerItems(
            title: "Localization".tr, icon: 'assets/icons/ic_address.svg'),
        DrawerItems(
            title: "Dark Mode".tr,
            icon: 'assets/icons/ic_dark_mode.svg',
            isSwitch: true),
        DrawerItems(
            title: "Terms of Service".tr,
            icon: 'assets/icons/ic_term_service.svg'),
        DrawerItems(
            title: "Privacy Policy".tr,
            icon: 'assets/icons/ic_privacy_policy.svg'),
        DrawerItems(
            title: "Contact Us".tr, icon: 'assets/icons/ic_contacted.svg'),
        DrawerItems(title: "Sign In".tr, icon: 'assets/icons/ic_logout.svg'),
      ];
    } else {
      // Full menu for regular users
      drawerItems = [
        DrawerItems(
            title: "Home".tr,
            icon: 'assets/icons/ic_home.svg',
            section: 'GENERAL'.tr),
        // DrawerItems(title: "All Rides".tr, icon: 'assets/icons/ic_parcel.svg'),
        // DrawerItems(
        //     title: "Favourite Rides".tr, icon: 'assets/icons/ic_rent.svg'),
        // DrawerItems(
        //     title: "Rent Ride History".tr, icon: 'assets/icons/ic_fav.svg'),
        DrawerItems(
            title: 'Parcel History'.tr, icon: 'assets/icons/ic_car.svg'),
        DrawerItems(title: "Wallet".tr, icon: 'assets/icons/ic_wallet.svg'),
        DrawerItems(
            title: "My Profile".tr, icon: 'assets/icons/ic_profile.svg'),
        DrawerItems(
            title: "Change Password".tr, icon: 'assets/icons/ic_lock.svg'),
        DrawerItems(
            title: "Refer a Friend".tr,
            icon: 'assets/icons/ic_refer.svg',
            isSwitch: true),
        DrawerItems(
            title: "Change Language".tr,
            icon: 'assets/icons/ic_language.svg',
            section: 'SUPPORT'.tr),
        DrawerItems(
            title: "Terms & Conditions".tr, icon: 'assets/icons/ic_terms.svg'),
        DrawerItems(
            title: "Privacy Policy".tr, icon: 'assets/icons/ic_privacy.svg'),
        DrawerItems(title: "Dark Mode".tr, icon: 'assets/icons/ic_dark.svg'),
        DrawerItems(title: "Log out".tr, icon: 'assets/icons/ic_logout.svg'),
      ];
    }

    // Don't call update() here since this method will be called from the UI
    return drawerItems;
  }

  onSelectItem(int index) {
    bool isGuestUser = Preferences.getBoolean(Preferences.isGuestUser);

    if (index != selectedDrawerIndex.value) {
      selectedDrawerIndex.value = index;
      log("position $selectedDrawerIndex");

      if (isGuestUser) {
        // Handle guest user navigation
        switch (index) {
          case 0:
            // Home
            scaffoldKey.currentState!.closeDrawer();
            break;
          case 1:
            // Services
            scaffoldKey.currentState!.closeDrawer();
            break;
          case 2:
            // Localization
            Get.to(const LocalizationScreens(
              intentType: "dashBoard",
            ));
            break;
          case 4:
            // Terms of Service
            Get.to(const TermsOfServiceScreen());
            break;
          case 5:
            // Privacy Policy
            Get.to(const PrivacyPolicyScreen());
            break;
          case 6:
            // Contact Us
            Get.to(const ContactUsScreen());
            break;
          case 7:
            // Sign In - switch from guest mode to login
            getGuestController.clearGuestData();
            Preferences.clearSharPreference();
            Get.offAll(const LoginScreen());
            break;
        }
      } else {
        // Handle regular user navigation
        switch (index) {
          // case 1:
          //   Get.to(const NewRideScreen());
          //   break;
          // case 1:
          //   Get.to(const FavoriteRideScreen());
          //   break;
          // case 3:
          //   Get.to(const RentedVehicleScreen());
          //   break;
          case 1:
            if (Constant.parcelActive.toString() == "yes") {
              Get.to(const AllParcelScreen());
            } else {
              // show a dialog
              Get.defaultDialog(
                title: "Parcel Service Unavailable".tr,
                middleText:
                    "Sorry, the parcel service is currently unavailable.".tr,
                confirm: ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text("OK".tr),
                ),
              );
            }

            break;
          case 2:
            Get.to(WalletScreen());
            break;
          case 3:
            Get.to(MyProfileScreen());
            break;
          case 4:
            Get.to(ChangePasswordScreen());

            break;
          case 5:
            Get.to(const ReferralScreen());

            break;
          case 6:
            Get.to(const LocalizationScreens(
              intentType: "dashBoard",
            ));
            break;
          case 7:
            Get.to(const TermsOfServiceScreen());
            break;
          case 8:
            Get.to(const PrivacyPolicyScreen());
            break;
          case 9:
            Get.to(const ContactUsScreen());
            break;
          case 10:
            Preferences.clearSharPreference();
            Get.offAll(const LoginScreen());
            break;
        }
      }
    }
  }

  Future<dynamic> updateFCMToken(String token) async {
    try {
      if (userModel == null || userModel!.data == null) {
        print("⚠️ userModel is NULL. Skipping FCM token update.");
        return null;  // STOP here to prevent crash
      }

      Map<String, dynamic> bodyParams = {
        'user_id': Preferences.getInt(Preferences.userId) ?? "",
        'fcm_id': token,
        'device_id': "",
        'user_cat': userModel!.data!.userCat ?? "",
      };

      final response = await http.post(
        Uri.parse(API.updateToken),
        headers: API.header,
        body: jsonEncode(bodyParams),
      );

      showLog("API :: URL :: ${API.updateToken} ");
      showLog("API :: Request Body :: ${jsonEncode(bodyParams)} ");
      showLog("API :: Request Header :: ${API.header.toString()} ");
      showLog("API :: responseStatus :: ${response.statusCode} ");
      showLog("API :: responseBody :: ${response.body} ");

      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200) {
        return responseBody;
      } else if (response.statusCode == 401) {
        Preferences.clearKeyData(Preferences.isLogin);
        Preferences.clearKeyData(Preferences.user);
        Preferences.clearKeyData(Preferences.userId);
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(
            'An admin has deleted your account. You no longer have access.'.tr);
        Get.offAll(const LoginScreen());
      } else {
        ShowToastDialog.showToast(
            'Something want wrong. Please try again later');
      }
    } catch (e) {
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }


  Future<dynamic> getPaymentSettingData() async {
    try {
      final response =
          await http.get(Uri.parse(API.paymentSetting), headers: API.header);
      showLog("API :: URL :: ${API.paymentSetting} ");
      showLog("API :: Request Header :: ${API.header.toString()} ");
      showLog("API :: responseStatus :: ${response.statusCode} ");
      showLog("API :: responseBody :: ${response.body} ");
      Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == 200 && responseBody['success'] == "success") {
        Preferences.setString(
            Preferences.paymentSetting, jsonEncode(responseBody));
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "Failed") {
      } else {
        ShowToastDialog.showToast(
            'Something want wrong. Please try again later');
        throw Exception('Failed to load album');
      }
    } on TimeoutException {
      // ShowToastDialog.showToast(e.message.toString());
    } on SocketException {
      // ShowToastDialog.showToast(e.message.toString());
    } on Error {
      // ShowToastDialog.showToast(e.toString());
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }
}
