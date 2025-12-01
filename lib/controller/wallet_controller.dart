// ignore_for_file: empty_catches

import 'dart:async';
import 'dart:convert';
import 'dart:developer' as devlo;
import 'dart:io';
import 'dart:math';
import 'package:cabme/constant/constant.dart';
import 'package:cabme/constant/logdata.dart';
import 'package:cabme/constant/show_toast_dialog.dart';
import 'package:cabme/model/payStackURLModel.dart';
import 'package:cabme/model/payment_method_model.dart';
import 'package:cabme/model/payment_setting_model.dart';
import 'package:cabme/model/razorpay_gen_orderid_model.dart';
import 'package:cabme/model/transaction_model.dart';
import 'package:cabme/model/user_model.dart';
import 'package:cabme/service/api.dart';
import 'package:cabme/utils/Preferences.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class WalletController extends GetxController {
  RxString ref = "".obs;

  RxDouble walletAmount = 0.0.obs;
  var walletList = <TransactionData>[].obs;
  var paymentMethodList = <PaymentMethodData>[].obs;

  var isLoading = true.obs;

  RxString? selectedRadioTile;

  var paymentSettingModel = PaymentSettingModel().obs;

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

  @override
  void onInit() {
    getAmount();
    getTransaction();
    setFlutterwaveRef();
    getPaymentMethod();
    selectedRadioTile = "".obs;
    paymentSettingModel.value = Constant.getPaymentSetting();
    super.onInit();
  }

  setFlutterwaveRef() {
    Random numRef = Random();
    int year = DateTime.now().year;
    int refNumber = numRef.nextInt(20000);
    if (Platform.isAndroid) {
      ref.value = "AndroidRef$year$refNumber";
    } else if (Platform.isIOS) {
      ref.value = "IOSRef$year$refNumber";
    }
  }

  Future<dynamic> getPaymentMethod() async {
    try {
      isLoading.value = true;
      ShowToastDialog.showLoader("Please wait");
      final response =
          await http.get(Uri.parse(API.getPaymentMethod), headers: API.header);
      showLog("API :: URL :: ${API.getPaymentMethod}");
      showLog("API :: Request Header :: ${API.header.toString()}");
      showLog("API :: responseStatus :: ${response.statusCode} ");
      showLog("API :: responseBody :: ${response.body} ");
      Map<String, dynamic> responseBody = json.decode(response.body);

      devlo.log(responseBody.toString());
      if (response.statusCode == 200 && responseBody['success'] == "success") {
        isLoading.value = false;
        PaymentMethodModel model = PaymentMethodModel.fromJson(responseBody);
        paymentMethodList.value = model.data!;
        ShowToastDialog.closeLoader();
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "failed") {
        paymentMethodList.clear();
        ShowToastDialog.closeLoader();
        isLoading.value = false;
      } else {
        isLoading.value = false;
        ShowToastDialog.closeLoader();
        paymentMethodList.clear();
        ShowToastDialog.showToast(
            'Something want wrong. Please try again later');
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

  Future<dynamic> getTransaction() async {
    try {
      isLoading.value = true;
      ShowToastDialog.showLoader("Please wait");
      final response = await http.get(
          Uri.parse(
              "${API.transaction}?id_user_app=${Preferences.getInt(Preferences.userId)}"),
          headers: API.header);
      showLog(
          "API :: URL :: ${API.transaction}?id_user_app=${Preferences.getInt(Preferences.userId)}");
      showLog("API :: Request Header :: ${API.header.toString()}");
      showLog("API :: responseStatus :: ${response.statusCode} ");
      showLog("API :: responseBody :: ${response.body} ");
      Map<String, dynamic> responseBody = json.decode(response.body);
      devlo.log(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "success") {
        isLoading.value = false;
        TransactionModel model = TransactionModel.fromJson(responseBody);
        walletList.value = model.data!;

        ShowToastDialog.closeLoader();
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "Failed") {
        isLoading.value = false;
        ShowToastDialog.closeLoader();
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
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }

  Rx<UserModel> userModel = UserModel().obs;
  Future<dynamic> getAmount() async {
    try {
      final response = await http.get(
          Uri.parse(
              "${API.wallet}?id_user=${Preferences.getInt(Preferences.userId)}&user_cat=user_app"),
          headers: API.header);
      showLog(
          "API :: URL :: ${API.wallet}?id_user=${Preferences.getInt(Preferences.userId)}&user_cat=user_app");
      showLog("API :: Request Header :: ${API.header.toString()}");
      showLog("API :: responseStatus :: ${response.statusCode} ");
      showLog("API :: responseBody :: ${response.body} ");
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "success") {
        userModel.value = Constant.getUserData();
        print("getAmount :: ${userModel.value.toJson()}");
        walletAmount.value = responseBody['data']['amount'] != null
            ? double.parse(responseBody['data']['amount'].toString())
            : 0;
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "failed") {
      } else {
        ShowToastDialog.showToast(
            'Something want wrong. Please try again later');
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

  Future<dynamic> setAmount(String amount) async {
    try {
      ShowToastDialog.showLoader("Please wait");
      Map<String, dynamic> bodyParams = {
        'id_user': Preferences.getInt(Preferences.userId),
        'cat_user': "user_app",
        'amount': amount,
        'transaction_id': DateTime.now().microsecondsSinceEpoch.toString(),
        'paymethod': selectedRadioTile!.value,
      };
      final response = await http.post(Uri.parse(API.amount),
          headers: API.header, body: jsonEncode(bodyParams));
      showLog("API :: URL :: ${API.amount}");
      showLog("API :: Request Body :: ${jsonEncode(bodyParams)}");
      showLog("API :: Request Header :: ${API.header.toString()}");
      showLog("API :: responseStatus :: ${response.statusCode} ");
      showLog("API :: responseBody :: ${response.body} ");
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "success") {
        ShowToastDialog.closeLoader();
        return responseBody;
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "failed") {
        ShowToastDialog.closeLoader();
      } else {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(
            'Something want wrong. Please try again later');
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

  ///razorPay
  Future<CreateRazorPayOrderModel?> createOrderRazorPay(
      {required int amount, bool isTopup = false}) async {
    final String orderId =
        "${Preferences.getInt(Preferences.userId)}_${DateTime.now().microsecondsSinceEpoch}";

    const url = "${API.baseUrl}payments/razorpay/createorder";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'apikey': API.apiKey,
          'accesstoken': Preferences.getString(Preferences.accesstoken),
        },
        body: {
          "amount": (amount * 100).toString(),
          "receipt_id": orderId,
          "currency": "INR",
          "razorpaykey": paymentSettingModel.value.razorpay!.key,
          "razorPaySecret": paymentSettingModel.value.razorpay!.secretKey,
          "isSandBoxEnabled":
              paymentSettingModel.value.razorpay!.isSandboxEnabled,
        },
      );
      showLog("API :: URL :: $url");
      showLog("API :: Request Body :: ${jsonEncode({
            "amount": (amount * 100).toString(),
            "receipt_id": orderId,
            "currency": "INR",
            "razorpaykey": paymentSettingModel.value.razorpay!.key,
            "razorPaySecret": paymentSettingModel.value.razorpay!.secretKey,
            "isSandBoxEnabled":
                paymentSettingModel.value.razorpay!.isSandboxEnabled,
          })}");
      showLog("API :: Request Header :: ${API.header.toString()}");
      showLog("API :: responseStatus :: ${response.statusCode} ");
      showLog("API :: responseBody :: ${response.body} ");
      final responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['id'] != null) {
        isLoading.value = false;
        return CreateRazorPayOrderModel.fromJson(responseBody);
      } else if (response.statusCode == 200 && responseBody['id'] == null) {
        isLoading.value = false;
      } else {
        isLoading.value = false;
        ShowToastDialog.showToast(
            'Something want wrong. Please try again later');
        throw Exception('Failed to load album');
      }
    } on TimeoutException catch (e) {
      isLoading.value = false;
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      isLoading.value = false;
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      isLoading.value = false;
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }

  ///payStack
  Future<dynamic> payStackURLGen(
      {required String amount, required secretKey}) async {
    const url = "https://api.paystack.co/transaction/initialize";

    try {
      final response = await http.post(Uri.parse(url), body: {
        "email": "demo@email.com",
        "amount": (double.parse(amount) * 100).toString(),
        "currency": "NGN",
      }, headers: {
        "Authorization": "Bearer $secretKey",
      });

      showLog("API :: URL :: $url");
      showLog("API :: Request Body :: ${jsonEncode({
            "email": "demo@email.com",
            "amount": (double.parse(amount) * 100).toString(),
            "currency": "NGN",
          })}");
      showLog("API :: Request Header :: ${{
        "Authorization": "Bearer $secretKey",
      }.toString()}");
      showLog("API :: responseStatus :: ${response.statusCode} ");
      showLog("API :: responseBody :: ${response.body} ");
      final responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['status'] == true) {
        isLoading.value = false;
        return PayStackUrlModel.fromJson(responseBody);
      } else if (response.statusCode == 200 && responseBody['status'] == null) {
        isLoading.value = false;
      } else {
        isLoading.value = false;
        ShowToastDialog.showToast(
            'Something want wrong. Please try again later');
        throw Exception('Failed to load album');
      }
    } on TimeoutException catch (e) {
      isLoading.value = false;
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      isLoading.value = false;
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      isLoading.value = false;
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }

    final response = await http.post(Uri.parse(url), body: {
      "email": "demo@email.com",
      "amount": (double.parse(amount) * 100).toString(),
      "currency": "NGN",
    }, headers: {
      "Authorization": "Bearer $secretKey",
    });
    showLog("API :: URL :: $url");
    showLog("API :: Request Body :: ${jsonEncode({
          "email": "demo@email.com",
          "amount": (double.parse(amount) * 100).toString(),
          "currency": "NGN",
        })}");
    showLog("API :: Request Header :: ${{
      "Authorization": "Bearer $secretKey",
    }.toString()}");
    showLog("API :: responseStatus :: ${response.statusCode} ");
    showLog("API :: responseBody :: ${response.body} ");
    final data = jsonDecode(response.body);

    if (!data["status"]) {
      return null;
    }
    return PayStackUrlModel.fromJson(data);
  }

  Future<bool> payStackVerifyTransaction({
    required String reference,
    required String secretKey,
    required String amount,
  }) async {
    final url = "https://api.paystack.co/transaction/verify/$reference";
    var response = await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer $secretKey",
    });
    showLog("API :: URL :: $url");
    showLog("API :: Request Header :: ${{
      "Authorization": "Bearer $secretKey",
    }.toString()}");
    showLog("API :: responseStatus :: ${response.statusCode} ");
    showLog("API :: responseBody :: ${response.body} ");
    final data = jsonDecode(response.body);
    if (data["status"] == true) {
      if (data["message"] == "Verification successful") {}
    }

    return data["status"];

    //PayPalClientSettleModel.fromJson(data);
  }

  ///Stripe
  createStripeIntent({required String amount}) async {
    try {
      Map<String, dynamic> body = {
        'amount': ((double.parse(amount) * 100).round()).toString(),
        'currency': "USD",
        'payment_method_types[]': 'card',
        "description": "Strip Payment",
        "shipping[name]":
            "${userModel.value.data?.nom ?? ''} ${userModel.value.data?.prenom ?? ''}",
        "shipping[address][line1]": "510 Townsend St",
        "shipping[address][postal_code]": "98140",
        "shipping[address][city]": "San Francisco",
        "shipping[address][state]": "CA",
        "shipping[address][country]": "US",
      };
      var stripeSecret = paymentSettingModel.value.strip!.secretKey;
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': 'Bearer $stripeSecret',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      showLog("API :: URL :: ${'https://api.stripe.com/v1/payment_intents'}");
      showLog("API :: Request Header :: ${{
        'Authorization': 'Bearer $stripeSecret',
        'Content-Type': 'application/x-www-form-urlencoded'
      }.toString()}");
      showLog("API :: responseStatus :: ${response.statusCode} ");
      showLog("API :: responseBody :: ${response.body} ");
      return jsonDecode(response.body);
    } catch (e) {}
  }
}
