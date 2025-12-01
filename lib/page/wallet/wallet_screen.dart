// ignore_for_file: library_prefixes, must_be_immutable, unused_local_variable, constant_identifier_names

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as maths;
import 'package:cabme/constant/constant.dart';
import 'package:cabme/constant/show_toast_dialog.dart';
import 'package:cabme/controller/wallet_controller.dart';
import 'package:cabme/model/payStackURLModel.dart';
import 'package:cabme/model/razorpay_gen_orderid_model.dart';
import 'package:cabme/model/stripe_failed_model.dart';
import 'package:cabme/model/transaction_model.dart';
import 'package:cabme/model/user_model.dart';
import 'package:cabme/model/xenditModel.dart';
import 'package:cabme/page/wallet/midtrans_screen.dart';
import 'package:cabme/page/wallet/orangePayScreen.dart';
import 'package:cabme/page/wallet/payStackScreen.dart';
import 'package:cabme/page/wallet/wallet_sucess_screen.dart';
import 'package:cabme/page/wallet/xenditScreen.dart';
import 'package:cabme/service/api.dart';
import 'package:cabme/themes/appbar_cust.dart';
import 'package:cabme/themes/button_them.dart';
import 'package:cabme/themes/constant_colors.dart';
import 'package:cabme/themes/responsive.dart';
import 'package:cabme/themes/text_field_them.dart';
import 'package:cabme/utils/dark_theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../model/payment_setting_model.dart';
import 'MercadoPagoScreen.dart';
import 'PayFastScreen.dart';
import 'paystack_url_genrater.dart';

class WalletScreen extends StatelessWidget {
  WalletScreen({super.key});

  final walletController = Get.put(WalletController());

  final Razorpay razorPayController = Razorpay();

  static final GlobalKey<FormState> _walletFormKey = GlobalKey<FormState>();
  static final amountController = TextEditingController();

