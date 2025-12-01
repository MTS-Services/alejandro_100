import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cabme/constant/logdata.dart';
import 'package:cabme/constant/show_toast_dialog.dart';
import 'package:cabme/model/CoupanCodeModel.dart';
import 'package:cabme/service/api.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CouponCodeController extends GetxController {
  var isLoading = true.obs;
  var coupanCodeList = <CoupanCodeData>[].obs;

  @override
  void onInit() {
    getCoupanCodeData();
    super.onInit();
  }

  Future<dynamic> getCoupanCodeData() async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.get(Uri.parse(API.discountList), headers: API.header);
      showLog("API :: URL :: ${API.addComplaint} ");
      showLog("API :: Request Header :: ${API.header.toString()} ");
      showLog("API :: responseStatus :: ${response.statusCode} ");
      showLog("API :: responseBody :: ${response.body} ");

      Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == 200 && responseBody['success'] == "success") {
        isLoading.value = false;
        CoupanCodeModel model = CoupanCodeModel.fromJson(responseBody);
        coupanCodeList.value = model.data!;
        ShowToastDialog.closeLoader();
      } else if (response.statusCode == 200 && responseBody['success'] == "Failed") {
        coupanCodeList.clear();
        ShowToastDialog.closeLoader();
        isLoading.value = false;
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
      ShowToastDialog.closeLoader();
      isLoading.value = false;
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      isLoading.value = false;
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }
}
