import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cabme/constant/logdata.dart';
import 'package:cabme/constant/show_toast_dialog.dart';
import 'package:cabme/model/parcel_model.dart';
import 'package:cabme/model/ride_model.dart';
import 'package:cabme/service/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AddComplaintController extends GetxController {
  TextEditingController complaintDiscriptionController = TextEditingController();
  TextEditingController complaintTitleController = TextEditingController();
  RxString complaintStatus = "".obs;
  @override
  void onInit() {
    getArgument();

    super.onInit();
  }

  var rideData = RideData().obs;
  var parcelData = ParcelData().obs;
  RxString rideType = "ride".obs;

  getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      rideType.value = argumentData["ride_type"];
      if (argumentData['ride_type'].toString() == "ride") {
        rideData.value = argumentData["data"];
      } else {
        parcelData.value = argumentData["data"];
      }
    }
    await getComplaint();
    update();
  }

  Future<bool?> addComplaint(Map<String, String> bodyParams) async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.post(Uri.parse(API.addComplaint), headers: API.header, body: jsonEncode(bodyParams));
      Map<String, dynamic> responseBody = json.decode(response.body);
      showLog("API :: URL :: ${API.addComplaint} ");
      showLog("API :: Request Body :: ${bodyParams.toString()} ");
      showLog("API :: Request Header :: ${API.header.toString()} ");
      showLog("API :: responseStatus :: ${response.statusCode} ");
      showLog("API :: responseBody :: ${response.body} ");
      if (response.statusCode == 200 && responseBody['success'] == "success") {
        ShowToastDialog.closeLoader();
        return true;
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

  Future getComplaint() async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.get(
        Uri.parse("${API.getComplaint}?ride_type=${rideType.value}&order_id=${rideType.value == "ride" ? rideData.value.id : parcelData.value.id}&user_type=customer"),
        headers: API.header,
      );

      print("=====${response.body}");
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "success") {
        complaintTitleController.text = responseBody['data'][0]['title'].toString();
        complaintDiscriptionController.text = responseBody['data'][0]['description'].toString();
        complaintStatus.value = responseBody['data'][0]['status'].toString();
        ShowToastDialog.closeLoader();
        return true;
      } else if (response.statusCode == 200 && responseBody['success'] == "Failed") {
        ShowToastDialog.closeLoader();
        // ShowToastDialog.showToast(responseBody['error']);
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
