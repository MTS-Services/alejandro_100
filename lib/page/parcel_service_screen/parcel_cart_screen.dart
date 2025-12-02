import 'package:cabme/constant/constant.dart';
import 'package:cabme/controller/parcel_service_controller.dart';
import 'package:cabme/page/parcel_service_screen/parcel_payment_screen.dart';
import 'package:cabme/themes/appbar_cust.dart';
import 'package:cabme/themes/button_them.dart';
import 'package:cabme/themes/constant_colors.dart';
import 'package:cabme/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CartParcelScreen extends StatelessWidget {
  const CartParcelScreen({super.key});

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
              title: "Confirm Parcel".tr,
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
                          color: isDarkMode
                              ? AppThemeData.surface50Dark
                              : AppThemeData.surface50,
                        ),
                      ),
                    ],
                  ),
                ),
                SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 30,
                              ),
                              Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                            color: isDarkMode
                                                ? AppThemeData.surface50Dark
                                                : AppThemeData.surface50,
                                            border: Border.all(
                                              color: isDarkMode
                                                  ? AppThemeData.grey300Dark
                                                  : AppThemeData.grey300,
                                              width: 1,
                                            )),
                                        child: Stack(children: [
                                          Column(children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 14),
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset(
                                                      'assets/icons/ic_location.svg',
                                                      colorFilter:
                                                          ColorFilter.mode(
                                                        AppThemeData.success300,
                                                        BlendMode.srcIn,
                                                      )),
                                                  const SizedBox(width: 16),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                            controller
                                                                .sNameController
                                                                .text
                                                                .toString(),
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  AppThemeData
                                                                      .medium,
                                                              color: themeChange.getThem()
                                                                  ? AppThemeData
                                                                      .grey900Dark
                                                                  : AppThemeData
                                                                      .grey900,
                                                              fontSize: 16,
                                                            )),
                                                        Text(
                                                            controller
                                                                .senderAddress
                                                                .toString(),
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  AppThemeData
                                                                      .regular,
                                                              color: themeChange.getThem()
                                                                  ? AppThemeData
                                                                      .grey500Dark
                                                                  : AppThemeData
                                                                      .grey500,
                                                              fontSize: 14,
                                                            )),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              color: isDarkMode
                                                  ? AppThemeData.grey300Dark
                                                  : AppThemeData.grey300,
                                              height: 1,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 14),
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset(
                                                      'assets/icons/ic_location.svg',
                                                      colorFilter:
                                                          ColorFilter.mode(
                                                        AppThemeData.warning200,
                                                        BlendMode.srcIn,
                                                      )),
                                                  const SizedBox(width: 16),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                            controller
                                                                .rNameController
                                                                .text
                                                                .toString(),
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  AppThemeData
                                                                      .medium,
                                                              color: themeChange.getThem()
                                                                  ? AppThemeData
                                                                      .grey900Dark
                                                                  : AppThemeData
                                                                      .grey900,
                                                              fontSize: 16,
                                                            )),
                                                        Text(
                                                            controller
                                                                .receiverAddress
                                                                .toString(),
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  AppThemeData
                                                                      .regular,
                                                              color: themeChange.getThem()
                                                                  ? AppThemeData
                                                                      .grey500Dark
                                                                  : AppThemeData
                                                                      .grey500,
                                                              fontSize: 14,
                                                            )),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ]),
                                          Positioned(
                                              top: 50,
                                              left:
                                                  Directionality.of(context) ==
                                                          TextDirection.rtl
                                                      ? null
                                                      : 27,
                                              right:
                                                  Directionality.of(context) ==
                                                          TextDirection.rtl
                                                      ? 26
                                                      : null,
                                              child: Container(
                                                width: 2,
                                                height: 42,
                                                color: themeChange.getThem()
                                                    ? AppThemeData.grey200Dark
                                                    : AppThemeData.grey200,
                                              )),
                                        ])),
                                    const SizedBox(
                                      height: 40,
                                    ),
                                    Text('About Parcel Details'.tr,
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontFamily: AppThemeData.semiBold,
                                          color: themeChange.getThem()
                                              ? AppThemeData.grey900Dark
                                              : AppThemeData.grey900,
                                          fontSize: 18,
                                        )),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                        decoration: BoxDecoration(
                                            color: isDarkMode
                                                ? AppThemeData.surface50Dark
                                                : AppThemeData.surface50,
                                            border: Border.all(
                                              color: isDarkMode
                                                  ? AppThemeData.grey300Dark
                                                  : AppThemeData.grey300,
                                              width: 1,
                                            )),
                                        child: Column(children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 16),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Text('Distance'.tr,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        fontFamily: AppThemeData
                                                            .regular,
                                                        color: themeChange
                                                                .getThem()
                                                            ? AppThemeData
                                                                .grey900Dark
                                                            : AppThemeData
                                                                .grey900,
                                                        fontSize: 16,
                                                      )),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                      controller.distance
                                                              .toStringAsFixed(int
                                                                  .parse(Constant
                                                                      .decimal
                                                                      .toString())) +
                                                          Constant.distanceUnit
                                                              .toString(),
                                                      textAlign: TextAlign.end,
                                                      maxLines: 1,
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
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            color: isDarkMode
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
                                                  flex: 1,
                                                  child: Text('Duration'.tr,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        fontFamily: AppThemeData
                                                            .regular,
                                                        color: themeChange
                                                                .getThem()
                                                            ? AppThemeData
                                                                .grey900Dark
                                                            : AppThemeData
                                                                .grey900,
                                                        fontSize: 16,
                                                      )),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                      controller.duration.value
                                                          .toString(),
                                                      textAlign: TextAlign.end,
                                                      maxLines: 1,
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
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            color: isDarkMode
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
                                                  flex: 1,
                                                  child: Text('Weight (KG)'.tr,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        fontFamily: AppThemeData
                                                            .regular,
                                                        color: themeChange
                                                                .getThem()
                                                            ? AppThemeData
                                                                .grey900Dark
                                                            : AppThemeData
                                                                .grey900,
                                                        fontSize: 16,
                                                      )),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                      '${controller.parcelWeightController.text}Kg',
                                                      textAlign: TextAlign.end,
                                                      maxLines: 1,
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
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            color: isDarkMode
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
                                                  flex: 1,
                                                  child: Text('Size (ft)'.tr,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        fontFamily: AppThemeData
                                                            .regular,
                                                        color: themeChange
                                                                .getThem()
                                                            ? AppThemeData
                                                                .grey900Dark
                                                            : AppThemeData
                                                                .grey900,
                                                        fontSize: 16,
                                                      )),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                      '${controller.parcelDimentionController.text}${'ft'.tr}',
                                                      textAlign: TextAlign.end,
                                                      maxLines: 1,
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
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            color: isDarkMode
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
                                                  flex: 1,
                                                  child: Text('Total Cost'.tr,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        fontFamily: AppThemeData
                                                            .regular,
                                                        color: themeChange
                                                                .getThem()
                                                            ? AppThemeData
                                                                .grey900Dark
                                                            : AppThemeData
                                                                .grey900,
                                                        fontSize: 16,
                                                      )),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                      Constant().amountShow(
                                                          amount: controller
                                                              .subTotal
                                                              .toStringAsFixed(int
                                                                  .parse(Constant
                                                                      .decimal
                                                                      .toString()))),
                                                      textAlign: TextAlign.end,
                                                      maxLines: 1,
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
                                                ),
                                              ],
                                            ),
                                          ),
                                        ])),
                                  ]),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: ButtonThem.buildButton(
                          context,
                          title: "Select Payment Method".tr,
                          btnColor: AppThemeData.primary200,
                          txtColor: Colors.white,
                          onPress: () async {
                            var amount = await Constant().getAmount();
                            if (amount != null) {
                              controller.walletAmount.value = amount;
                            }
                            Get.to(() => const ParcelPaymentScreen());
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
