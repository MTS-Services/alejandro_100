import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cabme/constant/constant.dart';
import 'package:cabme/constant/logdata.dart';
import 'package:cabme/constant/show_toast_dialog.dart';
import 'package:cabme/model/user_model.dart';
import 'package:cabme/service/api.dart';
import 'package:cabme/utils/Preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class MyProfileController extends GetxController {
  RxString userCat = "".obs;
  RxString photoPath = "".obs;
  RxString userId = ''.obs;
  Rx<XFile> imageData = XFile('').obs;

  var fullNameController = TextEditingController().obs;
  var lastNameController = TextEditingController().obs;
  var emailController = TextEditingController().obs;
  var phoneController = TextEditingController().obs;
  var countryCode = TextEditingController().obs;

  @override
  void onInit() {
    getUsrData();
    super.onInit();
  }

  getUsrData() async {
    UserModel userModel = Constant.getUserData();
    fullNameController.value.text = userModel.data!.prenom!;
    lastNameController.value.text = userModel.data!.nom!;
    emailController.value.text = userModel.data!.email!;
    phoneController.value.text = userModel.data!.phone!;
    userCat.value = userModel.data!.userCat!;
    photoPath.value = userModel.data!.photoPath!;
    countryCode.value.text = userModel.data!.country!;
    userId.value = userModel.data!.id.toString();

    log("PhoneNumber :: ${userModel.toJson().toString()}");
  }

  Future<dynamic> uploadPhoto(File image) async {
    try {
      ShowToastDialog.showLoader("Please wait");

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(API.uploadUserPhoto),
      );
      request.headers.addAll(API.header);

      request.files.add(http.MultipartFile.fromBytes('image', image.readAsBytesSync(), filename: image.path.split('/').last));
      request.fields['id_user'] = Preferences.getInt(Preferences.userId).toString();
      request.fields['user_cat'] = userCat.value;

      var res = await request.send();
      var responseData = await res.stream.toBytes();
      showLog("API :: URL :: ${API.uploadUserPhoto}");
      showLog("API :: Request Body :: ${jsonEncode(request.fields)} ");
      showLog("API :: Response Status :: ${res.statusCode} ");
      showLog("API :: Response Body :: ${String.fromCharCodes(responseData)} ");

      Map<String, dynamic> response = jsonDecode(String.fromCharCodes(responseData));

      if (res.statusCode == 200) {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast("Uploaded!");
        return response;
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
  }

  // Future<dynamic> updateEmail(Map<String, String> bodyParams) async {
  //   try {
  //     ShowToastDialog.showLoader("Please wait");
  //     final response = await http.post(Uri.parse(API.updateUserEmail), headers: API.header, body: jsonEncode(bodyParams));
  //     Map<String, dynamic> responseBody = json.decode(response.body);
  //
  //
  //     if (response.statusCode == 200) {
  //       ShowToastDialog.closeLoader();
  //       return responseBody;
  //     } else {
  //       ShowToastDialog.closeLoader();
  //       ShowToastDialog.showToast('Something want wrong. Please try again later');
  //       throw Exception('Failed to load album');
  //     }
  //   } on TimeoutException catch (e) {
  //     ShowToastDialog.closeLoader();
  //     ShowToastDialog.showToast(e.message.toString());
  //   } on SocketException catch (e) {
  //     ShowToastDialog.closeLoader();
  //     ShowToastDialog.showToast(e.message.toString());
  //   } on Error catch (e) {
  //     ShowToastDialog.closeLoader();
  //     ShowToastDialog.showToast(e.toString());
  //   } catch (e) {
  //     ShowToastDialog.closeLoader();
  //     ShowToastDialog.showToast(e.toString());
  //   }
  //   return null;
  // }

  Future<dynamic> updateFirstName(Map<String, String> bodyParams) async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.post(Uri.parse(API.updatePreName), headers: API.header, body: jsonEncode(bodyParams));
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200) {
        ShowToastDialog.closeLoader();
        return responseBody;
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

  Future<dynamic> updateLastName(Map<String, String> bodyParams) async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.post(Uri.parse(API.updateLastName), headers: API.header, body: jsonEncode(bodyParams));
      showLog("API :: URL :: ${API.updateLastName}");
      showLog("API :: Request Body :: ${jsonEncode(bodyParams)} ");
      showLog("API :: Response Status :: ${response.statusCode} ");
      showLog("API :: Response Body :: ${response.body} ");
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200) {
        ShowToastDialog.closeLoader();
        return responseBody;
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

  Future<dynamic> updateAddress(Map<String, String> bodyParams) async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.post(Uri.parse(API.updateAddress), headers: API.authheader, body: jsonEncode(bodyParams));
      showLog("API :: URL :: ${API.updateAddress}");
      showLog("API :: Request Body :: ${jsonEncode(bodyParams)} ");
      showLog("API :: Response Status :: ${response.statusCode} ");
      showLog("API :: Response Body :: ${response.body} ");
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200) {
        ShowToastDialog.closeLoader();
        return responseBody;
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

  Future<dynamic> updatePassword(Map<String, String> bodyParams) async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.post(Uri.parse(API.changePassword), headers: API.header, body: jsonEncode(bodyParams));
      showLog("API :: URL :: ${API.changePassword}");
      showLog("API :: Request Body :: ${jsonEncode(bodyParams)} ");
      showLog("API :: Response Status :: ${response.statusCode} ");
      showLog("API :: Response Body :: ${response.body} ");
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (responseBody['success'] == 'success') {
        ShowToastDialog.closeLoader();
        return responseBody;
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

  Future<dynamic> updateUser({File? image, required String name, required String lname, required String phoneNum, required String email, String? password}) async {
    try {
      ShowToastDialog.showLoader("Please wait");

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(API.editProfile),
      );
      request.headers.addAll(API.header);
      request.fields['nom'] = lname;
      request.fields['prenom'] = name;
      request.fields['id_user'] = Preferences.getInt(Preferences.userId).toString();
      if (image?.path.isNotEmpty == true && image?.path != '') {
        request.files.add(http.MultipartFile.fromBytes('image', image!.readAsBytesSync(), filename: image.path.split('/').last));
      }
      request.fields['email'] = email;
      request.fields['phone'] = phoneNum;
      if (password?.isNotEmpty == true && password != '') {
        request.fields['mdp'] = password!;
      }
      var res = await request.send();

      var responseData = await res.stream.toBytes();
      showLog("API :: URL :: ${API.editProfile}");
      showLog("API :: Request Body :: ${jsonEncode(request.fields)} ");
      showLog("API :: Response Status :: ${res.statusCode} ");
      showLog("API :: Response Body :: ${String.fromCharCodes(responseData)} ");
      Map<String, dynamic> response = jsonDecode(String.fromCharCodes(responseData));

      if (res.statusCode == 200) {
        UserModel userModel = UserModel.fromJson(response);
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast("Profile update successfully!");
        return userModel;
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
  }

  // Future<UserModel?> updateUser(Map<String, String> bodyParams) async {
  //   try {
  //     ShowToastDialog.showLoader("Please wait");
  //     final response = await http.post(Uri.parse(API.editProfile), headers: API.authheader, body: jsonEncode(bodyParams));
  //     Map<String, dynamic> responseBody = json.decode(response.body);
  //     log("${response.statusCode} ::Profile :: $responseBody");
  //     if (response.statusCode == 200) {
  //       ShowToastDialog.closeLoader();
  //       Preferences.setString(Preferences.accesstoken, responseBody['data']['accesstoken'].toString());
  //       Preferences.setString(Preferences.admincommission, responseBody['data']['admin_commission'].toString());
  //       API.header['accesstoken'] = Preferences.getString(Preferences.accesstoken);
  //       return UserModel.fromJson(responseBody);
  //     } else {
  //       ShowToastDialog.closeLoader();
  //       ShowToastDialog.showToast('Something want wrong. Please try again later');
  //       throw Exception('Failed to load album');
  //     }
  //   } on TimeoutException catch (e) {
  //     ShowToastDialog.closeLoader();
  //     ShowToastDialog.showToast(e.message.toString());
  //   } on SocketException catch (e) {
  //     ShowToastDialog.closeLoader();
  //     ShowToastDialog.showToast(e.message.toString());
  //   } on Error catch (e) {
  //     ShowToastDialog.closeLoader();
  //     ShowToastDialog.showToast(e.toString());
  //   } catch (e) {
  //     ShowToastDialog.closeLoader();
  //     ShowToastDialog.showToast(e.toString());
  //   }
  //   return null;
  // }

  Future<dynamic> deleteAccount(String userId) async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.get(
        Uri.parse('${API.deleteUser}$userId&user_cat=customer'),
        headers: API.header,
      );
      showLog("API :: URL :: ${API.deleteUser}$userId&user_cat=customer");
      showLog("API :: Response Status :: ${response.statusCode} ");
      showLog("API :: Response Body :: ${response.body} ");
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200) {
        ShowToastDialog.closeLoader();
        return responseBody;
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

  var currentPasswordController = TextEditingController().obs;
  var newPasswordController = TextEditingController().obs;
  var confirmPasswordController = TextEditingController().obs;
}
