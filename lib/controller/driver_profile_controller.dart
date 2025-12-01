import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cabme/constant/logdata.dart';
import 'package:cabme/constant/show_toast_dialog.dart';
import 'package:cabme/model/driver_details_model.dart';
import 'package:cabme/service/api.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class DriverProfileController extends GetxController {
  String driverId = "";
  Rx<DriverDetailsModel>? driverDetails;
  RxBool isLoading = true.obs;
  @override
  void onInit() {
    getArguments();
    super.onInit();
  }

  getArguments() async {
    dynamic data = Get.arguments;
    if (data != null) {
      showLog("=======showLog======$data");
      driverId = data['driverId'];
      await getDriverDetails();
    }
  }

  Future getDriverDetails() async {
    try {
      final response = await http.get(
          Uri.parse("${API.driverDetails}/$driverId"),
          headers: API.header);
      showLog("API :: URL :: ${API.driverDetails}/$driverId");
      showLog("API :: Request Header :: ${API.header.toString()} ");
      showLog("API :: responseStatus :: ${response.statusCode} ");
      showLog("API :: ==responseBody :: ${response.body} ");
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200) {
        driverDetails = DriverDetailsModel.fromJson(responseBody).obs;
        update();
        isLoading.value = false;
      } else {
        ShowToastDialog.showToast(
            'Something want wrong. Please try again later');
        isLoading.value = false;
        throw Exception('Failed to load album');
      }
    } on TimeoutException catch (e) {
      ShowToastDialog.showToast(e.message.toString());
      isLoading.value = false;
    } on SocketException catch (e) {
      isLoading.value = false;
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      isLoading.value = false;
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      isLoading.value = false;
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }
}
