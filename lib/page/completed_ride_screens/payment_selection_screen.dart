import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cabme/constant/constant.dart';
import 'package:cabme/constant/logdata.dart';
import 'package:cabme/constant/show_toast_dialog.dart';
import 'package:cabme/controller/payment_controller.dart';
import 'package:cabme/controller/wallet_controller.dart';
import 'package:cabme/model/payStackURLModel.dart';
import 'package:cabme/model/razorpay_gen_orderid_model.dart';
import 'package:cabme/model/stripe_failed_model.dart';
import 'package:cabme/model/tax_model.dart';
import 'package:cabme/model/user_model.dart';
import 'package:cabme/model/xenditModel.dart';
import 'package:cabme/page/wallet/midtrans_screen.dart';
import 'package:cabme/page/wallet/orangePayScreen.dart';
import 'package:cabme/page/wallet/payStackScreen.dart';
import 'package:cabme/page/wallet/xenditScreen.dart';
import 'package:cabme/service/api.dart';
import 'package:cabme/themes/appbar_cust.dart';
import 'package:cabme/themes/button_them.dart';
import 'package:cabme/themes/constant_colors.dart';
import 'package:cabme/themes/radio_button.dart';
import 'package:cabme/themes/text_field_them.dart';
import 'package:cabme/utils/Preferences.dart';
import 'package:cabme/utils/dark_theme_provider.dart';
import 'package:clipboard/clipboard.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe1;
import 'dart:math' as maths;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../model/payment_setting_model.dart';
import '../wallet/MercadoPagoScreen.dart';
import '../wallet/PayFastScreen.dart';
import '../wallet/paystack_url_genrater.dart';

