import 'package:cabme/constant/constant.dart';
import 'package:cabme/constant/show_toast_dialog.dart';
import 'package:cabme/controller/parcel_service_controller.dart';
import 'package:cabme/themes/appbar_cust.dart';
import 'package:cabme/themes/button_them.dart';
import 'package:cabme/themes/constant_colors.dart';
import 'package:cabme/themes/radio_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cabme/utils/dark_theme_provider.dart';
import 'package:provider/provider.dart';

class ParcelPaymentScreen extends StatelessWidget {
  const ParcelPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    bool isDarkMode = themeChange.getThem();

    return GetX<ParcelServiceController>(
        init: ParcelServiceController(),
        builder: (controller) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: CustomAppbar(
              bgColor: AppThemeData.primary200,
              title: 'Select Payment Method'.tr,
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
                        flex: 8,
                        child: Container(
                          color: isDarkMode ? AppThemeData.surface50Dark : AppThemeData.surface50,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: isDarkMode ? AppThemeData.surface50Dark : AppThemeData.surface50,
                                  border: Border.all(
                                    color: isDarkMode ? AppThemeData.grey300Dark : AppThemeData.grey300,
                                  )),
                              child: Column(
                                children: [
                                  RadioButtonCustom(
                                    image: "assets/icons/cash.png",
                                    name: "Cash",
                                    groupValue: controller.paymentMethodType.value,
                                    isEnabled: controller.paymentSettingModel.value.cash!.isEnabled == "true" ? true : false,
                                    isSelected: controller.cash.value,
                                    onClick: (String? value) {
                                      controller.stripe = false.obs;
                                      controller.wallet = false.obs;
                                      controller.cash = true.obs;
                                      controller.razorPay = false.obs;

                                      controller.paypal = false.obs;
                                      controller.payStack = false.obs;
                                      controller.flutterWave = false.obs;
                                      controller.mercadoPago = false.obs;
                                      controller.payFast = false.obs;
                                      controller.xendit = false.obs;
                                      controller.midtrans = false.obs;
                                      controller.orangePay = false.obs;
                                      controller.paymentMethodType.value = value!;
                                      controller.paymentMethodId.value = controller.paymentSettingModel.value.cash!.idPaymentMethod.toString();
                                    },
                                  ),
                                  RadioButtonCustom(
                                    subName: Constant().amountShow(amount: controller.walletAmount.value),
                                    image: "assets/icons/walltet_icons.png",
                                    name: "Wallet",
                                    groupValue: controller.paymentMethodType.value,
                                    isEnabled: controller.paymentSettingModel.value.myWallet!.isEnabled == "true" ? true : false,
                                    isSelected: controller.wallet.value,
                                    onClick: (String? value) {
                                      controller.stripe = false.obs;
                                      controller.cash = false.obs;
                                      controller.razorPay = false.obs;

                                      controller.paypal = false.obs;
                                      controller.payStack = false.obs;
                                      controller.flutterWave = false.obs;
                                      controller.mercadoPago = false.obs;
                                      controller.payFast = false.obs;
                                      controller.xendit = false.obs;
                                      controller.midtrans = false.obs;
                                      controller.orangePay = false.obs;
                                      controller.wallet = true.obs;
                                      controller.paymentMethodType.value = value!;
                                      controller.paymentMethodId = controller.paymentSettingModel.value.myWallet!.idPaymentMethod.toString().obs;
                                    },
                                  ),
                                  RadioButtonCustom(
                                    image: "assets/icons/stripe.png",
                                    name: 'Stripe',
                                    groupValue: controller.paymentMethodType.value,
                                    isEnabled: controller.paymentSettingModel.value.strip!.isEnabled == "true" ? true : false,
                                    isSelected: controller.stripe.value,
                                    onClick: (String? value) {
                                      controller.stripe = true.obs;
                                      controller.wallet = false.obs;
                                      controller.cash = false.obs;
                                      controller.razorPay = false.obs;

                                      controller.paypal = false.obs;
                                      controller.payStack = false.obs;
                                      controller.flutterWave = false.obs;
                                      controller.mercadoPago = false.obs;
                                      controller.payFast = false.obs;
                                      controller.xendit = false.obs;
                                      controller.midtrans = false.obs;
                                      controller.orangePay = false.obs;
                                      controller.paymentMethodType.value = value!;
                                      controller.paymentMethodId.value = controller.paymentSettingModel.value.strip!.idPaymentMethod.toString();
                                    },
                                  ),
                                  RadioButtonCustom(
                                    isEnabled: controller.paymentSettingModel.value.payStack!.isEnabled == "true" ? true : false,
                                    name: 'PayStack',
                                    image: "assets/icons/paystack.png",
                                    isSelected: controller.payStack.value,
                                    groupValue: controller.paymentMethodType.value,
                                    onClick: (String? value) {
                                      controller.stripe = false.obs;
                                      controller.wallet = false.obs;
                                      controller.cash = false.obs;
                                      controller.razorPay = false.obs;

                                      controller.paypal = false.obs;
                                      controller.payStack = true.obs;
                                      controller.flutterWave = false.obs;
                                      controller.mercadoPago = false.obs;
                                      controller.payFast = false.obs;
                                      controller.xendit = false.obs;
                                      controller.midtrans = false.obs;
                                      controller.orangePay = false.obs;
                                      controller.paymentMethodType.value = value!;
                                      controller.paymentMethodId.value = controller.paymentSettingModel.value.payStack!.idPaymentMethod.toString();
                                    },
                                  ),
                                  RadioButtonCustom(
                                    isEnabled: controller.paymentSettingModel.value.flutterWave!.isEnabled == "true" ? true : false,
                                    name: 'FlutterWave',
                                    image: "assets/icons/flutterwave.png",
                                    isSelected: controller.flutterWave.value,
                                    groupValue: controller.paymentMethodType.value,
                                    onClick: (String? value) {
                                      controller.stripe = false.obs;
                                      controller.wallet = false.obs;
                                      controller.cash = false.obs;
                                      controller.razorPay = false.obs;

                                      controller.paypal = false.obs;
                                      controller.payStack = false.obs;
                                      controller.flutterWave = true.obs;
                                      controller.mercadoPago = false.obs;
                                      controller.payFast = false.obs;
                                      controller.xendit = false.obs;
                                      controller.midtrans = false.obs;
                                      controller.orangePay = false.obs;
                                      controller.paymentMethodType.value = value!;
                                      controller.paymentMethodId.value = controller.paymentSettingModel.value.flutterWave!.idPaymentMethod.toString();
                                    },
                                  ),
                                  RadioButtonCustom(
                                    isEnabled: controller.paymentSettingModel.value.razorpay!.isEnabled == "true" ? true : false,
                                    name: 'RazorPay',
                                    image: "assets/icons/razorpay_@3x.png",
                                    isSelected: controller.razorPay.value,
                                    groupValue: controller.paymentMethodType.value,
                                    onClick: (String? value) {
                                      controller.stripe = false.obs;
                                      controller.wallet = false.obs;
                                      controller.cash = false.obs;
                                      controller.razorPay = true.obs;

                                      controller.paypal = false.obs;
                                      controller.payStack = false.obs;
                                      controller.flutterWave = false.obs;
                                      controller.mercadoPago = false.obs;
                                      controller.payFast = false.obs;
                                      controller.xendit = false.obs;
                                      controller.midtrans = false.obs;
                                      controller.orangePay = false.obs;
                                      controller.paymentMethodType.value = value!;
                                      controller.paymentMethodId.value = controller.paymentSettingModel.value.razorpay!.idPaymentMethod.toString();
                                    },
                                  ),
                                  RadioButtonCustom(
                                    isEnabled: controller.paymentSettingModel.value.payFast!.isEnabled == "true" ? true : false,
                                    name: 'PayFast',
                                    image: "assets/icons/payfast.png",
                                    isSelected: controller.payFast.value,
                                    groupValue: controller.paymentMethodType.value,
                                    onClick: (String? value) {
                                      controller.stripe = false.obs;
                                      controller.wallet = false.obs;
                                      controller.cash = false.obs;
                                      controller.razorPay = false.obs;

                                      controller.paypal = false.obs;
                                      controller.payStack = false.obs;
                                      controller.flutterWave = false.obs;
                                      controller.mercadoPago = false.obs;
                                      controller.payFast = true.obs;
                                      controller.xendit = false.obs;
                                      controller.midtrans = false.obs;
                                      controller.orangePay = false.obs;
                                      controller.paymentMethodType.value = value!;
                                      controller.paymentMethodId.value = controller.paymentSettingModel.value.payFast!.idPaymentMethod.toString();
                                    },
                                  ),
                                  RadioButtonCustom(
                                    isEnabled: controller.paymentSettingModel.value.mercadopago!.isEnabled == "true" ? true : false,
                                    name: 'MercadoPago',
                                    image: "assets/icons/mercadopago.png",
                                    isSelected: controller.mercadoPago.value,
                                    groupValue: controller.paymentMethodType.value,
                                    onClick: (String? value) {
                                      controller.stripe = false.obs;
                                      controller.wallet = false.obs;
                                      controller.cash = false.obs;
                                      controller.razorPay = false.obs;

                                      controller.paypal = false.obs;
                                      controller.payStack = false.obs;
                                      controller.flutterWave = false.obs;
                                      controller.mercadoPago = true.obs;
                                      controller.payFast = false.obs;
                                      controller.xendit = false.obs;
                                      controller.midtrans = false.obs;
                                      controller.orangePay = false.obs;
                                      controller.paymentMethodType.value = value!;
                                      controller.paymentMethodId.value = controller.paymentSettingModel.value.mercadopago!.idPaymentMethod.toString();
                                    },
                                  ),
                                  RadioButtonCustom(
                                    isEnabled: controller.paymentSettingModel.value.payPal!.isEnabled == "true" ? true : false,
                                    name: 'PayPal',
                                    image: "assets/icons/paypal_@3x.png",
                                    isSelected: controller.paypal.value,
                                    groupValue: controller.paymentMethodType.value,
                                    onClick: (String? value) {
                                      controller.stripe = false.obs;
                                      controller.wallet = false.obs;
                                      controller.cash = false.obs;
                                      controller.razorPay = false.obs;

                                      controller.paypal = true.obs;
                                      controller.payStack = false.obs;
                                      controller.flutterWave = false.obs;
                                      controller.mercadoPago = false.obs;
                                      controller.payFast = false.obs;
                                      controller.xendit = false.obs;
                                      controller.midtrans = false.obs;
                                      controller.orangePay = false.obs;
                                      controller.paymentMethodType.value = value!;
                                      controller.paymentMethodId.value = controller.paymentSettingModel.value.payPal!.idPaymentMethod.toString();
                                    },
                                  ),
                                  RadioButtonCustom(
                                    isEnabled: controller.paymentSettingModel.value.xendit!.isEnabled == "true" ? true : false,
                                    name: 'Xendit',
                                    image: "assets/icons/xendit.png",
                                    isSelected: controller.xendit.value,
                                    groupValue: controller.paymentMethodType.value,
                                    onClick: (String? value) {
                                      controller.stripe = false.obs;
                                      controller.wallet = false.obs;
                                      controller.cash = false.obs;
                                      controller.razorPay = false.obs;

                                      controller.paypal = false.obs;
                                      controller.payStack = false.obs;
                                      controller.flutterWave = false.obs;
                                      controller.mercadoPago = false.obs;
                                      controller.payFast = false.obs;
                                      controller.xendit = true.obs;
                                      controller.midtrans = false.obs;
                                      controller.orangePay = false.obs;
                                      controller.paymentMethodType.value = value!;
                                      controller.paymentMethodId.value = controller.paymentSettingModel.value.xendit!.idPaymentMethod.toString();
                                    },
                                  ),
                                  RadioButtonCustom(
                                    isEnabled: controller.paymentSettingModel.value.orangePay!.isEnabled == "true" ? true : false,
                                    name: 'Orange Pay',
                                    image: "assets/icons/orangeMoney.png",
                                    isSelected: controller.orangePay.value,
                                    groupValue: controller.paymentMethodType.value,
                                    onClick: (String? value) {
                                      controller.stripe = false.obs;
                                      controller.wallet = false.obs;
                                      controller.cash = false.obs;
                                      controller.razorPay = false.obs;

                                      controller.paypal = false.obs;
                                      controller.payStack = false.obs;
                                      controller.flutterWave = false.obs;
                                      controller.mercadoPago = false.obs;
                                      controller.payFast = false.obs;
                                      controller.xendit = false.obs;
                                      controller.midtrans = false.obs;
                                      controller.orangePay = true.obs;
                                      controller.paymentMethodType.value = value!;
                                      controller.paymentMethodId.value = controller.paymentSettingModel.value.orangePay!.idPaymentMethod.toString();
                                    },
                                  ),
                                  RadioButtonCustom(
                                    isEnabled: controller.paymentSettingModel.value.midtrans!.isEnabled == "true" ? true : false,
                                    name: 'Midtrans',
                                    image: "assets/icons/midtrans.png",
                                    isSelected: controller.midtrans.value,
                                    groupValue: controller.paymentMethodType.value,
                                    onClick: (String? value) {
                                      controller.stripe = false.obs;
                                      controller.wallet = false.obs;
                                      controller.cash = false.obs;
                                      controller.razorPay = false.obs;

                                      controller.paypal = false.obs;
                                      controller.payStack = false.obs;
                                      controller.flutterWave = false.obs;
                                      controller.mercadoPago = false.obs;
                                      controller.payFast = false.obs;
                                      controller.xendit = false.obs;
                                      controller.midtrans = true.obs;
                                      controller.orangePay = false.obs;
                                      controller.paymentMethodType.value = value!;
                                      controller.paymentMethodId.value = controller.paymentSettingModel.value.midtrans!.idPaymentMethod.toString();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: ButtonThem.buildButton(
                        context,
                        title: "Pay".tr + " ${Constant().amountShow(amount: '${controller.subTotal.value}')}".tr,
                        btnColor: AppThemeData.primary200,
                        onPress: () {
                          if (controller.paymentMethodId.isEmpty) {
                            ShowToastDialog.showToast("Select Payment Option");
                          } else {
                            controller.bookParcel(null);
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
