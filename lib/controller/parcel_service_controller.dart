import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cabme/constant/constant.dart';
import 'package:cabme/constant/logdata.dart';
import 'package:cabme/constant/show_toast_dialog.dart';
import 'package:cabme/controller/guest_controller.dart';
import 'package:cabme/model/parcel_category_model.dart';
import 'package:cabme/model/payment_setting_model.dart';
import 'package:cabme/page/parcel_service_screen/parcel_sucess_screen.dart';
import 'package:cabme/service/api.dart';
import 'package:cabme/themes/constant_colors.dart';
import 'package:cabme/utils/Preferences.dart';
import 'package:cabme/utils/dark_theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ParcelServiceController extends GetxController {
  final GuestController guestController =
      Get.find<GuestController>(tag: 'guest');

  String title = '';

  RxList<ParcelCategoryData> parcelCategoryList = <ParcelCategoryData>[].obs;
  var isLoading = true.obs;

  Rx<ParcelCategoryData> selectedParcelCategory = ParcelCategoryData().obs;

  TextEditingController sNameController = TextEditingController();

  var sPhoneController = TextEditingController().obs;
  TextEditingController parcelWeightController = TextEditingController();
  TextEditingController parcelDimentionController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController numberOfItemsController = TextEditingController();
  TextEditingController customerDniController = TextEditingController();

  TextEditingController rNameController = TextEditingController();
  var rPhoneController = TextEditingController().obs;

  RxString senderAddress = "".obs;
  RxString receiverAddress = "".obs;
  RxString senderAddressCity = "".obs;
  RxString receiverAddressCity = "".obs;

  LatLng? senderLocation;
  LatLng? receiverLocation;

  var paymentSettingModel = PaymentSettingModel().obs;

  DateTime selectedDatePickUp = DateTime.now();
  RxString senderDate =
      "".obs; //DateFormat('yyyy-MM-dd').format(DateTime.now());

  DateTime selectedDateDeliver = DateTime.now();
  RxString receiverDate = "".obs;

  TimeOfDay selectedTimePickUp = TimeOfDay.now();
  RxString senderTime = "".obs;

  TimeOfDay selectedTimeDeliver = TimeOfDay.now();
  RxString receiverTime = "".obs;

  RxDouble distance = 0.0.obs;
  RxDouble subTotal = 0.0.obs;
  RxString duration = "".obs;

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
  RxString paymentMethodType = "Select Method".obs;
  RxString paymentMethodId = "".obs;
  List<XFile> parcelImages = [];
  RxString walletAmount = '0'.obs;
  @override
  void onInit() {
    try {
      guestController;
    } catch (e) {
      Get.put(GuestController(), tag: 'guest');
    }

    getParcelCategory();
    paymentSettingModel.value = Constant.getPaymentSetting();
    // getArgument();
    getCurrentLocation();
    super.onInit();
  }

  getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    if (Constant.selectedMapType == 'osm') {
      senderLocation = LatLng(position.latitude, position.longitude);
      receiverLocation = LatLng(position.latitude, position.longitude);
      var senderaddress = await Constant().getOSMAddressFromLatLong(position);
      senderAddress.value = senderaddress['display_name'] ?? '';
      receiverAddress.value = senderAddress.value;
      senderAddressCity.value = senderaddress['address']['city'] ??
          senderaddress['address']['village'] ??
          senderaddress['address']['state_district'] ??
          senderaddress['address']['suburb'] ??
          '';
      receiverAddressCity.value = senderAddressCity.value;
    } else {
      senderLocation = LatLng(position.latitude, position.longitude);
      receiverLocation = LatLng(position.latitude, position.longitude);
      senderAddress.value = await Constant().getAddressFromLatLong(position);
      receiverAddress.value = senderAddress.value;
      senderAddressCity.value = senderAddress.value.split(",").last.trim();
      receiverAddressCity.value = senderAddress.value.split(",").last.trim();
    }
  }

  // getArgument() async {
  //   dynamic argumentData = Get.arguments;
  //   print("========$argumentData");
  //   if (argumentData != null) {
  //     selectedCategory.value = argumentData["title"];
  //   }
  //   update();
  // }

  Future<GetParcelCategoryModel?> getParcelCategory() async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response =
          await http.get(Uri.parse(API.getParcelCategory), headers: API.header);
      showLog("API :: URL :: ${API.getParcelCategory}");
      showLog("API :: Request Header :: ${API.header.toString()} ");
      showLog("API :: responseStatus :: ${response.statusCode} ");
      showLog("API :: responseBody :: ${response.body} ");
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "success") {
        update();
        isLoading.value = false;
        GetParcelCategoryModel data =
            GetParcelCategoryModel.fromJson(responseBody);
        parcelCategoryList.value = data.data!;
        selectedParcelCategory.value = parcelCategoryList[0];
        ShowToastDialog.closeLoader();
        return GetParcelCategoryModel.fromJson(responseBody);
      } else {
        isLoading.value = false;
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(
            'Something want wrong. Please try again later');
        throw Exception('Failed to load album');
      }
    } on TimeoutException catch (e) {
      isLoading.value = false;
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      isLoading.value = false;
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      isLoading.value = false;
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      isLoading.value = false;
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }

  Future<dynamic> getDurationDistance(
      LatLng departureLatLong, LatLng destinationLatLong) async {
    ShowToastDialog.showLoader("Please wait");
    double originLat, originLong, destLat, destLong;
    originLat = departureLatLong.latitude;
    originLong = departureLatLong.longitude;
    destLat = destinationLatLong.latitude;
    destLong = destinationLatLong.longitude;

    String url = 'https://maps.googleapis.com/maps/api/distancematrix/json';
    http.Response restaurantToCustomerTime = await http.get(Uri.parse(
        '$url?units=metric&origins=$originLat,'
        '$originLong&destinations=$destLat,$destLong&key=${Constant.kGoogleApiKey}'));

    showLog("API :: URL :: ${'$url?units=metric&origins=$originLat,'
        '$originLong&destinations=$destLat,$destLong&key=${Constant.kGoogleApiKey}'}");
    showLog("API :: Request Header :: ${API.header.toString()} ");
    showLog("API :: responseStatus :: ${restaurantToCustomerTime.statusCode} ");
    showLog("API :: responseBody :: ${restaurantToCustomerTime.body} ");
    var decodedResponse = jsonDecode(restaurantToCustomerTime.body);

    if (decodedResponse['status'] == 'OK' &&
        decodedResponse['rows'].first['elements'].first['status'] == 'OK') {
      ShowToastDialog.closeLoader();
      if (decodedResponse != null) {
        if (Constant.distanceUnit == "KM") {
          distance.value = decodedResponse['rows']
                  .first['elements']
                  .first['distance']['value'] /
              1000.00;
        } else {
          distance.value = decodedResponse['rows']
                  .first['elements']
                  .first['distance']['value'] /
              1609.34;
        }

        duration.value = decodedResponse['rows']
            .first['elements']
            .first['duration']['text']
            .toString();
      }

      subTotal.value = (distance.value *
              double.parse(Constant.deliverChargeParcel.toString())) +
          (double.parse(parcelWeightController.text.toString()) *
              double.parse(Constant.parcelPerWeightCharge.toString()));
      return decodedResponse;
    }
    ShowToastDialog.closeLoader();
    return null;
  }

  Future<void> getDurationOSMDistance(
      LatLng departureLatLong, LatLng destinationLatLong) async {
    ShowToastDialog.showLoader("Please wait");
    Constant()
        .getDurationOsmDistance(departureLatLong, destinationLatLong)
        .then((value) {
      distance.value = double.parse(value['distance'].toString());
      duration.value = value['duration'].toString();
      subTotal.value = (distance.value *
              double.parse(Constant.deliverChargeParcel.toString())) +
          (double.parse(parcelWeightController.text.toString()) *
              double.parse(Constant.parcelPerWeightCharge.toString()));
      ShowToastDialog.closeLoader();
    });
  }

  Future<dynamic> bookParcel(parcelRequest) async {
    try {
      var url = API.bookParcel;
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(url),
      );
      request.headers.addAll(API.header);

      for (int i = 0; i < parcelImages.length; i++) {
        request.files.add(
          await http.MultipartFile.fromPath(
              'parcel_image[]', parcelImages[i].path),
        );
      }

      // Check if user is in guest mode
      bool isGuestUser = Preferences.getBoolean(Preferences.isGuestUser);

      if (isGuestUser) {
        // For guest users, include guest information
        request.fields['is_guest_order'] = 'true';
        request.fields['guest_fullname'] =
            guestController.guestUserData.value.fullName ?? '';
        request.fields['guest_phone'] =
            guestController.guestUserData.value.phone ?? '';
        request.fields['guest_email'] =
            guestController.guestUserData.value.email ?? '';
        request.fields['guest_id_number'] =
            guestController.guestUserData.value.idNumber ?? '';
        request.fields['guest_address'] =
            guestController.guestUserData.value.address ?? '';
      } else {
        // For regular users, include user_id
        request.fields['user_id'] =
            Preferences.getInt(Preferences.userId).toString();
      }

      request.fields['lat1'] = senderLocation!.latitude.toString();
      request.fields['lng1'] = senderLocation!.longitude.toString();
      request.fields['lat2'] = receiverLocation!.latitude.toString();
      request.fields['lng2'] = receiverLocation!.longitude.toString();

      request.fields['source_city'] = senderAddressCity.value.toString().trim();
      request.fields['destination_city'] = receiverAddressCity.value.trim();

      request.fields['distance'] = distance.value.toString();
      request.fields['distance_unit'] = Constant.distanceUnit.toString();

      request.fields['id_payment'] = paymentMethodId.value.toString();
      request.fields['source_adrs'] = senderAddress.toString().trim();

      request.fields['destination_adrs'] = receiverAddress.toString().trim();
      request.fields['sender_name'] = sNameController.text.toString().trim();
      request.fields['receiver_name'] = rNameController.text.toString().trim();
      request.fields['sender_phone'] =
          sPhoneController.value.text.trim().trim();
      request.fields['receiver_phone'] = rPhoneController.value.text.trim();
      request.fields['note'] = noteController.text.toString().trim();
      request.fields['parcel_weight'] =
          parcelWeightController.text.trim().toString();
      request.fields['parcel_dimension'] =
          parcelDimentionController.text.trim().toString();
      request.fields['number_of_items'] =
          numberOfItemsController.text.trim().toString();
      request.fields['customer_dni'] =
          customerDniController.text.trim().toString();

      request.fields['parcel_type'] = selectedParcelCategory.value.id ?? '';
      request.fields['parcel_date'] = senderDate.value.toString();
      request.fields['parcel_time'] = senderTime.value.toString();
      request.fields['receive_date'] = receiverDate.value.toString();
      request.fields['receive_time'] = receiverTime.value.toString();
      request.fields['amount'] = subTotal.value.toString();
      request.fields['duration'] = duration.value.toString();

      var res = await request.send();
      var responseData = await res.stream.toBytes();
      showLog("API :: URL :: ${API.bookParcel}");
      showLog("API :: Request Body :: ${jsonEncode(request.fields)} ");
      showLog("API :: Request Body :: ${request.files} ");
      showLog("API :: Request Header :: ${request.headers.toString()} ");
      showLog("API :: Response Status :: ${res.statusCode} ");
      showLog("API :: Response Body :: ${String.fromCharCodes(responseData)} ");

      Map<String, dynamic> response =
          jsonDecode(String.fromCharCodes(responseData));

      if (res.statusCode == 200) {
        ShowToastDialog.closeLoader();
        Get.offAll(const ParcelSuccessScreen());

        return response;
      } else {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(
            'Something want wrong. Please try again later');
        throw Exception('Failed to load album');
      }
    } catch (e) {
      ShowToastDialog.closeLoader();
      // print("-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=");
      // print("Error in bookParcel: $e");
      // showLog("Error in bookParcel: $e");

      ShowToastDialog.showToast(e.toString());
      return null;
    }
    // on TimeoutException catch (e) {
    //   ShowToastDialog.closeLoader();
    //   ShowToastDialog.showToast(e.message.toString());
    // } on SocketException catch (e) {
    //   ShowToastDialog.closeLoader();
    //   ShowToastDialog.showToast(e.message.toString());
    // } on Error catch (e) {
    //   ShowToastDialog.closeLoader();
    //   ShowToastDialog.showToast(e.toString());
    // } catch (e) {
    //   ShowToastDialog.closeLoader();
    //   ShowToastDialog.showToast(e.toString());
    // }
  }

  onCameraClick(context) {
    final action = CupertinoActionSheet(
      message: Text(
        'Add your parcel image.'.tr,
        style: const TextStyle(fontSize: 15.0),
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          isDefaultAction: false,
          onPressed: () async {
            Navigator.pop(context);
            await ImagePicker().pickMultiImage().then((value) {
              for (var element in value) {
                parcelImages.add(element);
              }
            });
          },
          child: Text('Choose image from gallery'.tr),
        ),
        CupertinoActionSheetAction(
          isDestructiveAction: false,
          onPressed: () async {
            Get.back();
            final XFile? photo =
                await ImagePicker().pickImage(source: ImageSource.camera);
            if (photo != null) {
              parcelImages.add(photo);
            }
          },
          child: Text('Take a picture'.tr),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text(
          'Cancel'.tr,
        ),
        onPressed: () {
          Get.back();
        },
      ),
    );
    showCupertinoModalPopup(context: context, builder: (context) => action);
  }

  selectDate(BuildContext context, {bool isPickUp = true}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDatePickUp,
      initialDatePickerMode: DatePickerMode.day,
      firstDate: selectedDatePickUp,
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        final themeChange = Provider.of<DarkThemeProvider>(context);
        return Theme(
          data: ThemeData(
            colorScheme: themeChange.getThem()
                ? ColorScheme.dark(
                    primary: AppThemeData.primary200,
                    secondary: AppThemeData.grey300,
                    onPrimary: AppThemeData.surface50Dark,
                    onSurface: AppThemeData.primary200,
                  )
                : ColorScheme.light(
                    primary: AppThemeData.primary200,
                    secondary: AppThemeData.grey300,
                    onPrimary: AppThemeData.surface50,
                    onSurface: AppThemeData.primary200,
                  ),
            dialogTheme: DialogThemeData(
                backgroundColor: themeChange.getThem()
                    ? AppThemeData.surface50Dark
                    : AppThemeData.surface50),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      if (isPickUp) {
        selectedDatePickUp = picked;

        senderDate.value = DateFormat('dd-MMM-yyyy').format(selectedDatePickUp);
      } else {
        selectedDateDeliver = picked;

        receiverDate.value =
            DateFormat('dd-MMM-yyyy').format(selectedDateDeliver);
      }
    }
  }

  selectTime(BuildContext context, {bool isPickUp = true}) async {
    final localizations = MaterialLocalizations.of(context);

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTimePickUp,
      builder: (BuildContext context, Widget? child) {
        final themeChange = Provider.of<DarkThemeProvider>(context);
        return Theme(
          data: ThemeData(
            colorScheme: themeChange.getThem()
                ? ColorScheme.dark(
                    primary: AppThemeData.primary200,
                    secondary: AppThemeData.grey300,
                    onPrimary: AppThemeData.surface50,
                    onSurface: AppThemeData.primary200,
                  )
                : ColorScheme.light(
                    primary: AppThemeData.primary200,
                    secondary: AppThemeData.grey300,
                    onPrimary: AppThemeData.surface50,
                    onSurface: AppThemeData.primary200,
                  ),
            dialogTheme: DialogThemeData(
                backgroundColor: themeChange.getThem()
                    ? AppThemeData.surface50Dark
                    : AppThemeData.surface50),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      if (isPickUp) {
        selectedTimePickUp = picked;
        senderTime.value = localizations.formatTimeOfDay(selectedTimePickUp);
      } else {
        selectedTimeDeliver = picked;
        receiverTime.value = localizations.formatTimeOfDay(selectedTimeDeliver);
      }
    }
  }
}
