import 'package:cabme/constant/constant.dart';
import 'package:cabme/constant/show_toast_dialog.dart';
import 'package:cabme/controller/parcel_payment_controller.dart';
import 'package:cabme/model/tax_model.dart';
import 'package:cabme/page/chats_screen/FullScreenImageViewer.dart';
import 'package:cabme/page/parcel_service_screen/parcel_payment_selection_screen.dart';
import 'package:cabme/page/parcel_service_screen/parcel_route_osm_view_screen.dart';
import 'package:cabme/page/parcel_service_screen/parcel_route_view_screen.dart';
import 'package:cabme/page/review_screens/add_review_screen.dart';
import 'package:cabme/themes/appbar_cust.dart';
import 'package:cabme/themes/button_them.dart';
import 'package:cabme/themes/constant_colors.dart';
import 'package:cabme/themes/custom_alert_dialog.dart';
import 'package:cabme/themes/custom_dialog_box.dart';
import 'package:cabme/themes/text_field_them.dart';
import 'package:cabme/utils/Preferences.dart';
import 'package:cabme/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ParcelDetailsScreen extends StatelessWidget {
  ParcelDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<ParcelPaymentController>(
        init: ParcelPaymentController(),
        builder: (controller) {
          return Scaffold(
            appBar: CustomAppbar(
              bgColor: AppThemeData.primary200,
              title: 'Parcel Details'.tr,
              elevation: 0,
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
                          color: themeChange.getThem()
                              ? AppThemeData.surface50Dark
                              : AppThemeData.surface50,
                        ),
                      ),
                    ],
                  ),
                ),
                SafeArea(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: buildHistory(context, controller),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 10, top: 10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              if (controller.data.value.status.toString() ==
                                  "completed")
                                Expanded(
                                    child: ButtonThem.buildButton(context,
                                        title: controller
                                                    .data.value.paymentStatus ==
                                                "yes"
                                            ? "paid".tr
                                            : "Pay Now".tr,
                                        btnColor: controller
                                                    .data.value.paymentStatus ==
                                                "yes"
                                            ? AppThemeData.info200
                                            : AppThemeData.primary200,
                                        txtColor: Colors.white, onPress: () {
                                  if (controller.data.value.paymentStatus ==
                                      "yes") {
                                    // controller.feelAsSafe(data.id.toString()).then((value) {
                                    //   if (value != null) {
                                    // controller.getCompletedRide();
                                    //   }
                                    // });
                                  } else {
                                    Get.to(ParcelPaymentSelectionScreen(),
                                        arguments: {
                                          "parcelData": controller.data.value,
                                        });
                                  }
                                })),
                              Visibility(
                                visible: controller.data.value.paymentStatus ==
                                    "yes",
                                child: Expanded(
                                  child: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: ButtonThem.buildButton(
                                        context,
                                        title: 'Add Review'.tr,
                                        onPress: () async {
                                          Get.to(const AddReviewScreen(),
                                              arguments: {
                                                "data": controller.data.value,
                                                "ride_type": "parcel",
                                              });
                                        },
                                      )),
                                ),
                              ),
                            ],
                          ),
                          if (controller.data.value.status.toString() ==
                                  "new" ||
                              controller.data.value.status.toString() ==
                                  "onride" ||
                              controller.data.value.status.toString() ==
                                  "confirmed")
                            Row(
                              children: [
                                if (controller.data.value.status.toString() !=
                                    "onride")
                                  Expanded(
                                    child: ButtonThem.buildButton(
                                      context,
                                      btnColor: AppThemeData.error200,
                                      title: 'Cancel Parcel'.tr,
                                      btnWidthRatio: 1,
                                      onPress: () async {
                                        buildShowBottomSheet(context,
                                            themeChange.getThem(), controller);
                                      },
                                    ),
                                  ),
                                if (controller.data.value.status.toString() !=
                                    "onride")
                                  const SizedBox(width: 10),
                                Expanded(
                                    child: ButtonThem.buildButton(
                                  context,
                                  title: 'Track Ride'.tr,
                                  onPress: () async {
                                    var argumentData = {
                                      'type': controller.data.value.status
                                          .toString(),
                                      'data': controller.data.value
                                    };
                                    if (Constant.liveTrackingMapType ==
                                        "inappmap") {
                                      if (Constant.selectedMapType == "osm") {
                                        Get.to(const ParcelRouteOsmViewScreen(),
                                            arguments: argumentData);
                                      } else {
                                        Get.to(const ParcelRouteViewScreen(),
                                            arguments: argumentData);
                                      }
                                    } else {
                                      Constant.redirectMap(
                                        latitude: double.parse(controller
                                            .data
                                            .value
                                            .latDestination!), //orderModel.destinationLocationLAtLng!.latitude!,
                                        longLatitude: double.parse(controller
                                            .data
                                            .value
                                            .lngDestination!), //orderModel.destinationLocationLAtLng!.longitude!,
                                        name: controller.data.value.destination!
                                            .toString(),
                                      ); //orderModel.destinationLocationName.toString());
                                    }
                                  },
                                )),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ))
              ],
            ),
          );
        });
  }

  final resonController = TextEditingController();

  buildShowBottomSheet(BuildContext context, bool isDarkMode,
      ParcelPaymentController controller) {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15), topLeft: Radius.circular(15))),
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        backgroundColor:
            isDarkMode ? AppThemeData.surface50Dark : AppThemeData.surface50,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              child: Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "Cancel Parcel".tr,
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: AppThemeData.semiBold,
                          color: isDarkMode
                              ? AppThemeData.grey900Dark
                              : AppThemeData.grey900,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        "Write a reason for Parcel cancellation".tr,
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: AppThemeData.regular,
                          color: isDarkMode
                              ? AppThemeData.grey400
                              : AppThemeData.grey300Dark,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: TextFieldWidget(
                        maxLine: 3,
                        controller: resonController,
                        hintText: '',
                        fontSize: 14,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: ButtonThem.buildButton(
                                context,
                                title: 'Cancel'.tr,
                                btnWidthRatio: 0.8,
                                onPress: () async {
                                  if (resonController.text.isNotEmpty) {
                                    Get.back();
                                    showDialog(
                                      barrierColor: Colors.black26,
                                      context: context,
                                      builder: (context) {
                                        return CustomAlertDialog(
                                          title:
                                              "Do you want to cancel this booking?"
                                                  .tr,
                                          onPressNegative: () {
                                            Get.back();
                                          },
                                          onPressPositive: () {
                                            if (controller.data.value.status
                                                    .toString() ==
                                                "new") {
                                              Map<String, String> bodyParams = {
                                                'parcel_id': controller
                                                    .data.value.id
                                                    .toString(),
                                                'reason': resonController.text
                                                    .toString(),
                                              };
                                              controller
                                                  .rejectParcel(bodyParams)
                                                  .then((value) {
                                                Get.back();
                                                if (value != null) {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return CustomDialogBox(
                                                          title:
                                                              "Cancel Successfully"
                                                                  .tr,
                                                          descriptions:
                                                              "Parcel Successfully cancel."
                                                                  .tr,
                                                          onPress: () {
                                                            Get.back();
                                                            Get.back();
                                                          },
                                                          img: Image.asset(
                                                              'assets/images/green_checked.png'),
                                                        );
                                                      });
                                                }
                                              });
                                            } else {
                                              Map<String, String> bodyParams = {
                                                'id_parcel': controller
                                                    .data.value.id
                                                    .toString(),
                                                'id_user': controller
                                                    .data.value.idConducteur
                                                    .toString(),
                                                'name':
                                                    "${controller.data.value.senderName}",
                                                'from_id': Preferences.getInt(
                                                        Preferences.userId)
                                                    .toString(),
                                                'user_cat': controller
                                                    .userModel!.data!.userCat
                                                    .toString(),
                                                'reason': resonController.text
                                                    .toString(),
                                              };
                                              controller
                                                  .canceledParcel(bodyParams)
                                                  .then((value) {
                                                Get.back();
                                                if (value != null) {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return CustomDialogBox(
                                                          title:
                                                              "Cancel Successfully"
                                                                  .tr,
                                                          descriptions:
                                                              "Parcel Successfully cancel."
                                                                  .tr,
                                                          onPress: () {
                                                            Get.back();
                                                            Get.back();
                                                          },
                                                          img: Image.asset(
                                                              'assets/images/green_checked.png'),
                                                        );
                                                      });
                                                }
                                              });
                                            }
                                          },
                                        );
                                      },
                                    );
                                  } else {
                                    ShowToastDialog.showToast(
                                        "Please enter a reason");
                                  }
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 5, left: 10),
                              child: ButtonThem.buildBorderButton(
                                context,
                                title: 'Close'.tr,
                                btnWidthRatio: 0.8,
                                btnColor: isDarkMode
                                    ? AppThemeData.surface50Dark
                                    : AppThemeData.surface50,
                                txtColor: AppThemeData.primary200,
                                btnBorderColor: AppThemeData.primary200,
                                onPress: () async {
                                  Get.back();
                                },
                              ),
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

  buildHistory(context, ParcelPaymentController controller) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: themeChange.getThem()
              ? AppThemeData.surface50Dark
              : AppThemeData.surface50,
          borderRadius: const BorderRadius.all(
            Radius.circular(0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: themeChange.getThem()
                      ? AppThemeData.grey200Dark
                      : AppThemeData.grey200,
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/ic_location.svg',
                                    colorFilter: ColorFilter.mode(
                                      AppThemeData.success300,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  Container(
                                    width: 2,
                                    height: 40,
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey200Dark
                                        : AppThemeData.grey200,
                                  )
                                ],
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      controller.data.value.senderName
                                          .toString(),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: AppThemeData.medium,
                                        color: themeChange.getThem()
                                            ? AppThemeData.grey900Dark
                                            : AppThemeData.grey900,
                                      ),
                                    ),
                                    Text(
                                      controller.data.value.source.toString(),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: AppThemeData.regular,
                                        color: themeChange.getThem()
                                            ? AppThemeData.grey400
                                            : AppThemeData.grey300Dark,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(),
                              Align(
                                  alignment: Alignment.topRight,
                                  child: controller.data.value.status == "new"
                                      ? statusTile(
                                          title: 'New',
                                          bgColor: AppThemeData.primary50
                                              .withAlpha(200),
                                          txtColor: AppThemeData.primary200)
                                      : controller.data.value.status == "onride"
                                          ? statusTile(
                                              title: 'Active',
                                              bgColor: AppThemeData.primary50
                                                  .withAlpha(200),
                                              txtColor: AppThemeData.primary200)
                                          : controller.data.value.status ==
                                                  "confirmed"
                                              ? statusTile(
                                                  title: 'Confirmed',
                                                  bgColor: AppThemeData
                                                      .primary50
                                                      .withAlpha(200),
                                                  txtColor:
                                                      AppThemeData.primary200)
                                              : controller.data.value.status ==
                                                      "completed"
                                                  ? statusTile(
                                                      title: 'Completed',
                                                      bgColor: AppThemeData
                                                          .success50
                                                          .withAlpha(200),
                                                      txtColor: AppThemeData
                                                          .success300)
                                                  : statusTile(
                                                      title: 'Rejected',
                                                      bgColor: AppThemeData
                                                          .error50
                                                          .withAlpha(200),
                                                      txtColor: AppThemeData
                                                          .error200)),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/ic_location.svg',
                                colorFilter: ColorFilter.mode(
                                  AppThemeData.warning200,
                                  BlendMode.srcIn,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      controller.data.value.receiverName
                                          .toString(),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: AppThemeData.medium,
                                        color: themeChange.getThem()
                                            ? AppThemeData.grey900Dark
                                            : AppThemeData.grey900,
                                      ),
                                    ),
                                    Text(
                                      controller.data.value.destination
                                          .toString(),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: AppThemeData.regular,
                                        color: themeChange.getThem()
                                            ? AppThemeData.grey400
                                            : AppThemeData.grey300Dark,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text("Parcel Details".tr,
                style: TextStyle(
                  fontFamily: AppThemeData.semiBold,
                  color: themeChange.getThem()
                      ? AppThemeData.grey900Dark
                      : AppThemeData.grey900,
                  fontSize: 16,
                )),
            SizedBox(
              height: 100,
              child: ListView.builder(
                  itemCount: controller.data.value.parcelImage!.length,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Get.to(
                          () => FullScreenImageViewer(
                            imageUrl: controller.data.value.parcelImage![index],
                          ),
                        );
                      },
                      child: Container(
                        width: 90,
                        height: 100.0,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: themeChange.getThem()
                                ? AppThemeData.grey300Dark
                                : AppThemeData.grey300,
                            width: 1,
                          ),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  controller.data.value.parcelImage![index])),
                        ),
                      ),
                    );
                  }),
            ),
            const SizedBox(height: 10),
            Text("Sender and Receiver Details".tr,
                style: TextStyle(
                  fontFamily: AppThemeData.semiBold,
                  color: themeChange.getThem()
                      ? AppThemeData.grey900Dark
                      : AppThemeData.grey900,
                  fontSize: 16,
                )),
            const SizedBox(
              height: 10,
            ),
            Container(
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
                          flex: 1,
                          child: Text('Sender Name'.tr,
                              maxLines: 1,
                              style: TextStyle(
                                fontFamily: AppThemeData.regular,
                                color: themeChange.getThem()
                                    ? AppThemeData.grey900Dark
                                    : AppThemeData.grey900,
                                fontSize: 16,
                              )),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text("${controller.data.value.senderName}",
                              textAlign: TextAlign.end,
                              maxLines: 1,
                              style: TextStyle(
                                fontFamily: AppThemeData.medium,
                                color: themeChange.getThem()
                                    ? AppThemeData.grey500Dark
                                    : AppThemeData.grey500,
                                fontSize: 16,
                              )),
                        ),
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
                          flex: 1,
                          child: Text('Sender Contact'.tr,
                              maxLines: 1,
                              style: TextStyle(
                                fontFamily: AppThemeData.regular,
                                color: themeChange.getThem()
                                    ? AppThemeData.grey900Dark
                                    : AppThemeData.grey900,
                                fontSize: 16,
                              )),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text("${controller.data.value.senderPhone}",
                                  textAlign: TextAlign.end,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontFamily: AppThemeData.medium,
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey500Dark
                                        : AppThemeData.grey500,
                                    fontSize: 16,
                                  )),
                              const SizedBox(width: 5),
                              InkWell(
                                splashColor: Colors.transparent,
                                onTap: () {
                                  Constant.makePhoneCall(controller
                                      .data.value.driverPhone
                                      .toString());
                                },
                                child: SvgPicture.asset(
                                  'assets/icons/ic_phone.svg',
                                  colorFilter: ColorFilter.mode(
                                    AppThemeData.secondary200,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
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
                          flex: 1,
                          child: Text('Receiver Name'.tr,
                              maxLines: 1,
                              style: TextStyle(
                                fontFamily: AppThemeData.regular,
                                color: themeChange.getThem()
                                    ? AppThemeData.grey900Dark
                                    : AppThemeData.grey900,
                                fontSize: 16,
                              )),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text("${controller.data.value.receiverName}",
                              textAlign: TextAlign.end,
                              maxLines: 1,
                              style: TextStyle(
                                fontFamily: AppThemeData.medium,
                                color: themeChange.getThem()
                                    ? AppThemeData.grey500Dark
                                    : AppThemeData.grey500,
                                fontSize: 16,
                              )),
                        ),
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
                          flex: 1,
                          child: Text('Receiver Contact'.tr,
                              maxLines: 1,
                              style: TextStyle(
                                fontFamily: AppThemeData.regular,
                                color: themeChange.getThem()
                                    ? AppThemeData.grey900Dark
                                    : AppThemeData.grey900,
                                fontSize: 16,
                              )),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text("${controller.data.value.receiverPhone}",
                                  textAlign: TextAlign.end,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontFamily: AppThemeData.medium,
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey500Dark
                                        : AppThemeData.grey500,
                                    fontSize: 16,
                                  )),
                              const SizedBox(
                                width: 5,
                              ),
                              InkWell(
                                splashColor: Colors.transparent,
                                onTap: () {
                                  Constant.makePhoneCall(controller
                                      .data.value.driverPhone
                                      .toString());
                                },
                                child: SvgPicture.asset(
                                  'assets/icons/ic_phone.svg',
                                  colorFilter: ColorFilter.mode(
                                    AppThemeData.secondary200,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
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
                          flex: 1,
                          child: Text('Duration'.tr,
                              maxLines: 1,
                              style: TextStyle(
                                fontFamily: AppThemeData.regular,
                                color: themeChange.getThem()
                                    ? AppThemeData.grey900Dark
                                    : AppThemeData.grey900,
                                fontSize: 16,
                              )),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text("${controller.data.value.duration}",
                              textAlign: TextAlign.end,
                              maxLines: 1,
                              style: TextStyle(
                                fontFamily: AppThemeData.medium,
                                color: themeChange.getThem()
                                    ? AppThemeData.grey500Dark
                                    : AppThemeData.grey500,
                                fontSize: 16,
                              )),
                        ),
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
                          flex: 1,
                          child: Text('Weight (KG)'.tr,
                              maxLines: 1,
                              style: TextStyle(
                                fontFamily: AppThemeData.regular,
                                color: themeChange.getThem()
                                    ? AppThemeData.grey900Dark
                                    : AppThemeData.grey900,
                                fontSize: 16,
                              )),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text("${controller.data.value.parcelWeight}",
                                  textAlign: TextAlign.end,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontFamily: AppThemeData.medium,
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey500Dark
                                        : AppThemeData.grey500,
                                    fontSize: 16,
                                  )),
                            ],
                          ),
                        ),
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
                          flex: 1,
                          child: Text('Size (cm)'.tr,
                              maxLines: 1,
                              style: TextStyle(
                                fontFamily: AppThemeData.regular,
                                color: themeChange.getThem()
                                    ? AppThemeData.grey900Dark
                                    : AppThemeData.grey900,
                                fontSize: 16,
                              )),
                        ),
                        Expanded(
                          flex: 1,
                          child:
                              Text("${controller.data.value.parcelDimension}",
                                  textAlign: TextAlign.end,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontFamily: AppThemeData.medium,
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey500Dark
                                        : AppThemeData.grey500,
                                    fontSize: 16,
                                  )),
                        ),
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
                          flex: 1,
                          child: Text('Parcel Type'.tr,
                              maxLines: 1,
                              style: TextStyle(
                                fontFamily: AppThemeData.regular,
                                color: themeChange.getThem()
                                    ? AppThemeData.grey900Dark
                                    : AppThemeData.grey900,
                                fontSize: 16,
                              )),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text("${controller.data.value.title}",
                              textAlign: TextAlign.end,
                              maxLines: 1,
                              style: TextStyle(
                                fontFamily: AppThemeData.medium,
                                color: themeChange.getThem()
                                    ? AppThemeData.grey500Dark
                                    : AppThemeData.grey500,
                                fontSize: 16,
                              )),
                        ),
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
                          flex: 1,
                          child: Text('PickUp Date'.tr,
                              maxLines: 1,
                              style: TextStyle(
                                fontFamily: AppThemeData.regular,
                                color: themeChange.getThem()
                                    ? AppThemeData.grey900Dark
                                    : AppThemeData.grey900,
                                fontSize: 16,
                              )),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                              "${controller.data.value.parcelDate} ${controller.data.value.parcelTime}",
                              textAlign: TextAlign.end,
                              maxLines: 1,
                              style: TextStyle(
                                fontFamily: AppThemeData.medium,
                                color: themeChange.getThem()
                                    ? AppThemeData.grey500Dark
                                    : AppThemeData.grey500,
                                fontSize: 16,
                              )),
                        ),
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
                          flex: 1,
                          child: Text('Drop Date'.tr,
                              maxLines: 1,
                              style: TextStyle(
                                fontFamily: AppThemeData.regular,
                                color: themeChange.getThem()
                                    ? AppThemeData.grey900Dark
                                    : AppThemeData.grey900,
                                fontSize: 16,
                              )),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                              "${controller.data.value.receiveDate} ${controller.data.value.receiveTime}",
                              textAlign: TextAlign.end,
                              maxLines: 1,
                              style: TextStyle(
                                fontFamily: AppThemeData.medium,
                                color: themeChange.getThem()
                                    ? AppThemeData.grey500Dark
                                    : AppThemeData.grey500,
                                fontSize: 16,
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text("Bill Details".tr,
                style: TextStyle(
                  fontFamily: AppThemeData.semiBold,
                  color: themeChange.getThem()
                      ? AppThemeData.grey900Dark
                      : AppThemeData.grey900,
                  fontSize: 16,
                )),
            const SizedBox(
              height: 10,
            ),
            Container(
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
                          flex: 1,
                          child: Text('Parcle Cost'.tr,
                              maxLines: 1,
                              style: TextStyle(
                                fontFamily: AppThemeData.regular,
                                color: themeChange.getThem()
                                    ? AppThemeData.grey900Dark
                                    : AppThemeData.grey900,
                                fontSize: 16,
                              )),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                              Constant().amountShow(
                                  amount: controller.subTotalAmount.toString()),
                              textAlign: TextAlign.end,
                              maxLines: 1,
                              style: TextStyle(
                                fontFamily: AppThemeData.medium,
                                color: themeChange.getThem()
                                    ? AppThemeData.grey500Dark
                                    : AppThemeData.grey500,
                                fontSize: 16,
                              )),
                        ),
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
                          flex: 1,
                          child: Text('Discount'.tr,
                              maxLines: 1,
                              style: TextStyle(
                                fontFamily: AppThemeData.regular,
                                color: themeChange.getThem()
                                    ? AppThemeData.grey900Dark
                                    : AppThemeData.grey900,
                                fontSize: 16,
                              )),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                  "(-${Constant().amountShow(amount: controller.discountAmount.toString())})",
                                  textAlign: TextAlign.end,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontFamily: AppThemeData.medium,
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey500Dark
                                        : AppThemeData.grey500,
                                    fontSize: 16,
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: themeChange.getThem()
                        ? AppThemeData.grey300Dark
                        : AppThemeData.grey300,
                    height: 1,
                  ),
                  ListView.builder(
                    itemCount: Constant.taxList.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      TaxModel taxModel = Constant.taxList[index];
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                      '${taxModel.libelle.toString()} (${taxModel.type == "Fixed" ? Constant().amountShow(amount: taxModel.value) : "${taxModel.value}%"})',
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontFamily: AppThemeData.regular,
                                        color: themeChange.getThem()
                                            ? AppThemeData.grey900Dark
                                            : AppThemeData.grey900,
                                        fontSize: 16,
                                      )),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                      Constant().amountShow(
                                          amount: controller
                                              .calculateTax(taxModel: taxModel)
                                              .toString()),
                                      textAlign: TextAlign.end,
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontFamily: AppThemeData.medium,
                                        color: themeChange.getThem()
                                            ? AppThemeData.grey500Dark
                                            : AppThemeData.grey500,
                                        fontSize: 16,
                                      )),
                                ),
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
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text('Total Payable Amount'.tr,
                              maxLines: 1,
                              style: TextStyle(
                                fontFamily: AppThemeData.regular,
                                color: themeChange.getThem()
                                    ? AppThemeData.grey900Dark
                                    : AppThemeData.grey900,
                                fontSize: 16,
                              )),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                              Constant().amountShow(
                                  amount:
                                      controller.getTotalAmount().toString()),
                              textAlign: TextAlign.end,
                              maxLines: 1,
                              style: TextStyle(
                                fontFamily: AppThemeData.medium,
                                color: themeChange.getThem()
                                    ? AppThemeData.grey500Dark
                                    : AppThemeData.grey500,
                                fontSize: 16,
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text("Order Details".tr,
                style: TextStyle(
                  fontFamily: AppThemeData.semiBold,
                  color: themeChange.getThem()
                      ? AppThemeData.grey900Dark
                      : AppThemeData.grey900,
                  fontSize: 16,
                )),
            const SizedBox(
              height: 10,
            ),
            Container(
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
                          flex: 1,
                          child: Text('Order ID'.tr,
                              maxLines: 1,
                              style: TextStyle(
                                fontFamily: AppThemeData.regular,
                                color: themeChange.getThem()
                                    ? AppThemeData.grey900Dark
                                    : AppThemeData.grey900,
                                fontSize: 16,
                              )),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text("#${controller.data.value.id}",
                              textAlign: TextAlign.end,
                              maxLines: 1,
                              style: TextStyle(
                                fontFamily: AppThemeData.medium,
                                color: themeChange.getThem()
                                    ? AppThemeData.grey500Dark
                                    : AppThemeData.grey500,
                                fontSize: 16,
                              )),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
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
                              flex: 1,
                              child: Text('Payment Via'.tr,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontFamily: AppThemeData.regular,
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey900Dark
                                        : AppThemeData.grey900,
                                    fontSize: 16,
                                  )),
                            ),
                            Expanded(
                              flex: 1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                      controller.data.value.paymentStatus ==
                                              "yes"
                                          ? "${"Paid using".tr} ${controller.data.value.libelle.toString()}"
                                          : "${"Pay using".tr} ${controller.data.value.libelle.toString()}",
                                      textAlign: TextAlign.end,
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontFamily: AppThemeData.light,
                                        color: AppThemeData.primary200,
                                        fontSize: 16,
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildOtherDetails({
    required String title,
    required String value,
    Color color = Colors.black,
  }) {
    return GestureDetector(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(title,
              style: TextStyle(
                  color: ConstantColors.subTitleTextColor,
                  fontWeight: FontWeight.w500)),
          const SizedBox(
            height: 5,
          ),
          Text(value,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14,
                  color: ConstantColors.titleTextColor,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  buildUsersDetails(context, ParcelPaymentController controller,
      {bool isSender = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                isSender ? "${"Sender".tr} " : "${"Receiver".tr} ",
                style: TextStyle(
                    fontSize: 16,
                    color: isSender
                        ? AppThemeData.primary200
                        : const Color(0xffd17e19)),
              ),
              Text(
                isSender
                    ? controller.data.value.senderName.toString()
                    : controller.data.value.receiverName.toString(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Text(
            isSender
                ? controller.data.value.senderPhone.toString()
                : controller.data.value.receiverPhone.toString(),
            style: TextStyle(
                fontSize: 16, color: ConstantColors.subTitleTextColor),
          ),
          Text(
            isSender
                ? controller.data.value.source.toString()
                : controller.data.value.destination.toString(),
            style: TextStyle(
                fontSize: 16, color: ConstantColors.subTitleTextColor),
          ),
        ],
      ),
    );
  }

  buildLine() {
    return Column(
      children: [
        const SizedBox(
          height: 6,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
          ),
          child: Image.asset("assets/images/circle.png", height: 20),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 2),
          child: SizedBox(
            width: 1.3,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: 15,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    child: Container(
                      color: Colors.black38,
                      height: 2.5,
                    ),
                  );
                }),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Image.asset("assets/images/parcel_Image.png", height: 20),
        ),
      ],
    );
  }

  buildAmountWidget(ParcelPaymentController controller) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 2,
              offset: const Offset(2, 2),
            ),
          ],
          borderRadius: const BorderRadius.all(Radius.circular(15.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Text(
                    "Sub Total".tr,
                    style: TextStyle(
                        letterSpacing: 1.0,
                        color: ConstantColors.subTitleTextColor,
                        fontWeight: FontWeight.w600),
                  )),
                  Text(
                      Constant().amountShow(
                          amount: controller.subTotalAmount.toString()),
                      style: TextStyle(
                          letterSpacing: 1.0,
                          color: ConstantColors.titleTextColor,
                          fontWeight: FontWeight.w800)),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                child: Divider(
                  color: Colors.black.withOpacity(0.40),
                ),
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    "Discount".tr,
                    style: TextStyle(
                        letterSpacing: 1.0,
                        color: ConstantColors.subTitleTextColor,
                        fontWeight: FontWeight.w600),
                  )),
                  Text(
                      "(-${Constant().amountShow(amount: controller.discountAmount.toString())})",
                      style: const TextStyle(
                          letterSpacing: 1.0,
                          color: Colors.red,
                          fontWeight: FontWeight.w800)),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                child: Divider(
                  color: Colors.black.withOpacity(0.40),
                ),
              ),
              ListView.builder(
                itemCount: Constant.taxList.length,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  TaxModel taxModel = Constant.taxList[index];
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${taxModel.libelle.toString()} (${taxModel.type == "Fixed" ? Constant().amountShow(amount: taxModel.value) : "${taxModel.value}%"})',
                            style: TextStyle(
                                letterSpacing: 1.0,
                                color: ConstantColors.subTitleTextColor,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                              Constant().amountShow(
                                  amount: controller
                                      .calculateTax(taxModel: taxModel)
                                      .toString()),
                              style: TextStyle(
                                  letterSpacing: 1.0,
                                  color: ConstantColors.titleTextColor,
                                  fontWeight: FontWeight.w800)),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3.0),
                        child: Divider(
                          color: Colors.black.withOpacity(0.40),
                        ),
                      ),
                    ],
                  );
                },
              ),
              Visibility(
                visible: controller.tipAmount.value == 0 ? false : true,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                          "Driver Tip".tr,
                          style: TextStyle(
                              letterSpacing: 1.0,
                              color: ConstantColors.subTitleTextColor,
                              fontWeight: FontWeight.w600),
                        )),
                        Text(
                            Constant().amountShow(
                                amount: controller.tipAmount.toString()),
                            style: TextStyle(
                                letterSpacing: 1.0,
                                color: ConstantColors.titleTextColor,
                                fontWeight: FontWeight.w800)),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3.0),
                      child: Divider(
                        color: Colors.black.withOpacity(0.40),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    "Total".tr,
                    style: TextStyle(
                        letterSpacing: 1.0,
                        color: ConstantColors.titleTextColor,
                        fontWeight: FontWeight.w600),
                  )),
                  Text(
                      Constant().amountShow(
                          amount: controller.getTotalAmount().toString()),
                      style: TextStyle(
                          letterSpacing: 1.0,
                          color: AppThemeData.primary200,
                          fontWeight: FontWeight.w800)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget statusTile({required String title, Color? bgColor, Color? txtColor}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: bgColor,
      ),
      alignment: Alignment.center,
      height: 32,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          title.tr,
          style: TextStyle(
              fontSize: 14, color: txtColor, fontFamily: AppThemeData.medium),
        ),
      ),
    );
  }
}