// ignore: must_be_immutable
class PaymentSelectionScreen extends StatelessWidget {
  PaymentSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<PaymentController>(
      init: PaymentController(),
      initState: (controller) {
        razorPayController.on(
            Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
        razorPayController.on(
            Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWaller);
        razorPayController.on(
            Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
        setRef();
      },
      builder: (controller) {
        return Scaffold(
          appBar: CustomAppbar(
            bgColor: AppThemeData.primary200,
            title: 'Select Payment Method'.tr,
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: AppThemeData.primary200,
                    ),
                  ),
                  Expanded(
                      flex: 10,
                      child: Container(
                        color: themeChange.getThem()
                            ? AppThemeData.surface50Dark
                            : AppThemeData.surface50,
                      )),
                ],
              ),
              SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              buildListPromoCode(
                                  controller, themeChange.getThem()),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: themeChange.getThem()
                                      ? AppThemeData.surface50Dark
                                      : AppThemeData.surface50,
                                  border: Border.all(
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey200Dark
                                        : AppThemeData.grey200,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'assets/images/promo_code.png',
                                        width: 50,
                                        height: 50,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Promo Code".tr,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily:
                                                      AppThemeData.semiBold,
                                                  color: themeChange.getThem()
                                                      ? AppThemeData.grey900Dark
                                                      : AppThemeData.grey900,
                                                ),
                                              ),
                                              Text(
                                                "Apply promo code".tr,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily:
                                                      AppThemeData.regular,
                                                  color: themeChange.getThem()
                                                      ? AppThemeData.grey400Dark
                                                      : AppThemeData.grey500,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            // controller.couponCodeController =
                                            //     TextEditingController();
                                            showModalBottomSheet(
                                              isScrollControlled: true,
                                              isDismissible: true,
                                              context: context,
                                              backgroundColor:
                                                  Colors.transparent,
                                              enableDrag: true,
                                              builder: (BuildContext context) =>
                                                  couponCodeSheet(
                                                context,
                                                controller,
                                              ),
                                            );
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              boxShadow: <BoxShadow>[
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.2),
                                                  blurRadius: 2,
                                                  offset: const Offset(2, 2),
                                                ),
                                              ],
                                            ),
                                            child: Image.asset(
                                              'assets/images/add_payment.png',
                                              width: 36,
                                              height: 36,
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: themeChange.getThem()
                                          ? AppThemeData.surface50Dark
                                          : AppThemeData.surface50,
                                      border: Border.all(
                                        color: themeChange.getThem()
                                            ? AppThemeData.grey300Dark
                                            : AppThemeData.grey300,
                                        width: 1,
                                      )),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 16),
                                        child: Row(
                                          children: [
                                            Expanded(
                                                child: Text("Sub Total".tr,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          AppThemeData.regular,
                                                      color:
                                                          themeChange.getThem()
                                                              ? AppThemeData
                                                                  .grey900Dark
                                                              : AppThemeData
                                                                  .grey900,
                                                      fontSize: 16,
                                                    ))),
                                            Text(
                                                Constant().amountShow(
                                                    amount: controller
                                                        .data.value.montant
                                                        .toString()),
                                                style: TextStyle(
                                                  fontFamily:
                                                      AppThemeData.medium,
                                                  color: themeChange.getThem()
                                                      ? AppThemeData.grey500Dark
                                                      : AppThemeData.grey500,
                                                  fontSize: 16,
                                                )),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        color: themeChange.getThem()
                                            ? AppThemeData.grey300Dark
                                            : AppThemeData.grey300,
                                        height: 1,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 16),
                                        child: Row(
                                          children: [
                                            Expanded(
                                                child: Text("Discount".tr,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          AppThemeData.regular,
                                                      color:
                                                          themeChange.getThem()
                                                              ? AppThemeData
                                                                  .grey900Dark
                                                              : AppThemeData
                                                                  .grey900,
                                                      fontSize: 16,
                                                    ))),
                                            Text(
                                                '(-${Constant().amountShow(amount: controller.discountAmount.toString())})',
                                                style: const TextStyle(
                                                  letterSpacing: 1.0,
                                                  fontSize: 16,
                                                  color: Colors.red,
                                                  fontFamily:
                                                      AppThemeData.medium,
                                                ))
                                          ],
                                        ),
                                      ),
                                      Container(
                                        color: themeChange.getThem()
                                            ? AppThemeData.grey300Dark
                                            : AppThemeData.grey300,
                                        height: 1,
                                      ),
                                      Visibility(
                                        visible: controller
                                            .selectedPromoCode.value.isNotEmpty,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 16),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  "${"Promo Code :".tr} ${controller.selectedPromoCode.value}",
                                                  style: TextStyle(
                                                    fontFamily:
                                                        AppThemeData.regular,
                                                    color: themeChange.getThem()
                                                        ? AppThemeData
                                                            .grey900Dark
                                                        : AppThemeData.grey900,
                                                    fontSize: 16,
                                                  )),
                                              Text(
                                                  '(${controller.selectedPromoValue.value})',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        AppThemeData.medium,
                                                    color: themeChange.getThem()
                                                        ? AppThemeData
                                                            .grey500Dark
                                                        : AppThemeData.grey500,
                                                    fontSize: 16,
                                                  ))
                                            ],
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: controller
                                            .selectedPromoCode.value.isNotEmpty,
                                        child: Container(
                                          color: themeChange.getThem()
                                              ? AppThemeData.grey300Dark
                                              : AppThemeData.grey300,
                                          height: 1,
                                        ),
                                      ),
                                      ListView.builder(
                                        itemCount: Constant.taxList.length,
                                        shrinkWrap: true,
                                        padding: EdgeInsets.zero,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          TaxModel taxModel =
                                              Constant.taxList[index];
                                          return Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 16),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                        '${taxModel.libelle.toString()} (${taxModel.type == "Fixed" ? Constant().amountShow(amount: taxModel.value) : "${taxModel.value}%"})',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              AppThemeData
                                                                  .regular,
                                                          color: themeChange
                                                                  .getThem()
                                                              ? AppThemeData
                                                                  .grey900Dark
                                                              : AppThemeData
                                                                  .grey900,
                                                          fontSize: 16,
                                                        )),
                                                    Text(
                                                        Constant().amountShow(
                                                            amount: controller
                                                                .calculateTax(
                                                                    taxModel:
                                                                        taxModel)
                                                                .toString()),
                                                        style: TextStyle(
                                                          fontFamily:
                                                              AppThemeData
                                                                  .medium,
                                                          color: themeChange
                                                                  .getThem()
                                                              ? AppThemeData
                                                                  .grey500Dark
                                                              : AppThemeData
                                                                  .grey500,
                                                          fontSize: 16,
                                                        ))
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                color: themeChange.getThem()
                                                    ? AppThemeData.grey300Dark
                                                    : AppThemeData.grey300,
                                                height: 1,
                                              )
                                            ],
                                          );
                                        },
                                      ),
                                      Visibility(
                                        visible: controller.tipAmount.value == 0
                                            ? false
                                            : true,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 16),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                      child:
                                                          Text("Driver Tip".tr,
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    AppThemeData
                                                                        .regular,
                                                                color: themeChange.getThem()
                                                                    ? AppThemeData
                                                                        .grey900Dark
                                                                    : AppThemeData
                                                                        .grey900,
                                                                fontSize: 16,
                                                              ))),
                                                  Text(
                                                      Constant().amountShow(
                                                          amount: controller
                                                              .tipAmount.value
                                                              .toString()),
                                                      style: TextStyle(
                                                        fontFamily:
                                                            AppThemeData.medium,
                                                        color: themeChange
                                                                .getThem()
                                                            ? AppThemeData
                                                                .grey500Dark
                                                            : AppThemeData
                                                                .grey500,
                                                        fontSize: 16,
                                                      )),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              color: themeChange.getThem()
                                                  ? AppThemeData.grey300Dark
                                                  : AppThemeData.grey300,
                                              height: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text("Total".tr,
                                                style: TextStyle(
                                                  fontFamily:
                                                      AppThemeData.regular,
                                                  color: themeChange.getThem()
                                                      ? AppThemeData.grey900Dark
                                                      : AppThemeData.grey900,
                                                  fontSize: 16,
                                                )),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                                Constant().amountShow(
                                                    amount: controller
                                                        .getTotalAmount()
                                                        .toString()),
                                                style: TextStyle(
                                                  fontFamily:
                                                      AppThemeData.medium,
                                                  color: themeChange.getThem()
                                                      ? AppThemeData.grey500Dark
                                                      : AppThemeData.grey500,
                                                  fontSize: 16,
                                                )),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        color: themeChange.getThem()
                                            ? AppThemeData.grey300Dark
                                            : AppThemeData.grey300,
                                        height: 1,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 16),
                                        child: Column(
                                          children: [
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text("Tip to Driver".tr,
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontFamily:
                                                        AppThemeData.regular,
                                                    color: themeChange.getThem()
                                                        ? AppThemeData
                                                            .grey900Dark
                                                        : AppThemeData.grey900,
                                                    fontSize: 16,
                                                  )),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        if (controller.tipAmount
                                                                .value ==
                                                            5) {
                                                          controller.tipAmount
                                                              .value = 0;
                                                        } else {
                                                          controller.tipAmount
                                                              .value = 5;
                                                        }
                                                      },
                                                      child: Container(
                                                        height: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: controller
                                                                      .tipAmount
                                                                      .value ==
                                                                  5
                                                              ? AppThemeData
                                                                  .primary200
                                                              : Colors.white,
                                                          border: Border.all(
                                                            color: controller
                                                                        .tipAmount
                                                                        .value ==
                                                                    5
                                                                ? Colors
                                                                    .transparent
                                                                : Colors.black
                                                                    .withOpacity(
                                                                        0.20),
                                                          ),
                                                          boxShadow: <BoxShadow>[
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.3),
                                                              blurRadius: 2,
                                                              offset:
                                                                  const Offset(
                                                                      2, 2),
                                                            ),
                                                          ],
                                                        ),
                                                        child: Center(
                                                            child: Text(
                                                          Constant().amountShow(
                                                              amount: '5'),
                                                          style: TextStyle(
                                                              color: controller
                                                                          .tipAmount
                                                                          .value ==
                                                                      5
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black,
                                                              fontSize: 12),
                                                        )),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Expanded(
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        if (controller.tipAmount
                                                                .value ==
                                                            10) {
                                                          controller.tipAmount
                                                              .value = 0;
                                                        } else {
                                                          controller.tipAmount
                                                              .value = 10;
                                                        }
                                                      },
                                                      child: Container(
                                                        height: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: controller
                                                                      .tipAmount
                                                                      .value ==
                                                                  10
                                                              ? AppThemeData
                                                                  .primary200
                                                              : Colors.white,
                                                          border: Border.all(
                                                            color: controller
                                                                        .tipAmount
                                                                        .value ==
                                                                    10
                                                                ? Colors
                                                                    .transparent
                                                                : Colors.black
                                                                    .withOpacity(
                                                                        0.20),
                                                          ),
                                                          boxShadow: <BoxShadow>[
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.3),
                                                              blurRadius: 2,
                                                              offset:
                                                                  const Offset(
                                                                      2, 2),
                                                            ),
                                                          ],
                                                        ),
                                                        child: Center(
                                                            child: Text(
                                                          Constant().amountShow(
                                                              amount: '10'),
                                                          style: TextStyle(
                                                              color: controller
                                                                          .tipAmount
                                                                          .value ==
                                                                      10
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black,
                                                              fontSize: 12),
                                                        )),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Expanded(
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        if (controller.tipAmount
                                                                .value ==
                                                            15) {
                                                          controller.tipAmount
                                                              .value = 0;
                                                        } else {
                                                          controller.tipAmount
                                                              .value = 15;
                                                        }
                                                      },
                                                      child: Container(
                                                        height: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: controller
                                                                      .tipAmount
                                                                      .value ==
                                                                  15
                                                              ? AppThemeData
                                                                  .primary200
                                                              : Colors.white,
                                                          border: Border.all(
                                                            color: controller
                                                                        .tipAmount
                                                                        .value ==
                                                                    15
                                                                ? Colors
                                                                    .transparent
                                                                : Colors.black
                                                                    .withOpacity(
                                                                        0.20),
                                                          ),
                                                          boxShadow: <BoxShadow>[
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.3),
                                                              blurRadius: 2,
                                                              offset:
                                                                  const Offset(
                                                                      2, 2),
                                                            ),
                                                          ],
                                                        ),
                                                        child: Center(
                                                            child: Text(
                                                          Constant().amountShow(
                                                              amount: '15'),
                                                          style: TextStyle(
                                                              color: controller
                                                                          .tipAmount
                                                                          .value ==
                                                                      15
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black,
                                                              fontSize: 12),
                                                        )),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Expanded(
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        if (controller.tipAmount
                                                                .value ==
                                                            20) {
                                                          controller.tipAmount
                                                              .value = 0;
                                                        } else {
                                                          controller.tipAmount
                                                              .value = 20;
                                                        }
                                                      },
                                                      child: Container(
                                                        height: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: controller
                                                                      .tipAmount
                                                                      .value ==
                                                                  20
                                                              ? AppThemeData
                                                                  .primary200
                                                              : Colors.white,
                                                          border: Border.all(
                                                            color: controller
                                                                        .tipAmount
                                                                        .value ==
                                                                    20
                                                                ? Colors
                                                                    .transparent
                                                                : Colors.black
                                                                    .withOpacity(
                                                                        0.20),
                                                          ),
                                                          boxShadow: <BoxShadow>[
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.3),
                                                              blurRadius: 2,
                                                              offset:
                                                                  const Offset(
                                                                      2, 2),
                                                            ),
                                                          ],
                                                        ),
                                                        child: Center(
                                                            child: Text(
                                                          Constant().amountShow(
                                                              amount: '20'),
                                                          style: TextStyle(
                                                              color: controller
                                                                          .tipAmount
                                                                          .value ==
                                                                      20
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black,
                                                              fontSize: 12),
                                                        )),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Expanded(
                                                    child: InkWell(
                                                      onTap: () {
                                                        tipAmountBottomSheet(
                                                          context,
                                                          themeChange.getThem(),
                                                          controller,
                                                        );
                                                      },
                                                      child: Container(
                                                        height: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          border: Border.all(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.20),
                                                          ),
                                                          boxShadow: <BoxShadow>[
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.3),
                                                              blurRadius: 2,
                                                              offset:
                                                                  const Offset(
                                                                      2, 2),
                                                            ),
                                                          ],
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            "Other".tr,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Select Payment Option".tr,
                                        style: TextStyle(
                                          fontFamily: AppThemeData.medium,
                                          color: themeChange.getThem()
                                              ? AppThemeData.grey900Dark
                                              : AppThemeData.grey900,
                                          fontSize: 16,
                                        )),
                                  ]),
                              const SizedBox(height: 10),
                              Container(
                                decoration: BoxDecoration(
                                    color: themeChange.getThem()
                                        ? AppThemeData.surface50Dark
                                        : AppThemeData.surface50,
                                    border: Border.all(
                                      color: themeChange.getThem()
                                          ? AppThemeData.grey300Dark
                                          : AppThemeData.grey300,
                                    )),
                                child: Column(
                                  children: [
                                    RadioButtonCustom(
                                      image: "assets/icons/cash.png",
                                      name: "Cash",
                                      groupValue:
                                          controller.selectedRadioTile.value,
                                      isEnabled: controller.paymentSettingModel
                                                  .value.cash!.isEnabled ==
                                              "true"
                                          ? true
                                          : false,
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
                                        controller.selectedRadioTile.value =
                                            value!;
                                        controller.paymentMethodId.value =
                                            controller.paymentSettingModel.value
                                                .cash!.idPaymentMethod
                                                .toString();
                                      },
                                    ),
                                    RadioButtonCustom(
                                      subName: Constant().amountShow(
                                          amount: controller.userModel.value
                                                  .data?.amount ??
                                              '0'),
                                      image: "assets/icons/walltet_icons.png",
                                      name: "Wallet",
                                      groupValue:
                                          controller.selectedRadioTile.value,
                                      isEnabled: controller.paymentSettingModel
                                                  .value.myWallet!.isEnabled ==
                                              "true"
                                          ? true
                                          : false,
                                      isSelected: controller.wallet.value,
                                      onClick: (String? value) {
                                        controller.stripe = false.obs;
                                        if (double.parse(controller.walletAmount
                                                .toString()) >=
                                            controller.getTotalAmount()) {
                                          controller.wallet = true.obs;
                                          controller.selectedRadioTile.value =
                                              value!;
                                          controller.paymentMethodId =
                                              controller
                                                  .paymentSettingModel
                                                  .value
                                                  .myWallet!
                                                  .idPaymentMethod
                                                  .toString()
                                                  .obs;
                                        } else {
                                          controller.wallet = false.obs;
                                        }

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
                                      },
                                    ),
                                    RadioButtonCustom(
                                      image: "assets/icons/stripe.png",
                                      name: 'Stripe',
                                      groupValue:
                                          controller.selectedRadioTile.value,
                                      isEnabled: controller.paymentSettingModel
                                                  .value.strip!.isEnabled ==
                                              "true"
                                          ? true
                                          : false,
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
                                        controller.selectedRadioTile.value =
                                            value!;
                                        controller.paymentMethodId.value =
                                            controller.paymentSettingModel.value
                                                .strip!.idPaymentMethod
                                                .toString();
                                      },
                                    ),
                                    RadioButtonCustom(
                                      isEnabled: controller.paymentSettingModel
                                                  .value.payStack!.isEnabled ==
                                              "true"
                                          ? true
                                          : false,
                                      name: 'PayStack',
                                      image: "assets/icons/paystack.png",
                                      isSelected: controller.payStack.value,
                                      groupValue:
                                          controller.selectedRadioTile.value,
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
                                        controller.selectedRadioTile.value =
                                            value!;
                                        controller.paymentMethodId.value =
                                            controller.paymentSettingModel.value
                                                .payStack!.idPaymentMethod
                                                .toString();
                                      },
                                    ),
                                    RadioButtonCustom(
                                      isEnabled: controller
                                                  .paymentSettingModel
                                                  .value
                                                  .flutterWave!
                                                  .isEnabled ==
                                              "true"
                                          ? true
                                          : false,
                                      name: 'FlutterWave',
                                      image: "assets/icons/flutterwave.png",
                                      isSelected: controller.flutterWave.value,
                                      groupValue:
                                          controller.selectedRadioTile.value,
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
                                        controller.selectedRadioTile.value =
                                            value!;
                                        controller.paymentMethodId.value =
                                            controller.paymentSettingModel.value
                                                .flutterWave!.idPaymentMethod
                                                .toString();
                                      },
                                    ),
                                    RadioButtonCustom(
                                      isEnabled: controller.paymentSettingModel
                                                  .value.razorpay!.isEnabled ==
                                              "true"
                                          ? true
                                          : false,
                                      name: 'RazorPay',
                                      image: "assets/icons/razorpay_@3x.png",
                                      isSelected: controller.razorPay.value,
                                      groupValue:
                                          controller.selectedRadioTile.value,
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
                                        controller.selectedRadioTile.value =
                                            value!;
                                        controller.paymentMethodId.value =
                                            controller.paymentSettingModel.value
                                                .razorpay!.idPaymentMethod
                                                .toString();
                                      },
                                    ),
                                    RadioButtonCustom(
                                      isEnabled: controller.paymentSettingModel
                                                  .value.payFast!.isEnabled ==
                                              "true"
                                          ? true
                                          : false,
                                      name: 'PayFast',
                                      image: "assets/icons/payfast.png",
                                      isSelected: controller.payFast.value,
                                      groupValue:
                                          controller.selectedRadioTile.value,
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
                                        controller.selectedRadioTile.value =
                                            value!;
                                        controller.paymentMethodId.value =
                                            controller.paymentSettingModel.value
                                                .payFast!.idPaymentMethod
                                                .toString();
                                      },
                                    ),
                                    RadioButtonCustom(
                                      isEnabled: controller
                                                  .paymentSettingModel
                                                  .value
                                                  .mercadopago!
                                                  .isEnabled ==
                                              "true"
                                          ? true
                                          : false,
                                      name: 'MercadoPago',
                                      image: "assets/icons/mercadopago.png",
                                      isSelected: controller.mercadoPago.value,
                                      groupValue:
                                          controller.selectedRadioTile.value,
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
                                        controller.selectedRadioTile.value =
                                            value!;
                                        controller.paymentMethodId.value =
                                            controller.paymentSettingModel.value
                                                .mercadopago!.idPaymentMethod
                                                .toString();
                                      },
                                    ),
                                    RadioButtonCustom(
                                      isEnabled: controller.paymentSettingModel
                                                  .value.payPal!.isEnabled ==
                                              "true"
                                          ? true
                                          : false,
                                      name: 'PayPal',
                                      image: "assets/icons/paypal_@3x.png",
                                      isSelected: controller.paypal.value,
                                      groupValue:
                                          controller.selectedRadioTile.value,
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
                                        controller.selectedRadioTile.value =
                                            value!;
                                        controller.paymentMethodId.value =
                                            controller.paymentSettingModel.value
                                                .payPal!.idPaymentMethod
                                                .toString();
                                      },
                                    ),
                                    RadioButtonCustom(
                                      isEnabled: controller.paymentSettingModel
                                                  .value.xendit!.isEnabled ==
                                              "true"
                                          ? true
                                          : false,
                                      name: 'Xendit',
                                      image: "assets/icons/xendit.png",
                                      isSelected: controller.xendit.value,
                                      groupValue:
                                          controller.selectedRadioTile.value,
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
                                        controller.selectedRadioTile.value =
                                            value!;
                                        controller.paymentMethodId.value =
                                            controller.paymentSettingModel.value
                                                .xendit!.idPaymentMethod
                                                .toString();
                                      },
                                    ),
                                    RadioButtonCustom(
                                      isEnabled: controller.paymentSettingModel
                                                  .value.orangePay!.isEnabled ==
                                              "true"
                                          ? true
                                          : false,
                                      name: 'Orange Pay',
                                      image: "assets/icons/orangeMoney.png",
                                      isSelected: controller.orangePay.value,
                                      groupValue:
                                          controller.selectedRadioTile.value,
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
                                        controller.selectedRadioTile.value =
                                            value!;
                                        controller.paymentMethodId.value =
                                            controller.paymentSettingModel.value
                                                .orangePay!.idPaymentMethod
                                                .toString();
                                      },
                                    ),
                                    RadioButtonCustom(
                                      isEnabled: controller.paymentSettingModel
                                                  .value.midtrans!.isEnabled ==
                                              "true"
                                          ? true
                                          : false,
                                      name: 'Midtrans',
                                      image: "assets/icons/midtrans.png",
                                      isSelected: controller.midtrans.value,
                                      groupValue:
                                          controller.selectedRadioTile.value,
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
                                        controller.selectedRadioTile.value =
                                            value!;
                                        controller.paymentMethodId.value =
                                            controller.paymentSettingModel.value
                                                .midtrans!.idPaymentMethod
                                                .toString();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                        padding:
                            EdgeInsets.only(left: 16, right: 16, bottom: 10),
                        child: ButtonThem.buildButton(context,
                            title:
                                "Pay ${Constant().amountShow(amount: controller.getTotalAmount().toString())}"
                                    .tr, onPress: () async {
                          if (controller.selectedRadioTile.value == "Wallet") {
                            if (double.parse(
                                    controller.walletAmount.toString()) >=
                                controller.getTotalAmount()) {
                              Get.back();
                              List taxList = [];

                              for (var v in Constant.taxList) {
                                taxList.add(v.toJson());
                              }
                              Map<String, dynamic> bodyParams = {
                                'id_ride': controller.data.value.id.toString(),
                                'id_driver': controller.data.value.idConducteur
                                    .toString(),
                                'id_user_app':
                                    controller.data.value.idUserApp.toString(),
                                'amount':
                                    controller.subTotalAmount.value.toString(),
                                'paymethod': controller.selectedRadioTile.value,
                                'discount':
                                    controller.discountAmount.value.toString(),
                                'tip': controller.tipAmount.value.toString(),
                                'tax': taxList,
                                'transaction_id': DateTime.now()
                                    .microsecondsSinceEpoch
                                    .toString(),
                                'commission': Preferences.getString(
                                    Preferences.admincommission),
                                'payment_status': "success",
                              };
                              controller
                                  .walletDebitAmountRequest(bodyParams)
                                  .then((value) {
                                if (value != null) {
                                  ShowToastDialog.showToast(
                                      "Payment successfully completed");
                                  Get.back(result: true);
                                  Get.back();
                                } else {
                                  ShowToastDialog.closeLoader();
                                }
                              });
                            } else {
                              ShowToastDialog.showToast(
                                  "Insufficient wallet balance");
                            }
                          } else if (controller.selectedRadioTile.value ==
                              "Cash") {
                            Get.back();
                            List taxList = [];

                            for (var v in Constant.taxList) {
                              taxList.add(v.toJson());
                            }
                            Map<String, dynamic> bodyParams = {
                              'id_ride': controller.data.value.id.toString(),
                              'id_driver':
                                  controller.data.value.idConducteur.toString(),
                              'id_user_app':
                                  controller.data.value.idUserApp.toString(),
                              'amount':
                                  controller.subTotalAmount.value.toString(),
                              'paymethod': controller.selectedRadioTile.value,
                              'discount':
                                  controller.discountAmount.value.toString(),
                              'tip': controller.tipAmount.value.toString(),
                              'tax': taxList,
                              'transaction_id': DateTime.now()
                                  .microsecondsSinceEpoch
                                  .toString(),
                              'commission': Preferences.getString(
                                  Preferences.admincommission),
                              'payment_status': "success",
                            };
                            controller
                                .cashPaymentRequest(bodyParams)
                                .then((value) {
                              if (value != null) {
                                ShowToastDialog.showToast(
                                    "Payment successfully completed");
                                Get.back(result: true);
                                Get.back();
                              } else {
                                ShowToastDialog.closeLoader();
                              }
                            });
                          } else if (controller.selectedRadioTile.value ==
                              "Stripe") {
                            showLoadingAlert(context);
                            stripe1.Stripe.publishableKey = controller
                                    .paymentSettingModel.value.strip?.key ??
                                '';
                            stripe1.Stripe.merchantIdentifier = 'Cabme';
                            await stripe1.Stripe.instance.applySettings();
                            stripeMakePayment(
                                amount: controller.getTotalAmount().toString());
                          } else if (controller.selectedRadioTile.value ==
                              "RazorPay") {
                            showLoadingAlert(context);
                            startRazorpayPayment(
                                amount: controller
                                    .getTotalAmount()
                                    .round()
                                    .toString());
                          } else if (controller.selectedRadioTile.value ==
                              "PayPal") {
                            showLoadingAlert(context);
                            paypalPaymentSheet(
                                double.parse(
                                        controller.getTotalAmount().toString())
                                    .toString(),
                                context);
                          } else if (controller.selectedRadioTile.value ==
                              "PayStack") {
                            showLoadingAlert(context);
                            payStackPayment(context,
                                controller.getTotalAmount().toStringAsFixed(2));
                          } else if (controller.selectedRadioTile.value ==
                              "PayFast") {
                            showLoadingAlert(context);
                            payFastPayment(context,
                                controller.getTotalAmount().toString());
                          } else if (controller.selectedRadioTile.value ==
                              "FlutterWave") {
                            showLoadingAlert(context);
                            flutterWaveInitiatePayment(
                                context: context,
                                amount: controller.getTotalAmount().toString(),
                                user: controller.userModel.value);
                          } else if (controller.selectedRadioTile.value ==
                              "MercadoPago") {
                            showLoadingAlert(context);
                            mercadoPagoMakePayment(
                                context: context,
                                amount: controller.getTotalAmount().toString(),
                                user: controller.userModel.value,
                                controller: controller);
                          } else if (controller.selectedRadioTile.value ==
                              "Xendit") {
                            showLoadingAlert(context);
                            xenditPayment(
                                context,
                                double.parse(
                                    controller.getTotalAmount().toString()),
                                controller);
                          } else if (controller.selectedRadioTile.value ==
                              "Orange Pay") {
                            showLoadingAlert(context);
                            orangeMakePayment(
                                amount: controller
                                    .getTotalAmount()
                                    .toStringAsFixed(2),
                                context: context,
                                controller: controller);
                          } else if (controller.selectedRadioTile.value ==
                              "Midtrans") {
                            showLoadingAlert(context);
                            midtransMakePayment(
                                amount: controller.getTotalAmount().toString(),
                                context: context,
                                controller: controller);
                          }
                        })),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  buildListPromoCode(PaymentController controller, bool isDarkMode) {
    return controller.coupanCodeList.isEmpty
        ? const SizedBox()
        : Container(
            width: Get.width,
            padding: const EdgeInsets.all(10),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: isDarkMode
                  ? AppThemeData.surface50Dark
                  : AppThemeData.surface50,
              border: Border.all(
                color: isDarkMode
                    ? AppThemeData.grey200Dark
                    : AppThemeData.grey200,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(0.0)),
            ),
            child: SizedBox(
              height: 100,
              child: ListView.builder(
                  itemCount: controller.coupanCodeList.length,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        controller.selectedPromoCode.value =
                            controller.coupanCodeList[index].code.toString();
                        controller.selectedPromoValue.value = controller
                                    .coupanCodeList[index].type ==
                                "Percentage"
                            ? "${controller.coupanCodeList[index].discount}%"
                            : Constant().amountShow(
                                amount: controller
                                    .coupanCodeList[index].discount
                                    .toString());
                        if (controller.coupanCodeList[index].type ==
                            "Percentage") {
                          var amount = double.parse(controller
                                  .coupanCodeList[index].discount
                                  .toString()) /
                              100;
                          if ((controller.subTotalAmount.value *
                                  double.parse(amount.toString())) <
                              controller.subTotalAmount.value) {
                            controller.discountAmount.value =
                                controller.subTotalAmount.value *
                                    double.parse(amount.toString());
                            controller.taxAmount.value = 0.0;
                            for (var i = 0; i < Constant.taxList.length; i++) {
                              if (Constant.taxList[i].statut == 'yes') {
                                if (Constant.taxList[i].type == "Fixed") {
                                  controller.taxAmount.value += double.parse(
                                      Constant.taxList[i].value.toString());
                                } else {
                                  controller.taxAmount.value += ((controller
                                                  .subTotalAmount.value -
                                              controller.discountAmount.value) *
                                          double.parse(Constant
                                              .taxList[i].value!
                                              .toString())) /
                                      100;
                                }
                              }
                            }
                          } else {
                            ShowToastDialog.showToast(
                                "A coupon will be applied when the subtotal amount is greater than the coupon amount.");
                          }
                        } else {
                          if (double.parse(controller
                                  .coupanCodeList[index].discount
                                  .toString()) <
                              controller.subTotalAmount.value) {
                            controller.discountAmount.value = double.parse(
                                controller.coupanCodeList[index].discount
                                    .toString());
                            controller.taxAmount.value = 0.0;
                            for (var i = 0; i < Constant.taxList.length; i++) {
                              if (Constant.taxList[i].statut == 'yes') {
                                if (Constant.taxList[i].type == "Fixed") {
                                  controller.taxAmount.value += double.parse(
                                      Constant.taxList[i].value.toString());
                                } else {
                                  controller.taxAmount.value += ((controller
                                                  .subTotalAmount.value -
                                              controller.discountAmount.value) *
                                          double.parse(Constant
                                              .taxList[i].value!
                                              .toString())) /
                                      100;
                                }
                              }
                            }
                          } else {
                            ShowToastDialog.showToast(
                                "A coupon will be applied when the subtotal amount is greater than the coupon amount.");
                          }
                        }
                      },
                      child: Container(
                        width: Get.width / 1.2,
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/promo_bg.png'),
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        child: Center(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Container(
                                  decoration: const BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(
                                      'assets/icons/promocode.png',
                                      width: 40,
                                      height: 40,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 35),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        controller
                                            .coupanCodeList[index].discription
                                            .toString(),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontFamily: AppThemeData.semiBold,
                                            letterSpacing: 1),
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              FlutterClipboard.copy(controller
                                                      .coupanCodeList[index]
                                                      .code
                                                      .toString())
                                                  .then((value) {
                                                final SnackBar snackBar =
                                                    SnackBar(
                                                  content: Text(
                                                    "Coupon Code Copied".tr,
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  backgroundColor:
                                                      Colors.black38,
                                                );
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                                // return Navigator.pop(context);
                                              });
                                            },
                                            child: Container(
                                              color: Colors.black
                                                  .withOpacity(0.05),
                                              child: DottedBorder(
                                                color: Colors.grey,
                                                strokeWidth: 1,
                                                dashPattern: const [3, 3],
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 5,
                                                      vertical: 5),
                                                  child: Text(
                                                    controller
                                                        .coupanCodeList[index]
                                                        .code
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Expanded(
                                            child: Text(
                                              "${"Valid till".tr} ${controller.coupanCodeList[index].expireAt}",
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          );
  }

  couponCodeSheet(context, PaymentController controller) {
    return Container(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height / 4.3,
            left: 25,
            right: 25),
        height: MediaQuery.of(context).size.height * 0.92,
        decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(style: BorderStyle.none)),
        child: Column(children: [
          InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 0.3),
                    color: Colors.transparent,
                    shape: BoxShape.circle),

                // radius: 20,
                child: const Center(
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              )),
          const SizedBox(
            height: 25,
          ),
          Expanded(
              child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 30),
                    child: const Image(
                      image: AssetImage('assets/images/promo_code.png'),
                      width: 100,
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        'Redeem Your Coupons'.tr,
                        style: const TextStyle(
                            fontFamily: 'Poppinssb',
                            color: Color(0XFF2A2A2A),
                            fontSize: 16),
                      )),
                  Text(
                    'Get the discount on all over the budget'.tr,
                    style: const TextStyle(
                        fontFamily: 'Poppinsr',
                        color: Color(0XFF9091A4),
                        letterSpacing: 0.5,
                        height: 2),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 20),
                    // height: 120,
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(12),
                      dashPattern: const [4, 2],
                      color: const Color(0XFFB7B7B7),
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 20, bottom: 20),
                          color: const Color(0XFFF1F4F7),
                          alignment: Alignment.center,
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            controller: controller.couponCodeController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Write Coupon Code'.tr,
                              hintStyle:
                                  const TextStyle(color: Color(0XFF9091A4)),
                              labelStyle:
                                  const TextStyle(color: Color(0XFF333333)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30, bottom: 30),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 100, vertical: 15),
                        backgroundColor: AppThemeData.primary200,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        if (controller.couponCodeController.text.isNotEmpty) {
                          controller.selectedPromoCode.value =
                              controller.couponCodeController.text;

                          for (var element in controller.coupanCodeList) {
                            if (element.code!.trim() ==
                                controller.couponCodeController.text
                                    .toString()
                                    .trim()) {
                              controller.selectedPromoValue.value =
                                  element.type == "Percentage"
                                      ? "${element.discount}%"
                                      : Constant().amountShow(
                                          amount: element.discount.toString());
                              if (element.type == "Percentage") {
                                var amount =
                                    double.parse(element.discount.toString()) /
                                        100;
                                if ((controller.subTotalAmount.value *
                                        double.parse(amount.toString())) <
                                    controller.subTotalAmount.value) {
                                  controller.discountAmount.value =
                                      controller.subTotalAmount.value *
                                          double.parse(amount.toString());
                                  controller.taxAmount.value = 0.0;
                                  for (var i = 0;
                                      i < Constant.taxList.length;
                                      i++) {
                                    if (Constant.taxList[i].statut == 'yes') {
                                      if (Constant.taxList[i].type == "Fixed") {
                                        controller.taxAmount.value +=
                                            double.parse(Constant
                                                .taxList[i].value
                                                .toString());
                                      } else {
                                        controller.taxAmount.value +=
                                            ((controller.subTotalAmount.value -
                                                        controller
                                                            .discountAmount
                                                            .value) *
                                                    double.parse(Constant
                                                        .taxList[i].value!
                                                        .toString())) /
                                                100;
                                      }
                                    }
                                  }
                                  Navigator.pop(context);
                                } else {
                                  ShowToastDialog.showToast(
                                      "A coupon will be applied when the subtotal amount is greater than the coupon amount.");
                                  Navigator.pop(context);
                                }
                              } else {
                                if (double.parse(element.discount.toString()) <
                                    controller.subTotalAmount.value) {
                                  controller.discountAmount.value =
                                      double.parse(element.discount.toString());
                                  controller.taxAmount.value = 0.0;
                                  for (var i = 0;
                                      i < Constant.taxList.length;
                                      i++) {
                                    if (Constant.taxList[i].statut == 'yes') {
                                      if (Constant.taxList[i].type == "Fixed") {
                                        controller.taxAmount.value +=
                                            double.parse(Constant
                                                .taxList[i].value
                                                .toString());
                                      } else {
                                        controller.taxAmount.value +=
                                            ((controller.subTotalAmount.value -
                                                        controller
                                                            .discountAmount
                                                            .value) *
                                                    double.parse(Constant
                                                        .taxList[i].value!
                                                        .toString())) /
                                                100;
                                      }
                                    }
                                  }
                                  Navigator.pop(context);
                                } else {
                                  ShowToastDialog.showToast(
                                      "A coupon will be applied when the subtotal amount is greater than the coupon amount.");
                                  Navigator.pop(context);
                                }
                              }
                            } else {}
                          }
                        } else {
                          ShowToastDialog.showToast("Enter Promo Code");
                        }
                      },
                      child: Text(
                        'REDEEM NOW'.tr,
                        style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppinsm',
                            fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
          //buildcouponItem(snapshot)
          //  listData(snapshot)
        ]));
  }

  tipAmountBottomSheet(
      BuildContext context, bool isDarkMode, PaymentController controller) {
    return showModalBottomSheet(
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        backgroundColor:
            isDarkMode ? AppThemeData.surface50Dark : AppThemeData.surface50,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
              child: Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "Enter Tip option".tr,
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: AppThemeData.semiBold,
                          color: isDarkMode
                              ? AppThemeData.grey900Dark
                              : AppThemeData.grey900,
                        ),
                      ),
                    ),
                    TextFieldWidget(
                        hintText: 'Enter Tip'.tr,
                        controller: controller.tripAmountTextFieldController),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: ButtonThem.buildBorderButton(
                              context,
                              btnHeight: 50,
                              title: "cancel".tr,
                              txtColor: AppThemeData.primary200,
                              onPress: () {
                                Get.back();
                              },
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: ButtonThem.buildButton(
                              context,
                              btnHeight: 50,
                              title: "Add".tr,
                              onPress: () async {
                                controller.tipAmount.value = double.parse(
                                    controller
                                        .tripAmountTextFieldController.text);
                                Get.back();
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          });
        });
  }

  String strToDouble(String value) {
    bool isDouble = double.tryParse(value) == null;
    if (!isDouble) {
      String val = double.parse(value)
          .toStringAsFixed(int.parse(Constant.decimal ?? "2"));
      return val;
    }
    return '0.0';
  }

  transactionAPI() {
    paymentController.transactionAmountRequest().then((value) {
      if (value != null) {
        ShowToastDialog.showToast("Payment successfully completed".tr);
        Get.back(result: true);
        Get.back(result: true);
      } else {
        ShowToastDialog.closeLoader();
      }
    });
  }

  final walletController = Get.put(WalletController());
  final paymentController = Get.put(PaymentController());

  Map<String, dynamic>? paymentIntentData;

  /// strip Payment Gateway
  Future<void> stripeMakePayment({required String amount}) async {
    log(double.parse(amount).toStringAsFixed(0));
    try {
      paymentIntentData =
          await walletController.createStripeIntent(amount: amount);
      if (paymentIntentData!.containsKey("error")) {
        Get.back();
        showSnackBarAlert(
          message: "Something went wrong, please contact admin.".tr,
          color: Colors.red.shade400,
        );
      } else {
        await stripe1.Stripe.instance
            .initPaymentSheet(
                paymentSheetParameters: stripe1.SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntentData!['client_secret'],
              allowsDelayedPaymentMethods: false,
              googlePay: const stripe1.PaymentSheetGooglePay(
                merchantCountryCode: 'US',
                testEnv: true,
                currencyCode: "USD",
              ),
              style: ThemeMode.system,
              appearance: stripe1.PaymentSheetAppearance(
                colors: stripe1.PaymentSheetAppearanceColors(
                  primary: AppThemeData.primary200,
                ),
              ),
              merchantDisplayName: 'Emart',
            ))
            .then((value) {});
        displayStripePaymentSheet(amount: amount);
      }
    } catch (e, s) {
      showSnackBarAlert(
        message: 'exception:$e \n$s',
        color: Colors.red,
      );
    }
  }

  displayStripePaymentSheet({required String amount}) async {
    try {
      await stripe1.Stripe.instance.presentPaymentSheet().then((value) {
        Get.back();
        transactionAPI();
        paymentIntentData = null;
      });
    } on stripe1.StripeException catch (e) {
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

  /// RazorPay Payment Gateway
  final Razorpay razorPayController = Razorpay();

  startRazorpayPayment({required String amount}) {
    log(double.parse(amount).toStringAsFixed(0));

    try {
      walletController
          .createOrderRazorPay(
              amount: int.parse(double.parse(amount).toStringAsFixed(0)))
          .then((value) {
        if (value != null) {
          CreateRazorPayOrderModel result = value;
          openCheckout(
            amount: amount,
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
      'name': 'Cabme',
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
    transactionAPI();
  }

  void _handleExternalWaller(ExternalWalletResponse response) {
    Get.back();
    showSnackBarAlert(
      message: "${"Payment Processing Via".tr}\n${response.walletName!.tr}",
      color: Colors.blue.shade400,
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Get.back();
    showSnackBarAlert(
      message:
          "${"Payment Failed!!".tr}\n${jsonDecode(response.message!)['error']['description']}",
      color: Colors.red.shade400,
    );
  }

  // ///paypal
  paypalPaymentSheet(String amount, context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => UsePaypal(
            sandboxMode:
                walletController.paymentSettingModel.value.payPal!.isLive ==
                        "true"
                    ? false
                    : true,
            clientId:
                walletController.paymentSettingModel.value.payPal!.appId ?? '',
            secretKey:
                walletController.paymentSettingModel.value.payPal!.secretKey ??
                    '',
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
              transactionAPI();
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

  ///PayStack Payment Method
  payStackPayment(BuildContext context, String amount) async {
    var secretKey = walletController
        .paymentSettingModel.value.payStack!.secretKey
        .toString();
    await walletController
        .payStackURLGen(
      amount: amount,
      secretKey: secretKey,
    )
        .then((value) async {
      if (value != null) {
        PayStackUrlModel payStackModel = value;
        bool isDone = await Get.to(() => PayStackScreen(
              walletController: walletController,
              secretKey: secretKey,
              initialURl: payStackModel.data.authorizationUrl,
              amount: amount,
              reference: payStackModel.data.reference,
              callBackUrl: walletController
                  .paymentSettingModel.value.payStack!.callbackUrl
                  .toString(),
            ));
        Get.back();

        if (isDone) {
          Get.back();
          transactionAPI();
        } else {
          showSnackBarAlert(
              message: "Payment UnSuccessful!!".tr, color: Colors.red);
        }
      } else {
        showSnackBarAlert(
            message: "Error while transaction!".tr, color: Colors.red);
      }
    });
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
  flutterWaveInitiatePayment(
      {required BuildContext context,
      required String amount,
      required UserModel user}) async {
    final url = Uri.parse('https://api.flutterwave.com/v3/payments');
    final headers = {
      'Authorization':
          'Bearer ${walletController.paymentSettingModel.value.flutterWave?.secretKey}',
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
        "name":
            '${user.data?.prenom} ${user.data?.nom}', // Add a real customer name
      },
      "customizations": {
        "title": "Payment for Services",
        "description": "Payment for XYZ services",
      }
    });

    final response = await http.post(url, headers: headers, body: body);

    showLog("API :: URL :: $url");
    showLog("API :: Request Body :: $body");
    showLog("API :: Request Header :: ${{
      'Authorization':
          'Bearer ${walletController.paymentSettingModel.value.flutterWave?.secretKey}',
      'Content-Type': 'application/json',
    }.toString()} ");
    showLog("API :: responseStatus :: ${response.statusCode} ");
    showLog("API :: responseBody :: ${response.body} ");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      Get.to(MercadoPagoScreen(initialURl: data['data']['link']))!
          .then((value) async {
        if (value) {
          ShowToastDialog.showToast("Payment Successful!!");
          Get.back();
          transactionAPI();
        } else {
          Get.back();
          ShowToastDialog.showToast("Payment UnSuccessful!!");
        }
      });
    } else {
      Get.back();
      ShowToastDialog.showToast("Payment UnSuccessful!!");
      return null;
    }
  }

  ///payFast
  payFastPayment(context, amount) {
    PayFast? payfast = walletController.paymentSettingModel.value.payFast;
    PayStackURLGen.getPayHTML(
            payFastSettingData: payfast!,
            amount: double.parse(amount.toString()).round().toString())
        .then((String? value) async {
      bool isDone = await Get.to(PayFastScreen(
        htmlData: value!,
        payFastSettingData: payfast,
      ));
      if (isDone) {
        Get.back();
        transactionAPI();
      } else {
        Get.back();
        showSnackBarAlert(
          message: "No Response!".tr,
          color: Colors.red,
        );
      }
    });
  }

  ///MercadoPago Payment Method

  mercadoPagoMakePayment(
      {required BuildContext context,
      required String amount,
      required UserModel user,
      required PaymentController controller}) async {
    final headers = {
      'Authorization':
          'Bearer ${controller.paymentSettingModel.value.mercadopago?.accesstoken ?? ''}',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      "items": [
        {
          "title": "Test",
          "description": "Test Payment",
          "quantity": 1,
          "currency_id": "BRL", // Replace with the correct currency
          "unit_price": double.parse(amount),
        }
      ],
      "payer": {"email": user.data?.email ?? ''},
      "back_urls": {
        "failure": "${API.baseUrl}payment/failure",
        "pending": "${API.baseUrl}payment/pending",
        "success": "${API.baseUrl}payment/success",
      },
      "auto_return":
          "approved" // Automatically return after payment is approved
    });

    final response = await http.post(
      Uri.parse("https://api.mercadopago.com/checkout/preferences"),
      headers: headers,
      body: body,
    );
    showLog("API :: URL :: https://api.mercadopago.com/checkout/preferences");
    showLog("API :: Request Body :: ${jsonEncode(body)} ");
    showLog("API :: Response Status :: ${response.statusCode} ");
    showLog("API :: Response Body :: ${response.body} ");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      Get.to(MercadoPagoScreen(
        initialURl: controller
                    .paymentSettingModel.value.mercadopago?.isSandboxEnabled ==
                "false"
            ? data['init_point']
            : data['sandbox_init_point'],
      ))!
          .then((value) {
        if (value) {
          Get.back();
          ShowToastDialog.showToast("Payment Successful!!");
          transactionAPI();
        } else {
          ShowToastDialog.showToast("Payment UnSuccessful!!");
        }
      });
    } else {
      print('Error creating preference: ${response.body}');
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
              const CircularProgressIndicator(),
              Text('Please wait!!'.tr),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const SizedBox(
                  height: 15,
                ),
                Text(
                  'Please wait!! while completing Transaction'.tr,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(
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
  xenditPayment(context, amount, PaymentController controller) async {
    await createXenditInvoice(amount: amount, controller: controller)
        .then((model) {
      if (model.id != null) {
        Get.to(() => XenditScreen(
                  initialURl: model.invoiceUrl ?? '',
                  transId: model.id ?? '',
                  apiKey: controller.paymentSettingModel.value.xendit!.key!
                      .toString(),
                ))!
            .then((value) {
          if (value == true) {
            Get.back();
            transactionAPI();
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

  Future<XenditModel> createXenditInvoice(
      {required var amount, required PaymentController controller}) async {
    const url = 'https://api.xendit.co/v2/invoices';
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': generateBasicAuthHeader(
          controller.paymentSettingModel.value.xendit!.key!.toString()),
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
      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);
      showLog("API :: URL :: $url");
      showLog("API :: Request Body :: ${jsonEncode(body)}");
      showLog("API :: Request Header :: ${headers.toString()} ");
      showLog("API :: responseStatus :: ${response.statusCode} ");
      showLog("API :: responseBody :: ${response.body} ");

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

  orangeMakePayment(
      {required String amount,
      required BuildContext context,
      required PaymentController controller}) async {
    reset();

    var paymentURL = await fetchToken(
        context: context,
        orderId: DateTime.now().millisecondsSinceEpoch.toString(),
        amount: amount,
        currency: 'USD',
        controller: controller);

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
          transactionAPI();
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Payment Unsuccessful!!".tr),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future fetchToken(
      {required String orderId,
      required String currency,
      required BuildContext context,
      required String amount,
      required PaymentController controller}) async {
    String apiUrl = 'https://api.orange.com/oauth/v3/token';
    Map<String, String> requestBody = {
      'grant_type': 'client_credentials',
    };

    var response = await http.post(Uri.parse(apiUrl),
        headers: <String, String>{
          'Authorization':
              "Basic ${controller.paymentSettingModel.value.orangePay!.key!}",
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
        body: requestBody);

    showLog("API :: URL :: $apiUrl");
    showLog("API :: Request Body :: ${jsonEncode(requestBody)}");
    showLog("API :: Request Header :: ${{
      'Authorization':
          "Basic ${controller.paymentSettingModel.value.orangePay!.key!}",
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
    }.toString()} ");
    showLog("API :: responseStatus :: ${response.statusCode} ");
    showLog("API :: responseBody :: ${response.body} ");

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);

      accessToken = responseData['access_token'];
      // ignore: use_build_context_synchronously
      Get.back();
      return await webpayment(
          context: context,
          amountData: amount,
          currency: currency,
          orderIdData: orderId,
          controller: controller);
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

  Future webpayment(
      {required String orderIdData,
      required BuildContext context,
      required String currency,
      required String amountData,
      required PaymentController controller}) async {
    orderId = orderIdData;
    amount = amountData;
    String apiUrl =
        controller.paymentSettingModel.value.orangePay!.isSandboxEnabled! ==
                "true"
            ? 'https://api.orange.com/orange-money-webpay/dev/v1/webpayment'
            : 'https://api.orange.com/orange-money-webpay/cm/v1/webpayment';
    Map<String, String> requestBody = {
      "merchant_key":
          controller.paymentSettingModel.value.orangePay!.merchantKey ?? '',
      "currency":
          controller.paymentSettingModel.value.orangePay!.isSandboxEnabled ==
                  "true"
              ? "OUV"
              : currency,
      "order_id": orderId,
      "amount": amount,
      "reference": 'Y-Note Test',
      "lang": "en",
      "return_url":
          controller.paymentSettingModel.value.orangePay!.returnUrl!.toString(),
      "cancel_url":
          controller.paymentSettingModel.value.orangePay!.cancelUrl!.toString(),
      "notif_url":
          controller.paymentSettingModel.value.orangePay!.notifUrl!.toString(),
    };

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: json.encode(requestBody),
    );

    showLog("API :: URL :: $apiUrl");
    showLog("API :: Request Body :: ${jsonEncode(requestBody)}");
    showLog("API :: Request Header :: ${{
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    }.toString()} ");
    showLog("API :: responseStatus :: ${response.statusCode} ");
    showLog("API :: responseBody :: ${response.body} ");
    if (response.statusCode == 201) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      if (responseData['message'] == 'OK') {
        payToken = responseData['pay_token'];
        return responseData['payment_url'];
      } else {
        return '';
      }
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

  static reset() {
    accessToken = '';
    payToken = '';
    orderId = '';
    amount = '';
  }

//Midtrans payment
  midtransMakePayment(
      {required String amount,
      required BuildContext context,
      required PaymentController controller}) async {
    await createPaymentLink(amount: amount, controller: controller).then((url) {
      if (url != '') {
        Get.to(() => MidtransScreen(
                  initialURl: url,
                ))!
            .then((value) async {
          if (value == true) {
            transactionAPI();
          } else {
            Get.back();
            showSnackBarAlert(
              message: "Payment Unsuccessful!!".tr,
              color: Colors.red,
            );
            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //   content: Text("Payment Unsuccessful!!".tr),
            //   backgroundColor: Colors.red,
            // ));
          }
        });
      }
    });
  }

  Future<String> createPaymentLink(
      {required var amount, required PaymentController controller}) async {
    var ordersId = DateTime.now().millisecondsSinceEpoch.toString();
    final url = Uri.parse(controller
                .paymentSettingModel.value.midtrans!.isSandboxEnabled!
                .toString() ==
            "true"
        ? 'https://api.sandbox.midtrans.com/v1/payment-links'
        : 'https://api.midtrans.com/v1/payment-links');

    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': generateBasicAuthHeader(
            controller.paymentSettingModel.value.midtrans!.key!),
      },
      body: jsonEncode({
        'transaction_details': {
          'order_id': ordersId,
          'gross_amount': double.parse(amount.toString()).toInt(),
        },
        'usage_limit': 2,
        "callbacks": {
          "finish": "https://www.google.com?merchant_order_id=$ordersId"
        },
      }),
    );
    showLog("API :: URL :: $url");
    showLog("API :: Request Body :: ${jsonEncode({
          'transaction_details': {
            'order_id': ordersId,
            'gross_amount': double.parse(amount.toString()).toInt(),
          },
          'usage_limit': 2,
          "callbacks": {
            "finish": "https://www.google.com?merchant_order_id=$ordersId"
          },
        })}");
    showLog("API :: Request Header :: ${{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': generateBasicAuthHeader(
          controller.paymentSettingModel.value.midtrans!.key!),
    }.toString()} ");
    showLog("API :: responseStatus :: ${response.statusCode} ");
    showLog("API :: responseBody :: ${response.body} ");

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

  showSnackBarAlert({required String message, Color color = Colors.green}) {
    return Get.showSnackbar(GetSnackBar(
      isDismissible: true,
      message: message,
      backgroundColor: color,
      duration: const Duration(seconds: 8),
    ));
  }
}
