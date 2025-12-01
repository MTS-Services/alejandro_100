import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cabme/constant/show_toast_dialog.dart';
import 'package:cabme/model/rent_vehicle_model.dart';
import 'package:cabme/service/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../constant/logdata.dart';

class RentVehicleController extends GetxController {
  var rentVehicleList = <RentVehicleData>[].obs;
  var isLoading = true.obs;
  var startDate = DateTime.now().obs;
  var endDate = DateTime.now().obs;

  @override
  void onInit() {
    getRentVehicle();
    super.onInit();
  }

  var phoneController = TextEditingController().obs;
  Future<dynamic> getRentVehicle() async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.get(Uri.parse(API.rentVehicle), headers: API.header);
      showLog("API :: URL :: ${API.rentVehicle}");
      showLog("API :: Request Header :: ${API.header.toString()} ");
      showLog("API :: responseStatus :: ${response.statusCode} ");
      showLog("API :: responseBody :: ${response.body} ");
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "success") {
        isLoading.value = false;
        RentVehicleModel model = RentVehicleModel.fromJson(responseBody);
        rentVehicleList.value = model.data!;
        ShowToastDialog.closeLoader();
      } else if (response.statusCode == 200 && responseBody['success'] == "Failed") {
        isLoading.value = false;
        ShowToastDialog.closeLoader();
      } else {
        isLoading.value = false;
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast('Something want wrong. Please try again later');
        throw Exception('Failed to load album');
      }
    } on TimeoutException catch (e) {
      isLoading.value = false;
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      log(e.toString());
      isLoading.value = false;
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      log(e.toString());
      isLoading.value = false;
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      log(e.toString());
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }

  Future<dynamic> setLocation(Map<String, dynamic> bodyParams) async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.post(Uri.parse(API.bookRide), headers: API.header, body: jsonEncode(bodyParams));
      showLog("API :: URL :: ${API.bookRide}");
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