  Future<void> _refreshAPI() async {
    walletController.getAmount();
    walletController.getTransaction();
    amountController.clear();
    setRef();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<WalletController>(
      init: WalletController(),
      initState: (state) {
        _refreshAPI();
      },
      builder: (controller) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: CustomAppbar(
            title: 'My Wallet',
            bgColor: AppThemeData.primary200,
          ),
          body: Stack(
            alignment: AlignmentDirectional.topStart,
            children: [
              Container(
                color: AppThemeData.primary200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(flex: 1, child: SizedBox()),
                    Expanded(
                      flex: 9,
                      child: Container(
                        color: themeChange.getThem() ? AppThemeData.surface50Dark : AppThemeData.surface50,
                      ),
                    ),
                  ],
                ),
              ),
              SafeArea(
                child: RefreshIndicator(
                  onRefresh: () => _refreshAPI(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(16),
                          width: Responsive.width(100, context),
                          height: 110,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppThemeData.secondary200, AppThemeData.warning200],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Wallet Amount',
                                    style: TextStyle(
                                      color: AppThemeData.grey900Dark,
                                      fontSize: 14.0,
                                      fontFamily: AppThemeData.regular,
                                    ),
                                  ),
                                  Text(
                                    Constant().amountShow(amount: walletController.walletAmount.toString()),
                                    style: TextStyle(
                                      color: AppThemeData.grey900,
                                      fontSize: 36.0,
                                      fontFamily: AppThemeData.semiBold,
                                    ),
                                  ),
                                ],
                              ),
                              InkWell(
                                splashColor: Colors.transparent,
                                onTap: () {
                                  addToWalletAmount(context, themeChange.getThem());
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  color: AppThemeData.surface50,
                                  height: 45,
                                  width: Responsive.width(25, context),
                                  child: Text(
                                    'Top up',
                                    style: TextStyle(
                                      color: AppThemeData.primary200,
                                      fontSize: 14.0,
                                      fontFamily: AppThemeData.medium,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          'Transaction History',
                          style: TextStyle(
                            color: themeChange.getThem() ? AppThemeData.grey900Dark : AppThemeData.grey900,
                            fontSize: 18.0,
                            fontFamily: AppThemeData.semiBold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: controller.isLoading.value
                              ? SizedBox()
                              : controller.walletList.isEmpty
                                  ? Center(child: Constant.emptyView(context, "Transaction not found.", false))
                                  : Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                        color: themeChange.getThem() ? AppThemeData.grey300Dark : AppThemeData.grey300,
                                      )),
                                      child: ListView.builder(
                                          itemCount: controller.walletList.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return buildTransactionCard(context, controller.walletList[index]);
                                          }),
                                    ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildTransactionCard(BuildContext context, TransactionData data) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            data.deductionType.toString() == "1" ? "assets/icons/ic_down_arrow.svg" : "assets/icons/ic_up_arrow.svg",
            height: 24,
            width: 24,
            colorFilter: ColorFilter.mode(
              themeChange.getThem() ? AppThemeData.grey900Dark : AppThemeData.grey900,
              BlendMode.srcIn,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.deductionType.toString() == "1" ? "${"Wallet Top-up via".tr} ${data.paymentMethod}" : "Payment for Trip".tr,
                    style: TextStyle(
                      fontFamily: AppThemeData.medium,
                      color: themeChange.getThem() ? AppThemeData.grey900Dark : AppThemeData.grey900,
                      fontSize: 16,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      data.creer.toString(),
                      style: TextStyle(
                        fontFamily: AppThemeData.regular,
                        color: themeChange.getThem() ? AppThemeData.grey900Dark : AppThemeData.grey900,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Text(
            data.deductionType.toString() == "1" ? "+${Constant().amountShow(amount: data.amount.toString())}" : "(${"-${Constant().amountShow(amount: data.amount.toString())}"})",
            style: TextStyle(
              fontFamily: AppThemeData.medium,
              fontSize: 16,
              color: data.deductionType.toString() == "1" ? AppThemeData.success300 : AppThemeData.error200,
            ),
          )
        ],
      ),
    );
  }

  addToWalletAmount(BuildContext context, bool isDarkMode) {
    return showModalBottomSheet(
        isDismissible: true,
        isScrollControlled: true,
        elevation: 5,
        useRootNavigator: true,
        // useSafeArea: true,
        // anchorPoint: Offset(900.0, 1000.0),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        context: context,
        backgroundColor: isDarkMode ? AppThemeData.surface50Dark : AppThemeData.surface50,
        builder: (context) {
          return GetX<WalletController>(
              init: WalletController(),
              initState: (controller) {
                razorPayController.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
                razorPayController.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWaller);
                razorPayController.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
              },
              builder: (controller) {
                return SizedBox(
                  height: Get.height / 1.2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Center(
                                  child: Container(
                                      margin: const EdgeInsets.symmetric(vertical: 10),
                                      height: 8,
                                      width: 75,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        color: isDarkMode ? AppThemeData.grey300Dark : AppThemeData.grey300,
                                      )),
                                ),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Get.back();
                                      },
                                      child: Transform(
                                        alignment: Alignment.center,
                                        transform: Directionality.of(context) == TextDirection.rtl ? Matrix4.rotationY(3.14159) : Matrix4.identity(),
                                        child: SvgPicture.asset(
                                          'assets/icons/ic_left.svg',
                                          colorFilter: ColorFilter.mode(
                                            isDarkMode ? AppThemeData.grey900Dark : AppThemeData.grey900,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Text(
                                      "Top up Amount".tr,
                                      style: TextStyle(
                                        color: isDarkMode ? AppThemeData.grey900Dark : AppThemeData.grey900,
                                        fontFamily: AppThemeData.semiBold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                Form(
                                  key: _walletFormKey,
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      child: TextFieldWidget(
                                        inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                        hintText: 'Enter topup amount'.tr,
                                        controller: amountController,
                                        textInputType: TextInputType.text,
                                        prefix: IconButton(
                                            onPressed: () {},
                                            icon: Text(
                                              Constant.currency.toString(),
                                              style: TextStyle(
                                                color: isDarkMode ? AppThemeData.grey500Dark : AppThemeData.grey500,
                                                fontFamily: AppThemeData.semiBold,
                                                fontSize: 16,
                                              ),
                                            )),
                                      )),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        text: "Select Payment Option".tr,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: isDarkMode ? AppThemeData.grey900Dark : AppThemeData.grey900,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                      color: isDarkMode ? AppThemeData.grey300Dark : AppThemeData.grey300,
                                    )),
                                    child: SingleChildScrollView(
                                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                                        Visibility(
                                          visible: walletController.paymentSettingModel.value.strip!.isEnabled == "true" ? true : false,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              RadioListTile(
                                                activeColor: AppThemeData.primary200,
                                                tileColor: Colors.transparent,
                                                selectedTileColor: AppThemeData.secondary50,
                                                controlAffinity: ListTileControlAffinity.trailing,
                                                value: "Stripe",
                                                groupValue: walletController.selectedRadioTile!.value,
                                                onChanged: (String? value) {
                                                  walletController.stripe = true.obs;
                                                  walletController.razorPay = false.obs;

                                                  walletController.paypal = false.obs;
                                                  walletController.payStack = false.obs;
                                                  walletController.flutterWave = false.obs;
                                                  walletController.mercadoPago = false.obs;
                                                  walletController.payFast = false.obs;
                                                  walletController.xendit = false.obs;
                                                  walletController.orangePay = false.obs;
                                                  walletController.midtrans = false.obs;
                                                  walletController.selectedRadioTile!.value = value!;
                                                },
                                                selected: walletController.stripe.value,
                                                //selectedRadioTile == "strip" ? true : false,
                                                contentPadding: const EdgeInsets.symmetric(
                                                  horizontal: 6,
                                                ),
                                                title: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
                                                      child: FittedBox(
                                                        fit: BoxFit.cover,
                                                        child: Image.asset(
                                                          "assets/icons/stripe.png",
                                                          width: 25,
                                                          height: 25,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    Text("Stripe".tr,
                                                        style: TextStyle(
                                                          color: walletController.selectedRadioTile!.value == 'Stripe'
                                                              ? AppThemeData.grey900
                                                              : isDarkMode
                                                                  ? AppThemeData.grey900Dark
                                                                  : AppThemeData.grey900,
                                                          fontSize: 16,
                                                          fontFamily: AppThemeData.medium,
                                                        )),
                                                  ],
                                                ),
                                                //toggleable: true,
                                              ),
                                              Container(
                                                color: isDarkMode ? AppThemeData.grey300Dark : AppThemeData.grey300,
                                                height: 1,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: walletController.paymentSettingModel.value.payStack!.isEnabled == "true" ? true : false,
                                          child: Column(
                                            children: [
                                              RadioListTile(
                                                activeColor: AppThemeData.primary200,
                                                tileColor: Colors.transparent,
                                                selectedTileColor: AppThemeData.secondary50, controlAffinity: ListTileControlAffinity.trailing,

                                                value: "PayStack",
                                                groupValue: walletController.selectedRadioTile!.value,
                                                onChanged: (String? value) {
                                                  walletController.stripe = false.obs;
                                                  walletController.razorPay = false.obs;

                                                  walletController.paypal = false.obs;
                                                  walletController.payStack = true.obs;
                                                  walletController.flutterWave = false.obs;
                                                  walletController.mercadoPago = false.obs;
                                                  walletController.payFast = false.obs;
                                                  walletController.xendit = false.obs;
                                                  walletController.orangePay = false.obs;
                                                  walletController.midtrans = false.obs;
                                                  walletController.selectedRadioTile!.value = value!;
                                                },
                                                selected: walletController.payStack.value,
                                                //selectedRadioTile == "strip" ? true : false,
                                                contentPadding: const EdgeInsets.symmetric(
                                                  horizontal: 6,
                                                ),
                                                title: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
                                                      child: FittedBox(
                                                        fit: BoxFit.cover,
                                                        child: Image.asset(
                                                          "assets/icons/paystack.png",
                                                          width: 25,
                                                          height: 25,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    Text("PayStack".tr,
                                                        style: TextStyle(
                                                          color: walletController.selectedRadioTile!.value == 'PayStack'
                                                              ? AppThemeData.grey900
                                                              : isDarkMode
                                                                  ? AppThemeData.grey900Dark
                                                                  : AppThemeData.grey900,
                                                          fontSize: 16,
                                                          fontFamily: AppThemeData.medium,
                                                        )),
                                                  ],
                                                ),
                                                //toggleable: true,
                                              ),
                                              Container(
                                                color: isDarkMode ? AppThemeData.grey300Dark : AppThemeData.grey300,
                                                height: 1,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: walletController.paymentSettingModel.value.flutterWave!.isEnabled == "true" ? true : false,
                                          child: Column(
                                            children: [
                                              RadioListTile(
                                                activeColor: AppThemeData.primary200,
                                                tileColor: Colors.transparent,
                                                selectedTileColor: AppThemeData.secondary50, controlAffinity: ListTileControlAffinity.trailing,
                                                value: "FlutterWave",
                                                groupValue: walletController.selectedRadioTile!.value,
                                                onChanged: (String? value) {
                                                  walletController.stripe = false.obs;
                                                  walletController.razorPay = false.obs;

                                                  walletController.paypal = false.obs;
                                                  walletController.payStack = false.obs;
                                                  walletController.flutterWave = true.obs;
                                                  walletController.mercadoPago = false.obs;
                                                  walletController.payFast = false.obs;
                                                  walletController.xendit = false.obs;
                                                  walletController.orangePay = false.obs;
                                                  walletController.midtrans = false.obs;
                                                  walletController.selectedRadioTile!.value = value!;
                                                },
                                                selected: walletController.flutterWave.value,
                                                contentPadding: const EdgeInsets.symmetric(
                                                  horizontal: 6,
                                                ),
                                                title: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
                                                      child: FittedBox(
                                                        fit: BoxFit.cover,
                                                        child: Image.asset(
                                                          "assets/icons/flutterwave.png",
                                                          width: 25,
                                                          height: 25,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    Text("FlutterWave".tr,
                                                        style: TextStyle(
                                                          color: walletController.selectedRadioTile!.value == 'FlutterWave'
                                                              ? AppThemeData.grey900
                                                              : isDarkMode
                                                                  ? AppThemeData.grey900Dark
                                                                  : AppThemeData.grey900,
                                                          fontSize: 16,
                                                          fontFamily: AppThemeData.medium,
                                                        )),
                                                  ],
                                                ),
                                                //toggleable: true,
                                              ),
                                              Container(
                                                color: isDarkMode ? AppThemeData.grey300Dark : AppThemeData.grey300,
                                                height: 1,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: walletController.paymentSettingModel.value.razorpay!.isEnabled == "true" ? true : false,
                                          child: Column(
                                            children: [
                                              RadioListTile(
                                                activeColor: AppThemeData.primary200,
                                                tileColor: Colors.transparent,
                                                selectedTileColor: AppThemeData.secondary50, controlAffinity: ListTileControlAffinity.trailing,
                                                value: "RazorPay",
                                                groupValue: walletController.selectedRadioTile!.value,
                                                onChanged: (String? value) {
                                                  walletController.stripe = false.obs;
                                                  walletController.razorPay = true.obs;

                                                  walletController.paypal = false.obs;
                                                  walletController.payStack = false.obs;
                                                  walletController.flutterWave = false.obs;
                                                  walletController.mercadoPago = false.obs;
                                                  walletController.payFast = false.obs;
                                                  walletController.xendit = false.obs;
                                                  walletController.orangePay = false.obs;
                                                  walletController.midtrans = false.obs;
                                                  walletController.selectedRadioTile!.value = value!;
                                                },
                                                selected: walletController.razorPay.value,
                                                contentPadding: const EdgeInsets.symmetric(
                                                  horizontal: 6,
                                                ),
                                                title: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
                                                      child: FittedBox(
                                                        fit: BoxFit.cover,
                                                        child: Image.asset(
                                                          "assets/icons/razorpay_@3x.png",
                                                          width: 25,
                                                          height: 25,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    Text("RazorPay".tr,
                                                        style: TextStyle(
                                                          color: walletController.selectedRadioTile!.value == 'RazorPay'
                                                              ? AppThemeData.grey900
                                                              : isDarkMode
                                                                  ? AppThemeData.grey900Dark
                                                                  : AppThemeData.grey900,
                                                          fontSize: 16,
                                                          fontFamily: AppThemeData.medium,
                                                        ))
                                                  ],
                                                ),
                                                //toggleable: true,
                                              ),
                                              Container(
                                                color: isDarkMode ? AppThemeData.grey300Dark : AppThemeData.grey300,
                                                height: 1,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: walletController.paymentSettingModel.value.payFast!.isEnabled == "true" ? true : false,
                                          child: Column(
                                            children: [
                                              RadioListTile(
                                                activeColor: AppThemeData.primary200,
                                                tileColor: Colors.transparent,
                                                selectedTileColor: AppThemeData.secondary50,

                                                contentPadding: const EdgeInsets.symmetric(
                                                  horizontal: 6,
                                                ),
                                                controlAffinity: ListTileControlAffinity.trailing,
                                                value: "PayFast",
                                                groupValue: walletController.selectedRadioTile!.value,
                                                onChanged: (String? value) {
                                                  walletController.stripe = false.obs;
                                                  walletController.razorPay = false.obs;

                                                  walletController.paypal = false.obs;
                                                  walletController.payStack = false.obs;
                                                  walletController.flutterWave = false.obs;
                                                  walletController.mercadoPago = false.obs;
                                                  walletController.payFast = true.obs;
                                                  walletController.xendit = false.obs;
                                                  walletController.orangePay = false.obs;
                                                  walletController.midtrans = false.obs;
                                                  walletController.selectedRadioTile!.value = value!;
                                                },
                                                selected: walletController.payFast.value,
                                                //selectedRadioTile == "strip" ? true : false,
                                                title: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
                                                      child: FittedBox(
                                                        fit: BoxFit.cover,
                                                        child: Image.asset(
                                                          "assets/icons/payfast.png",
                                                          width: 25,
                                                          height: 25,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    Text(
                                                      "Pay Fast".tr,
                                                      style: TextStyle(
                                                        color: walletController.selectedRadioTile!.value == 'PayFast'
                                                            ? AppThemeData.grey900
                                                            : isDarkMode
                                                                ? AppThemeData.grey900Dark
                                                                : AppThemeData.grey900,
                                                        fontSize: 16,
                                                        fontFamily: AppThemeData.medium,
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                //toggleable: true,
                                              ),
                                              Container(
                                                color: isDarkMode ? AppThemeData.grey300Dark : AppThemeData.grey300,
                                                height: 1,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: walletController.paymentSettingModel.value.mercadopago!.isEnabled == "true" ? true : false,
                                          child: Column(
                                            children: [
                                              RadioListTile(
                                                activeColor: AppThemeData.primary200,
                                                tileColor: Colors.transparent,
                                                selectedTileColor: AppThemeData.secondary50, controlAffinity: ListTileControlAffinity.trailing,
                                                value: "MercadoPago",
                                                groupValue: walletController.selectedRadioTile!.value,
                                                onChanged: (String? value) {
                                                  walletController.stripe = false.obs;
                                                  walletController.razorPay = false.obs;

                                                  walletController.paypal = false.obs;
                                                  walletController.payStack = false.obs;
                                                  walletController.flutterWave = false.obs;
                                                  walletController.mercadoPago = true.obs;
                                                  walletController.payFast = false.obs;
                                                  walletController.xendit = false.obs;
                                                  walletController.orangePay = false.obs;
                                                  walletController.midtrans = false.obs;
                                                  walletController.selectedRadioTile!.value = value!;
                                                },
                                                selected: walletController.mercadoPago.value,
                                                contentPadding: const EdgeInsets.symmetric(
                                                  horizontal: 6,
                                                ),
                                                title: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
                                                      child: FittedBox(
                                                        fit: BoxFit.cover,
                                                        child: Image.asset(
                                                          "assets/icons/mercadopago.png",
                                                          width: 25,
                                                          height: 25,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    Text("Mercado Pago".tr,
                                                        style: TextStyle(
                                                          color: walletController.selectedRadioTile!.value == 'MercadoPago'
                                                              ? AppThemeData.grey900
                                                              : isDarkMode
                                                                  ? AppThemeData.grey900Dark
                                                                  : AppThemeData.grey900,
                                                          fontSize: 16,
                                                          fontFamily: AppThemeData.medium,
                                                        )),
                                                  ],
                                                ),
                                                //toggleable: true,
                                              ),
                                              Container(
                                                color: isDarkMode ? AppThemeData.grey300Dark : AppThemeData.grey300,
                                                height: 1,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: walletController.paymentSettingModel.value.payPal!.isEnabled == "true" ? true : false,
                                          child: Column(
                                            children: [
                                              RadioListTile(
                                                activeColor: AppThemeData.primary200,
                                                tileColor: Colors.transparent,
                                                selectedTileColor: AppThemeData.secondary50,

                                                controlAffinity: ListTileControlAffinity.trailing,
                                                value: "PayPal",
                                                groupValue: walletController.selectedRadioTile!.value,
                                                onChanged: (String? value) {
                                                  walletController.stripe = false.obs;
                                                  walletController.razorPay = false.obs;

                                                  walletController.paypal = true.obs;
                                                  walletController.payStack = false.obs;
                                                  walletController.flutterWave = false.obs;
                                                  walletController.mercadoPago = false.obs;
                                                  walletController.payFast = false.obs;
                                                  walletController.xendit = false.obs;
                                                  walletController.orangePay = false.obs;
                                                  walletController.midtrans = false.obs;
                                                  walletController.selectedRadioTile!.value = value!;
                                                },
                                                selected: walletController.paypal.value,
                                                contentPadding: const EdgeInsets.symmetric(
                                                  horizontal: 6,
                                                ),
                                                title: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
                                                      child: FittedBox(
                                                        fit: BoxFit.cover,
                                                        child: Image.asset(
                                                          "assets/icons/paypal_@3x.png",
                                                          width: 25,
                                                          height: 25,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    Text("PayPal".tr,
                                                        style: TextStyle(
                                                          color: controller.selectedRadioTile?.value == 'PayPal'
                                                              ? AppThemeData.grey900
                                                              : isDarkMode
                                                                  ? AppThemeData.grey900Dark
                                                                  : AppThemeData.grey900,
                                                          fontSize: 16,
                                                          fontFamily: AppThemeData.medium,
                                                        )),
                                                  ],
                                                ),
                                                //toggleable: true,
                                              ),
                                              Container(
                                                color: isDarkMode ? AppThemeData.grey300Dark : AppThemeData.grey300,
                                                height: 1,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: walletController.paymentSettingModel.value.xendit!.isEnabled!.toString() == "true" ? true : false,
                                          child: Column(
                                            children: [
                                              RadioListTile(
                                                activeColor: AppThemeData.primary200,
                                                tileColor: Colors.transparent,
                                                selectedTileColor: AppThemeData.secondary50,
                                                contentPadding: const EdgeInsets.symmetric(
                                                  horizontal: 6,
                                                ),
                                                controlAffinity: ListTileControlAffinity.trailing,
                                                value: "Xendit",
                                                groupValue: walletController.selectedRadioTile!.value,
                                                onChanged: (String? value) {
                                                  walletController.stripe = false.obs;
                                                  walletController.razorPay = false.obs;

                                                  walletController.paypal = false.obs;
                                                  walletController.payStack = false.obs;
                                                  walletController.flutterWave = false.obs;
                                                  walletController.mercadoPago = false.obs;
                                                  walletController.payFast = false.obs;
                                                  walletController.xendit = true.obs;
                                                  walletController.orangePay = false.obs;
                                                  walletController.midtrans = false.obs;
                                                  walletController.selectedRadioTile!.value = value!;
                                                },

                                                selected: walletController.xendit.value,
                                                title: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
                                                      child: FittedBox(
                                                        fit: BoxFit.cover,
                                                        child: Image.asset(
                                                          "assets/icons/xendit.png",
                                                          width: 25,
                                                          height: 25,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    Text(
                                                      "Xendit".tr,
                                                      style: TextStyle(
                                                        color: controller.selectedRadioTile?.value == 'Xendit'
                                                            ? AppThemeData.grey900
                                                            : isDarkMode
                                                                ? AppThemeData.grey900Dark
                                                                : AppThemeData.grey900,
                                                        fontSize: 16,
                                                        fontFamily: AppThemeData.medium,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                //toggleable: true,
                                              ),
                                              Container(
                                                color: isDarkMode ? AppThemeData.grey300Dark : AppThemeData.grey300,
                                                height: 1,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: walletController.paymentSettingModel.value.orangePay!.isEnabled!.toString() == "true" ? true : false,
                                          child: Column(
                                            children: [
                                              RadioListTile(
                                                activeColor: AppThemeData.primary200,
                                                tileColor: Colors.transparent,
                                                selectedTileColor: AppThemeData.secondary50, controlAffinity: ListTileControlAffinity.trailing,

                                                value: "Orange Pay",
                                                groupValue: walletController.selectedRadioTile!.value,
                                                onChanged: (String? value) {
                                                  walletController.stripe = false.obs;
                                                  walletController.razorPay = false.obs;

                                                  walletController.paypal = false.obs;
                                                  walletController.payStack = false.obs;
                                                  walletController.flutterWave = false.obs;
                                                  walletController.mercadoPago = false.obs;
                                                  walletController.payFast = false.obs;
                                                  walletController.xendit = false.obs;
                                                  walletController.orangePay = true.obs;
                                                  walletController.midtrans = false.obs;
                                                  walletController.selectedRadioTile!.value = value!;
                                                },
                                                contentPadding: const EdgeInsets.symmetric(
                                                  horizontal: 6,
                                                ),
                                                selected: walletController.orangePay.value,
                                                title: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
                                                      child: FittedBox(
                                                        fit: BoxFit.cover,
                                                        child: Image.asset(
                                                          "assets/icons/mercadopago.png",
                                                          width: 25,
                                                          height: 25,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    Text("Orange Pay".tr,
                                                        style: TextStyle(
                                                          color: controller.selectedRadioTile?.value == 'Orange Pay'
                                                              ? AppThemeData.grey900
                                                              : isDarkMode
                                                                  ? AppThemeData.grey900Dark
                                                                  : AppThemeData.grey900,
                                                          fontSize: 16,
                                                          fontFamily: AppThemeData.medium,
                                                        )),
                                                  ],
                                                ),
                                                //toggleable: true,
                                              ),
                                              Container(
                                                color: isDarkMode ? AppThemeData.grey300Dark : AppThemeData.grey300,
                                                height: 1,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: walletController.paymentSettingModel.value.midtrans!.isEnabled!.toString() == "true" ? true : false,
                                          child: Column(
                                            children: [
                                              RadioListTile(
                                                activeColor: AppThemeData.primary200,
                                                tileColor: Colors.transparent,
                                                selectedTileColor: AppThemeData.secondary50,
                                                contentPadding: const EdgeInsets.symmetric(
                                                  horizontal: 6,
                                                ),
                                                controlAffinity: ListTileControlAffinity.trailing,
                                                value: "Midtrans",
                                                groupValue: walletController.selectedRadioTile!.value,
                                                onChanged: (String? value) {
                                                  walletController.stripe = false.obs;
                                                  walletController.razorPay = false.obs;

                                                  walletController.paypal = false.obs;
                                                  walletController.payStack = false.obs;
                                                  walletController.flutterWave = false.obs;
                                                  walletController.mercadoPago = false.obs;
                                                  walletController.payFast = false.obs;
                                                  walletController.xendit = false.obs;
                                                  walletController.orangePay = false.obs;
                                                  walletController.midtrans = true.obs;
                                                  walletController.selectedRadioTile!.value = value!;
                                                },
                                                selected: walletController.midtrans.value,
                                                title: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
                                                      child: FittedBox(
                                                        fit: BoxFit.cover,
                                                        child: Image.asset(
                                                          "assets/icons/midtrans.png",
                                                          width: 25,
                                                          height: 25,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    Text("Midtrans".tr,
                                                        style: TextStyle(
                                                          color: controller.selectedRadioTile?.value == 'Midtrans'
                                                              ? AppThemeData.grey900
                                                              : isDarkMode
                                                                  ? AppThemeData.grey900Dark
                                                                  : AppThemeData.grey900,
                                                          fontSize: 16,
                                                          fontFamily: AppThemeData.medium,
                                                        )),
                                                  ],
                                                ),
                                                //toggleable: true,
                                              ),
                                              Container(
                                                color: isDarkMode ? AppThemeData.grey300Dark : AppThemeData.grey300,
                                                height: 1,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ]),
                                    )),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12.0,
                          ),
                          child: ButtonThem.buildButton(
                            context,
                            title: 'Add Amount'.tr,
                            onPress: () async {
                              if (amountController.text.isEmpty) {
                                ShowToastDialog.showToast("Please enter topup amount");
                              } else if (walletController.selectedRadioTile?.value == '' || walletController.selectedRadioTile?.value.isEmpty == true) {
                                ShowToastDialog.showToast("Please select payment method");
                              } else if (_walletFormKey.currentState!.validate()) {
                                Get.back();
                                showLoadingAlert(context);
                                if (walletController.selectedRadioTile!.value == "Stripe") {
                                  Stripe.publishableKey = controller.paymentSettingModel.value.strip?.key ?? '';
                                  Stripe.merchantIdentifier = 'Cabme';
                                  await Stripe.instance.applySettings();
                                  log("Stripe :: publishableKey :: ${controller.paymentSettingModel.value.strip?.clientpublishableKey ?? ''}");
                                  log("Stripe :: Secret Key ${controller.paymentSettingModel.value.strip!.secretKey ?? ''}");
                                  stripeMakePayment(amount: amountController.text);
                                } else if (walletController.selectedRadioTile!.value == "RazorPay") {
                                  startRazorpayPayment();
                                } else if (walletController.selectedRadioTile!.value == "PayPal") {
                                  paypalPaymentSheet(double.parse(amountController.text).toString(), context);
                                  // _paypalPayment();
                                } else if (walletController.selectedRadioTile!.value == "PayStack") {
                                  payStackPayment(context);
                                } else if (walletController.selectedRadioTile!.value == "FlutterWave") {
                                  flutterWaveInitiatePayment(context: context, amount: double.parse(amountController.text).toString(), user: controller.userModel.value);
                                } else if (walletController.selectedRadioTile!.value == "PayFast") {
                                  payFastPayment(context);
                                } else if (walletController.selectedRadioTile!.value == "MercadoPago") {
                                  mercadoPagoMakePayment(
                                      context: context, amount: double.parse(amountController.text).toString(), user: controller.userModel.value, controller: controller);
                                } else if (walletController.selectedRadioTile!.value == "Xendit") {
                                  xenditPayment(context, double.parse(amountController.text), walletController);
                                } else if (walletController.selectedRadioTile!.value == "Orange Pay") {
                                  orangeMakePayment(amount: double.parse(amountController.text).toStringAsFixed(2), context: context, controller: walletController);
                                } else if (walletController.selectedRadioTile!.value == "Midtrans") {
                                  midtransMakePayment(amount: amountController.text.toString(), context: context, controller: walletController);
                                } else {
                                  ShowToastDialog.showToast("Please select payment method");
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
        });
  }

  ///paypal

  paypalPaymentSheet(String amount, context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => UsePaypal(
            sandboxMode: walletController.paymentSettingModel.value.payPal!.isLive == "true" ? false : true,
            clientId: walletController.paymentSettingModel.value.payPal!.appId ?? '',
            secretKey: walletController.paymentSettingModel.value.payPal!.secretKey ?? '',
            returnURL: "com.parkme://paypalpay",
            cancelURL: "com.parkme://paypalpay",
            transactions: [
              {
                "amount": {
                  "total": amount,
                  "currency": "USD",
                  "details": {"subtotal": amount}
                },
              }
            ],
            note: "Contact us for any questions on your order.",
            onSuccess: (Map params) async {
              walletController.setAmount(amountController.text).then((value) {
                if (value != null) {
                  _refreshAPI();
                  Get.to(const WalletSuccessScreen());
                }
              });
              ShowToastDialog.showToast("Payment Successful!!");
            },
            onError: (error) {
              Get.back();
              Get.back();
              ShowToastDialog.showToast("Payment UnSuccessful!!");
            },
            onCancel: (params) {
              Get.back();
              Get.back();
              ShowToastDialog.showToast("Payment UnSuccessful!!");
            }),
      ),
    );
  }

  /// RazorPay Payment Gateway
  startRazorpayPayment() {
    try {
      walletController.createOrderRazorPay(amount: double.parse(amountController.text).round()).then((value) {
        if (value != null) {
          CreateRazorPayOrderModel result = value;
          openCheckout(
            amount: amountController.text,
            orderId: result.id,
          );
        } else {
          Get.back();
          showSnackBarAlert(
            message: "Something went wrong, please contact admin.".tr,
            color: Colors.red.shade400,
          );
        }
      });
    } catch (e) {
      Get.back();
      showSnackBarAlert(
        message: e.toString(),
        color: Colors.red.shade400,
      );
    }
  }

  void openCheckout({required amount, required orderId}) async {
    var options = {
      'key': walletController.paymentSettingModel.value.razorpay!.key,
      'amount': amount * 100,
      'name': 'Foodies',
      'order_id': orderId,
      "currency": "INR",
      'description': 'wallet Topup',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': "8888888888", 'email': "demo@demo.com"},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      razorPayController.open(options);
    } catch (e) {
      log('Error: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Get.back();
    walletController.setAmount(amountController.text).then((value) {
      if (value != null) {
        _refreshAPI();
        Get.to(const WalletSuccessScreen());
      }
    });
  }

  void _handleExternalWaller(ExternalWalletResponse response) {
    Get.back();
    showSnackBarAlert(
      message: "${"Payment Processing Via".tr}\n${response.walletName!}",
      color: Colors.blue.shade400,
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Get.back();
    showSnackBarAlert(
      message: "${"Payment Failed!!".tr}\n${jsonDecode(response.message!)['error']['description']}",
      color: Colors.red.shade400,
    );
  }

  /// Stripe Payment Gateway
  Map<String, dynamic>? paymentIntentData;

  Future<void> stripeMakePayment({required String amount}) async {
    try {
      paymentIntentData = await walletController.createStripeIntent(amount: amount);
      if (paymentIntentData!.containsKey("error")) {
        Get.back();
        showSnackBarAlert(
          message: "Something went wrong, please contact admin.".tr,
          color: Colors.red.shade400,
        );
      } else {
        await Stripe.instance
            .initPaymentSheet(
                paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntentData!['client_secret'],
              allowsDelayedPaymentMethods: false,
              googlePay: const PaymentSheetGooglePay(
                merchantCountryCode: 'US',
                testEnv: true,
                currencyCode: "USD",
              ),
              customFlow: true,
              style: ThemeMode.system,
              appearance: PaymentSheetAppearance(
                colors: PaymentSheetAppearanceColors(
                  primary: AppThemeData.primary200,
                ),
              ),
              merchantDisplayName: 'Cabme',
            ))
            .then((value) {});
        displayStripePaymentSheet();
      }
    } catch (e, s) {
      showSnackBarAlert(
        message: 'exception:$e \n$s',
        color: Colors.red,
      );
    }
  }

  displayStripePaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        Get.back();
        walletController.setAmount(amountController.text).then((value) {
          if (value != null) {
            _refreshAPI();
          }
        });
        paymentIntentData = null;
      });
    } on StripeException catch (e) {
      Get.back();
      var lo1 = jsonEncode(e);
      var lo2 = jsonDecode(lo1);
      StripePayFailedModel lom = StripePayFailedModel.fromJson(lo2);
      showSnackBarAlert(
        message: lom.error.message,
        color: Colors.green,
      );
    } catch (e) {
      Get.back();
      showSnackBarAlert(
        message: e.toString(),
        color: Colors.green,
      );
    }
  }

  ///PayStack Payment Method
  payStackPayment(BuildContext context) async {
    var secretKey = walletController.paymentSettingModel.value.payStack!.secretKey.toString();
    await walletController
        .payStackURLGen(
      amount: amountController.text,
      secretKey: secretKey,
    )
        .then((value) async {
      if (value != null) {
        PayStackUrlModel payStackModel = value;
        bool isDone = await Get.to(() => PayStackScreen(
              walletController: walletController,
              secretKey: secretKey,
              initialURl: payStackModel.data.authorizationUrl,
              amount: amountController.text,
              reference: payStackModel.data.reference,
              callBackUrl: walletController.paymentSettingModel.value.payStack!.callbackUrl.toString(),
            ));
        Get.back();

        if (isDone) {
          walletController.setAmount(amountController.text).then((value) async {
            if (value != null) {
              await _refreshAPI();
              Get.to(const WalletSuccessScreen());
            }
          });
        } else {
          showSnackBarAlert(message: "Payment UnSuccessful!!".tr, color: Colors.red);
        }
      } else {
        showSnackBarAlert(message: "Error while transaction!".tr, color: Colors.red);
      }
    });
  }

  showSnackBarAlert({required String message, Color color = Colors.green}) {
    return Get.showSnackbar(GetSnackBar(
      isDismissible: true,
      message: message,
      backgroundColor: color,
      duration: const Duration(seconds: 8),
    ));
  }

  String? _ref;

  setRef() {
    maths.Random numRef = maths.Random();
    int year = DateTime.now().year;
    int refNumber = numRef.nextInt(20000);
    if (Platform.isAndroid) {
      _ref = "AndroidRef$year$refNumber";
    } else if (Platform.isIOS) {
      _ref = "IOSRef$year$refNumber";
    }
  }

  ///FlutterWave Payment Method

  flutterWaveInitiatePayment({required BuildContext context, required String amount, required UserModel user}) async {
    final url = Uri.parse('https://api.flutterwave.com/v3/payments');
    final headers = {
      'Authorization': 'Bearer ${walletController.paymentSettingModel.value.flutterWave?.secretKey}',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      "tx_ref": walletController.ref.value,
      "amount": amount,
      "currency": "NGN",
      "redirect_url": "${API.baseUrl}payment/success",
      "payment_options": "ussd, card, barter, payattitude",
      "customer": {
        "email": user.data?.email.toString(),
        "phonenumber": user.data?.phone, // Add a real phone number
        "name": '${user.data?.prenom} ${user.data?.nom}', // Add a real customer name
      },
      "customizations": {
        "title": "Payment for Services",
        "description": "Payment for XYZ services",
      }
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      Get.to(MercadoPagoScreen(initialURl: data['data']['link']))!.then((value) async {
        if (value) {
          ShowToastDialog.showToast("Payment Successful!!");
          Get.back();
          await _refreshAPI();
          Get.to(const WalletSuccessScreen());
        } else {
          ShowToastDialog.showToast("Payment UnSuccessful!!");
          Get.back();
        }
      });
    } else {
      print('Payment initialization failed: ${response.body}');
      return null;
    }
  }

  ///payFast

  payFastPayment(context) {
    PayFast? payfast = walletController.paymentSettingModel.value.payFast;
    PayStackURLGen.getPayHTML(payFastSettingData: payfast!, amount: double.parse(amountController.text.toString()).round().toString()).then((String? value) async {
      bool isDone = await Get.to(PayFastScreen(
        htmlData: value!,
        payFastSettingData: payfast,
      ));
      if (isDone) {
        Get.back();
        walletController.setAmount(amountController.text).then((value) async {
          if (value != null) {
            await _refreshAPI();
            Get.to(const WalletSuccessScreen());
          }
        });
      } else {
        Get.back();
        showSnackBarAlert(
          message: "Payment UnSuccessful!!".tr,
          color: Colors.red,
        );
      }
    });
  }

  mercadoPagoMakePayment({required BuildContext context, required String amount, required UserModel user, required WalletController controller}) async {
    final headers = {
      'Authorization': 'Bearer ${controller.paymentSettingModel.value.mercadopago?.accesstoken ?? ''}',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      "items": [
        {
          "title": "Test",
          "description": "Test Payment",
          "quantity": 1,
          "currency_id": "BRL",
          "unit_price": double.parse(amount),
        }
      ],
      "payer": {"email": user.data?.email ?? ''},
      "back_urls": {
        "failure": "${API.baseUrl}payment/failure",
        "pending": "${API.baseUrl}payment/pending",
        "success": "${API.baseUrl}payment/success",
      },
      "auto_return": "approved" // Automatically return after payment is approved
    });

    final response = await http.post(
      Uri.parse("https://api.mercadopago.com/checkout/preferences"),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      Get.to(MercadoPagoScreen(
        initialURl: controller.paymentSettingModel.value.mercadopago?.isSandboxEnabled == "false" ? data['init_point'] : data['sandbox_init_point'],
      ))!
          .then((value) async {
        if (value) {
          Get.back();
          ShowToastDialog.showToast("Payment Successful!!");
          await _refreshAPI();
          Get.to(const WalletSuccessScreen());
        } else {
          Get.back();
          ShowToastDialog.showToast("Payment UnSuccessful!!");
        }
      });
    } else {
      log('Error creating preference: ${response.body}');
      return null;
    }
  }

  showLoadingAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircularProgressIndicator(),
              Text('Please wait!!'.tr),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Please wait!! while completing Transaction'.tr,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //XenditPayment
  xenditPayment(context, amount, WalletController controller) async {
    await createXenditInvoice(amount: amount, controller: controller).then((model) {
      if (model.id != null) {
        Get.to(() => XenditScreen(
                  initialURl: model.invoiceUrl ?? '',
                  transId: model.id ?? '',
                  apiKey: controller.paymentSettingModel.value.xendit!.key!.toString(),
                ))!
            .then((value) {
          if (value == true) {
            Get.back();
            walletController.setAmount(amountController.text).then((value) async {
              if (value != null) {
                await _refreshAPI();
                Get.to(const WalletSuccessScreen());
              }
            });
          } else {
            Get.back();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Payment Unsuccessful!!".tr),
              backgroundColor: Colors.red,
            ));
          }
        });
      }
    });
  }

  Future<XenditModel> createXenditInvoice({required var amount, required WalletController controller}) async {
    const url = 'https://api.xendit.co/v2/invoices';
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': generateBasicAuthHeader(controller.paymentSettingModel.value.xendit!.key!.toString()),
      // 'Cookie': '__cf_bm=yERkrx3xDITyFGiou0bbKY1bi7xEwovHNwxV1vCNbVc-1724155511-1.0.1.1-jekyYQmPCwY6vIJ524K0V6_CEw6O.dAwOmQnHtwmaXO_MfTrdnmZMka0KZvjukQgXu5B.K_6FJm47SGOPeWviQ',
    };

    final body = jsonEncode({
      'external_id': DateTime.now().millisecondsSinceEpoch.toString(),
      'amount': amount,
      'payer_email': 'customer@domain.com',
      'description': 'Test - VA Successful invoice payment',
      'currency': 'IDR', //IDR, PHP, THB, VND, MYR
    });

    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        XenditModel model = XenditModel.fromJson(jsonDecode(response.body));
        Get.back();
        return model;
      } else {
        Get.back();
        return XenditModel();
      }
    } catch (e) {
      Get.back();
      return XenditModel();
    }
  }

  String generateBasicAuthHeader(String apiKey) {
    String credentials = '$apiKey:';
    String base64Encoded = base64Encode(utf8.encode(credentials));
    return 'Basic $base64Encoded';
  }

//Orangepay payment
  static String accessToken = '';
  static String payToken = '';
  static String orderId = '';
  static String amount = '';

  orangeMakePayment({required String amount, required BuildContext context, required WalletController controller}) async {
    reset();

    var paymentURL = await fetchToken(context: context, orderId: DateTime.now().millisecondsSinceEpoch.toString(), amount: amount, currency: 'USD', controller: controller);

    if (paymentURL.toString() != '') {
      Get.to(() => OrangeMoneyScreen(
                initialURl: paymentURL,
                accessToken: accessToken,
                amount: amount,
                orangePay: controller.paymentSettingModel.value.orangePay!,
                orderId: orderId,
                payToken: payToken,
              ))!
          .then((value) {
        if (value == true) {
          Get.back();
          walletController.setAmount(amountController.text).then((value) async {
            if (value != null) {
              await _refreshAPI();
              Get.to(const WalletSuccessScreen());
            }
          });
        }
      });
    } else {
      Get.back();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Payment Unsuccessful!!".tr),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future fetchToken({required String orderId, required String currency, required BuildContext context, required String amount, required WalletController controller}) async {
    String apiUrl = 'https://api.orange.com/oauth/v3/token';
    Map<String, String> requestBody = {
      'grant_type': 'client_credentials',
    };

    var response = await http.post(Uri.parse(apiUrl),
        headers: <String, String>{
          'Authorization': "Basic ${controller.paymentSettingModel.value.orangePay!.key!}",
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
        body: requestBody);

    // Handle the response

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);

      accessToken = responseData['access_token'];
      // ignore: use_build_context_synchronously
      return await webpayment(context: context, amountData: amount, currency: currency, orderIdData: orderId, controller: controller);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Color(0xff635bff),
          content: Text(
            "Something went wrong, please contact admin.".tr,
            style: TextStyle(fontSize: 17),
          )));

      return '';
    }
  }

  Future webpayment(
      {required String orderIdData, required BuildContext context, required String currency, required String amountData, required WalletController controller}) async {
    orderId = orderIdData;
    amount = amountData;
    String apiUrl = controller.paymentSettingModel.value.orangePay!.isSandboxEnabled! == "true"
        ? 'https://api.orange.com/orange-money-webpay/dev/v1/webpayment'
        : 'https://api.orange.com/orange-money-webpay/cm/v1/webpayment';
    Map<String, String> requestBody = {
      "merchant_key": controller.paymentSettingModel.value.orangePay!.merchantKey ?? '',
      "currency": controller.paymentSettingModel.value.orangePay!.isSandboxEnabled == "true" ? "OUV" : currency,
      "order_id": orderId,
      "amount": amount,
      "reference": 'Y-Note Test',
      "lang": "en",
      "return_url": controller.paymentSettingModel.value.orangePay!.returnUrl!.toString(),
      "cancel_url": controller.paymentSettingModel.value.orangePay!.cancelUrl!.toString(),
      "notif_url": controller.paymentSettingModel.value.orangePay!.notifUrl!.toString(),
    };

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{'Authorization': 'Bearer $accessToken', 'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: json.encode(requestBody),
    );

    // Handle the response
    if (response.statusCode == 201) {
      Get.back();
      Map<String, dynamic> responseData = jsonDecode(response.body);
      if (responseData['message'] == 'OK') {
        payToken = responseData['pay_token'];
        return responseData['payment_url'];
      } else {
        return '';
      }
    } else {
      Get.back();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Color(0xff635bff),
          content: Text(
            "Something went wrong, please contact admin.".tr,
            style: TextStyle(fontSize: 17),
          )));
      return '';
    }
  }

  static reset() {
    accessToken = '';
    payToken = '';
    orderId = '';
    amount = '';
  }

//Midtrans payment
  midtransMakePayment({required String amount, required BuildContext context, required WalletController controller}) async {
    await createPaymentLink(amount: amount, controller: controller).then((url) {
      if (url != '') {
        Get.to(() => MidtransScreen(
                  initialURl: url,
                ))!
            .then((value) {
          if (value == true) {
            walletController.setAmount(amountController.text).then((value) async {
              if (value != null) {
                Get.back();

                await _refreshAPI();
                Get.to(const WalletSuccessScreen());
              }
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Payment Unsuccessful".tr),
              backgroundColor: Colors.red,
            ));
          }
        });
      }
    });
  }

  Future<String> createPaymentLink({required var amount, required WalletController controller}) async {
    var ordersId = DateTime.now().millisecondsSinceEpoch.toString();
    final url = Uri.parse(controller.paymentSettingModel.value.midtrans!.isSandboxEnabled!.toString() == "true"
        ? 'https://api.sandbox.midtrans.com/v1/payment-links'
        : 'https://api.midtrans.com/v1/payment-links');

    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': generateBasicAuthHeader(controller.paymentSettingModel.value.midtrans!.key!),
      },
      body: jsonEncode({
        'transaction_details': {
          'order_id': ordersId,
          'gross_amount': double.parse(amount.toString()).toInt(),
        },
        'usage_limit': 2,
        "callbacks": {"finish": "https://www.google.com?merchant_order_id=$ordersId"},
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      Get.back();
      print('Payment link created: ${responseData['payment_url']}');
      return responseData['payment_url'];
    } else {
      Get.back();
      return '';
    }
  }
}

enum PaymentOption {
  Stripe,
  PayTM,
  RazorPay,
  PayFast,
  PayStack,
  MercadoPago,
  PayPal,
  FlutterWave,
}
