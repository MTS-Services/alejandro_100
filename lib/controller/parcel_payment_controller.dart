import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cabme/constant/constant.dart';
import 'package:cabme/constant/logdata.dart';
import 'package:cabme/constant/show_toast_dialog.dart';
import 'package:cabme/model/CoupanCodeModel.dart';
import 'package:cabme/model/parcel_details_model.dart';
import 'package:cabme/model/parcel_model.dart';
import 'package:cabme/model/payment_setting_model.dart';
import 'package:cabme/model/tax_model.dart';
import 'package:cabme/model/user_model.dart';
import 'package:cabme/service/api.dart';
import 'package:cabme/utils/Preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ParcelPaymentController extends GetxController {
  var paymentSettingModel = PaymentSettingModel().obs;
  var walletAmount = "0".obs;

  TextEditingController couponCodeController = TextEditingController();
  TextEditingController tripAmountTextFieldController = TextEditingController();

  RxBool cash = false.obs;
  RxBool wallet = false.obs;
  RxBool stripe = false.obs;
  RxBool razorPay = false.obs;
  RxBool paypal = false.obs;
  RxBool payStack = false.obs;
  RxBool flutterWave = false.obs;
  RxBool mercadoPago = false.obs;
  RxBool payFast = false.obs;
  RxBool xendit = false.obs;
  RxBool orangePay = false.obs;
  RxBool midtrans = false.obs;

  RxString selectedPromoCode = "".obs;
  RxString selectedPromoValue = "".obs;

  @override
  void onInit() {
    getArgument();
    getCoupanCodeData();
    getUsrData();
    paymentSettingModel.value = Constant.getPaymentSetting();

    super.onInit();
  }

  RxDouble subTotalAmount = 0.0.obs;
  RxDouble tipAmount = 0.0.obs;
  RxDouble taxAmount = 0.0.obs;
  RxDouble discountAmount = 0.0.obs;
  RxDouble adminCommission = 0.0.obs;

  var data = ParcelData().obs;
  var coupanCodeList = <CoupanCodeData>[].obs;

  Future<dynamic> getCoupanCodeData() async {
    try {
      final response = await http.get(Uri.parse("${API.discountList}?ride_type=parcel"), headers: API.header);
      showLog("API :: URL :: ${API.discountList}?ride_type=parcel");
      showLog("API :: Request Header :: ${API.header.toString()} ");
      showLog("API :: responseStatus :: ${response.statusCode} ");
      showLog("API :: responseBody :: ${response.body} ");
      Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == 200 && responseBody['success'] == "success") {
        CoupanCodeModel model = CoupanCodeModel.fromJson(responseBody);
        coupanCodeList.value = model.data!;
      } else if (response.statusCode == 200 && responseBody['success'] == "Failed") {
        coupanCodeList.clear();
      } else {
        ShowToastDialog.showToast('Something want wrong. Please try again later');
        throw Exception('Failed to load album');
      }
    } on TimeoutException catch (e) {
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }

  getArgument() async {
    subTotalAmount.value = 0.0;
    tipAmount.value = 0.0;
    discountAmount.value = 0.0;
    taxAmount.value = 0.0;
    adminCommission.value = 0.0;
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      data.value = argumentData["parcelData"];
      selectedRadioTile.value = data.value.libelle.toString();
      subTotalAmount.value = double.parse(data.value.amount.toString());
      // taxAmount.value = double.parse(Constant.taxValue ?? "0.0");

      if (selectedRadioTile.value == "Wallet") {
        wallet.value = true;
      } else if (selectedRadioTile.value == "Cash") {
        cash.value = true;
      } else if (selectedRadioTile.value == "Stripe") {
        stripe.value = true;
      } else if (selectedRadioTile.value == "PayStack") {
        payStack.value = true;
      } else if (selectedRadioTile.value == "FlutterWave") {
        flutterWave.value = true;
      } else if (selectedRadioTile.value == "RazorPay") {
        razorPay.value = true;
      } else if (selectedRadioTile.value == "PayFast") {
        payFast.value = true;
      } else if (selectedRadioTile.value == "MercadoPago") {
        mercadoPago.value = true;
      } else if (selectedRadioTile.value == "PayPal") {
        paypal.value = true;
      }
    }
    getAmount();
    if (data.value.paymentStatus == "yes") {
      getParcelDetailsData(data.value.id.toString());
    } else {
      for (var i = 0; i < Constant.taxList.length; i++) {
        if (Constant.taxList[i].statut == 'yes') {
          if (Constant.taxList[i].type == "Fixed") {
            taxAmount.value += double.parse(Constant.taxList[i].value.toString());
          } else {
            taxAmount.value += ((subTotalAmount.value - discountAmount.value) * double.parse(Constant.taxList[i].value!.toString())) / 100;
          }
        }
      }
    }
    update();
  }

  Future<dynamic> getAmount() async {
    try {
      final response = await http.get(Uri.parse("${API.wallet}?id_user=${Preferences.getInt(Preferences.userId)}&user_cat=user_app"), headers: API.header);
      showLog("API :: URL :: ${API.wallet}?id_user=${Preferences.getInt(Preferences.userId)}&user_cat=user_app");
      showLog("API :: Request Header :: ${API.header.toString()} ");
      showLog("API :: responseStatus :: ${response.statusCode} ");
      showLog("API :: responseBody :: ${response.body} ");
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "success") {
        walletAmount.value = responseBody['data']['amount'].toString();
      } else if (response.statusCode == 200 && responseBody['success'] == "Failed") {
      } else {
        ShowToastDialog.showToast('Something want wrong. Please try again later');
        throw Exception('Failed to load album');
      }
    } on TimeoutException catch (e) {
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }

  Future<dynamic> getParcelDetailsData(String id) async {
    try {
      final response = await http.get(Uri.parse("${API.getParcelDetails}?parcel_id=$id"), headers: API.header);
      log("Parcel Details:  ${response.body}");

      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "success") {
        ParcelDetailsModel parcelDetailsModel = ParcelDetailsModel.fromJson(responseBody);

        subTotalAmount.value = double.parse(parcelDetailsModel.rideDetailsdata!.amount.toString());
        tipAmount.value = double.parse(parcelDetailsModel.rideDetailsdata!.tip.toString());
        discountAmount.value = double.parse(parcelDetailsModel.rideDetailsdata!.discount.toString());
        for (var i = 0; i < parcelDetailsModel.rideDetailsdata!.taxModel!.length; i++) {
          if (parcelDetailsModel.rideDetailsdata!.taxModel![i].statut! == 'yes') {
            if (parcelDetailsModel.rideDetailsdata!.taxModel![i].type == "Fixed") {
              taxAmount.value += double.parse(parcelDetailsModel.rideDetailsdata!.taxModel![i].value.toString());
            } else {
              taxAmount.value += ((subTotalAmount.value - discountAmount.value) * double.parse(parcelDetailsModel.rideDetailsdata!.taxModel![i].value!.toString())) / 100;
            }
          }
        }
      } else if (response.statusCode == 200 && responseBody['success'] == "Failed") {
      } else {
        ShowToastDialog.showToast('Something want wrong. Please try again later');
        throw Exception('Failed to load album');
      }
    } catch (e) {
      ShowToastDialog.closeLoader();
    }
    return null;
  }

  double calculateTax({TaxModel? taxModel}) {
    double tax = 0.0;
    if (taxModel != null && taxModel.statut == 'yes') {
      if (taxModel.type.toString() == "Fixed") {
        tax = double.parse(taxModel.value.toString());
      } else {
        tax = ((subTotalAmount.value - discountAmount.value) * double.parse(taxModel.value!.toString())) / 100;
      }
    }
    return tax;
  }

  double getTotalAmount() {
    // if (Constant.taxType == "Percentage") {
    //   taxAmount.value = Constant.taxValue != 0
    //       ? (subTotalAmount.value - discountAmount.value) *
    //           double.parse(Constant.taxValue.toString()) /
    //           100
    //       : 0.0;
    // } else {
    //   taxAmount.value = Constant.taxValue != 0
    //       ? double.parse(Constant.taxValue.toString())
    //       : 0.0;
    // }
    // if (paymentSettingModel.value.tax!.taxType == "percentage") {
    //   taxAmount.value = paymentSettingModel.value.tax!.taxAmount != null
    //       ? (subTotalAmount.value - discountAmount.value) *
    //           double.parse(
    //               paymentSettingModel.value.tax!.taxAmount.toString()) /
    //           100
    //       : 0.0;
    // } else {
    //   taxAmount.value = paymentSettingModel.value.tax!.taxAmount != null
    //       ? double.parse(paymentSettingModel.value.tax!.taxAmount.toString())
    //       : 0.0;
    // }

    return (subTotalAmount.value - discountAmount.value) + tipAmount.value + taxAmount.value;
  }

  UserModel? userModel;

  getUsrData() {
    userModel = Constant.getUserData();
  }

  var isLoading = true.obs;
  RxString selectedRadioTile = "".obs;
  RxString paymentMethodId = "".obs;

  Future<dynamic> walletDebitAmountRequest(Map<String, dynamic> bodyParams) async {
    try {
      ShowToastDialog.showLoader("Please wait");

      final response = await http.post(Uri.parse(API.parcelPayByWallet), headers: API.header, body: jsonEncode(bodyParams));
      showLog("API :: URL :: ${API.parcelPayByWallet}");
      showLog("API :: Request Body :: ${jsonEncode(bodyParams)} ");
      showLog("API :: Request Header :: ${API.header.toString()} ");
      showLog("API :: responseStatus :: ${response.statusCode} ");
      showLog("API :: responseBody :: ${response.body} ");
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "Success") {
        ShowToastDialog.closeLoader();
        return responseBody;
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
    }
    ShowToastDialog.closeLoader();
    return null;
  }

  Future<dynamic> cashPaymentRequest(Map<String, dynamic> bodyParams) async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.post(Uri.parse(API.parcelPayByCase), headers: API.header, body: jsonEncode(bodyParams));
      showLog("API :: URL :: ${API.parcelPayByCase}");
      showLog("API :: Request Body :: ${jsonEncode(bodyParams)} ");
      showLog("API :: Request Header :: ${API.header.toString()} ");
      showLog("API :: responseStatus :: ${response.statusCode} ");
      showLog("API :: responseBody :: ${response.body} ");
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'].toString().toLowerCase() == "Success".toString().toLowerCase()) {
        // transactionAmountRequest();
        ShowToastDialog.closeLoader();
        return responseBody;
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
    }
    ShowToastDialog.closeLoader();
    return null;
  }

  Future<dynamic> transactionAmountRequest() async {
    List taxList = [];

    for (var v in Constant.taxList) {
      taxList.add(v.toJson());
    }
    Map<String, dynamic> bodyParams = {
      'id_parcel': data.value.id.toString(),
      'id_driver': data.value.idConducteur.toString(),
      'amount': subTotalAmount.value.toString(),
      'paymethod': selectedRadioTile.value,
      'discount': discountAmount.value.toString(),
      'tax': taxList,
      'tip': tipAmount.value.toString(),
    };

    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.post(Uri.parse(API.parcelPaymentRequest), headers: API.header, body: jsonEncode(bodyParams));
      showLog("API :: URL :: ${API.parcelPaymentRequest}");
      showLog("API :: Request Body :: ${jsonEncode(bodyParams)} ");
      showLog("API :: Request Header :: ${API.header.toString()} ");
      showLog("API :: responseStatus :: ${response.statusCode} ");
      showLog("API :: responseBody :: ${response.body} ");
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "Success") {
        ShowToastDialog.closeLoader();
        return responseBody;
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
    }
    ShowToastDialog.closeLoader();
    return null;
  }

  Future<dynamic> rejectParcel(Map<String, String> bodyParams) async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.post(Uri.parse(API.parcelCanceled), headers: API.header, body: jsonEncode(bodyParams));
      showLog("API :: URL :: ${API.parcelCanceled}");
      showLog("API :: Request Body :: ${jsonEncode(bodyParams)} ");
      showLog("API :: Request Header :: ${API.header.toString()} ");
      showLog("API :: responseStatus :: ${response.statusCode} ");
      showLog("API :: responseBody :: ${response.body} ");
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "success") {
        ShowToastDialog.closeLoader();
        return responseBody;
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
    }
    ShowToastDialog.closeLoader();
    return null;
  }

  Future<dynamic> canceledParcel(Map<String, String> bodyParams) async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.post(Uri.parse(API.parcelReject), headers: API.header, body: jsonEncode(bodyParams));
      showLog("API :: URL :: ${API.parcelReject}");
      showLog("API :: Request Body :: ${jsonEncode(bodyParams)} ");
      showLog("API :: Request Header :: ${API.header.toString()} ");
      showLog("API :: responseStatus :: ${response.statusCode} ");
      showLog("API :: responseBody :: ${response.body} ");
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "success") {
        ShowToastDialog.closeLoader();
        return responseBody;
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
    }
    ShowToastDialog.closeLoader();
    return null;
  }
}
