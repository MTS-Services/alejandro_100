import 'package:cabme/model/tax_model.dart';

class SettingsModel {
  String? success;
  String? error;
  String? message;
  Data? data;

  SettingsModel({this.success, this.error, this.message, this.data});

  SettingsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? id;
  String? title;
  String? footer;
  String? email;
  String? websiteColor;
  String? driverappColor;
  String? adminpanelColor;
  String? appLogo;
  String? appLogoSmall;
  String? googleMapApiKey;
  String? isSocialMedia;
  String? driverRadios;
  String? userRideScheduleTimeMinute;
  String? tripAcceptRejectDriverTimeSec;
  String? showRideWithoutDestination;
  String? showRideOtp;
  String? showRideLater;
  String? deliveryDistance;
  String? appVersion;
  String? webVersion;
  String? contactUsAddress;
  String? contactUsPhone;
  String? contactUsEmail;
  String? creer;
  String? modifier;
  String? currency;
  String? decimalDigit;
  String? mapType;
  String? mapForApplication;
  String? driverLocationUpdate;
  String? deliverChargeParcel;
  String? serviceJson;
  String? senderId;

  // String? taxName;
  // String? taxType;
  // String? taxValue;
  String? symbolAtRight;
  List<TaxModel>? taxModel;
  String? deliveryChargeParcel;
  String? parcelActive;
  String? parcelPerWeightCharge;
  String? homeScreenType;

  Data(
      {this.id,
      this.title,
      this.footer,
      this.email,
      this.websiteColor,
      this.driverappColor,
      this.adminpanelColor,
      this.appLogo,
      this.appLogoSmall,
      this.googleMapApiKey,
      this.isSocialMedia,
      this.driverRadios,
      this.userRideScheduleTimeMinute,
      this.tripAcceptRejectDriverTimeSec,
      this.showRideWithoutDestination,
      this.showRideOtp,
      this.showRideLater,
      this.deliveryDistance,
      this.appVersion,
      this.webVersion,
      this.contactUsAddress,
      this.contactUsPhone,
      this.contactUsEmail,
      this.creer,
      this.modifier,
      this.currency,
      this.decimalDigit,
      this.mapType,
      this.mapForApplication,
      this.driverLocationUpdate,
      this.deliverChargeParcel,
      this.serviceJson,
      this.senderId,

      // this.taxName,
      // this.taxType,
      // this.taxValue,
      this.symbolAtRight,
      this.taxModel,
      this.deliveryChargeParcel,
      this.parcelPerWeightCharge,
      this.parcelActive,
      this.homeScreenType});

  Data.fromJson(Map<String, dynamic> json) {
    List<TaxModel>? taxList;
    if (json['tax'] != null) {
      taxList = <TaxModel>[];
      json['tax'].forEach((v) {
        taxList!.add(TaxModel.fromJson(v));
      });
    }
    id = json['id'].toString();
    title = json['title'].toString();
    footer = json['footer'].toString();
    email = json['email'].toString();
    websiteColor = json['website_color'].toString();
    driverappColor = json['driverapp_color'].toString();
    adminpanelColor = json['adminpanel_color'].toString();
    appLogo = json['app_logo'].toString();
    appLogoSmall = json['app_logo_small'].toString();
    googleMapApiKey = json['google_map_api_key'].toString();
    isSocialMedia = json['is_social_media'].toString();
    driverRadios = json['driver_radios'].toString();
    userRideScheduleTimeMinute = json['user_ride_schedule_time_minute'].toString();
    tripAcceptRejectDriverTimeSec = json['trip_accept_reject_driver_time_sec'].toString();
    showRideWithoutDestination = json['show_ride_without_destination'].toString();
    showRideOtp = json['show_ride_otp'].toString();
    showRideLater = json['show_ride_later'].toString();
    deliveryDistance = json['delivery_distance'].toString();
    appVersion = json['app_version'].toString();
    webVersion = json['web_version'].toString();
    contactUsAddress = json['contact_us_address'].toString();
    contactUsPhone = json['contact_us_phone'].toString();
    contactUsEmail = json['contact_us_email'].toString();
    creer = json['creer'].toString();
    modifier = json['modifier'].toString();
    currency = json['currency'].toString();
    decimalDigit = json['decimal_digit'].toString();
    driverLocationUpdate = json['driverLocationUpdate'].toString();
    mapType = json['mapType'].toString();
    mapForApplication = json['map_for_application'].toString();
    deliverChargeParcel = json['delivery_charge_parcel'].toString();
    serviceJson = json['serviceJson'].toString();
    senderId = json['senderId'].toString();
    // taxType = json['tax_type'].toString();
    // taxValue = json['tax_value'].toString() ?? "0";
    symbolAtRight = json['symbol_at_right'] ?? 'false';
    taxModel = taxList;
    deliveryChargeParcel = json['delivery_charge_parcel'].toString();
    parcelActive = json['parcel_active'].toString();
    parcelPerWeightCharge = json['parcel_per_weight_charge'].toString();
    homeScreenType = json['home_screen_type'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['footer'] = footer;
    data['email'] = email;
    data['website_color'] = websiteColor;
    data['driverapp_color'] = driverappColor;
    data['adminpanel_color'] = adminpanelColor;
    data['app_logo'] = appLogo;
    data['app_logo_small'] = appLogoSmall;
    data['google_map_api_key'] = googleMapApiKey;
    data['is_social_media'] = isSocialMedia;
    data['driver_radios'] = driverRadios;
    data['user_ride_schedule_time_minute'] = userRideScheduleTimeMinute;
    data['trip_accept_reject_driver_time_sec'] = tripAcceptRejectDriverTimeSec;
    data['show_ride_without_destination'] = showRideWithoutDestination;
    data['show_ride_otp'] = showRideOtp;
    data['show_ride_later'] = showRideLater;
    data['delivery_distance'] = deliveryDistance;
    data['app_version'] = appVersion;
    data['web_version'] = webVersion;
    data['contact_us_address'] = contactUsAddress;
    data['contact_us_phone'] = contactUsPhone;
    data['contact_us_email'] = contactUsEmail;
    data['creer'] = creer;
    data['modifier'] = modifier;
    data['currency'] = currency;
    data['decimal_digit'] = decimalDigit;
    data['mapType'] = mapType;
    data['map_for_application'] = mapForApplication;
    data['driverLocationUpdate'] = driverLocationUpdate;
    data['delivery_charge_parcel'] = deliverChargeParcel;
    // data['tax_type'] = taxType;
    // data['tax_value'] = taxValue;
    data['symbol_at_right'] = symbolAtRight;
    data['tax'] = taxModel?.map((v) => v.toJson()).toList();

    data['parcel_per_weight_charge'] = parcelPerWeightCharge;
    data['serviceJson'] = serviceJson;
    data['senderId'] = senderId;
    data['parcel_active'] = parcelActive;
    data['delivery_charge_parcel'] = deliveryChargeParcel;
    data['home_screen_type'] = homeScreenType;
    return data;
  }
}
