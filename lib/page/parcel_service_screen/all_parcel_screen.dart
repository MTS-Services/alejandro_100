import 'dart:developer';

import 'package:cabme/constant/constant.dart';
import 'package:cabme/controller/parcel_order_controller.dart';
import 'package:cabme/model/parcel_model.dart';
import 'package:cabme/page/complaint/add_complaint_screen.dart';
import 'package:cabme/page/dash_board.dart';
import 'package:cabme/page/driver_profile/driver_profile_screen.dart';
import 'package:cabme/page/parcel_service_screen/parcel_details_screen.dart';
import 'package:cabme/page/review_screens/add_review_screen.dart';
import 'package:cabme/themes/appbar_cust.dart';
import 'package:cabme/themes/button_them.dart';
import 'package:cabme/themes/responsive.dart';
import 'package:cabme/utils/dark_theme_provider.dart';
import 'package:cabme/widget/StarRating.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../constant/show_toast_dialog.dart';
import '../../themes/constant_colors.dart';

class AllParcelScreen extends StatelessWidget {
  const AllParcelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<ParcelOrderController>(
      init: ParcelOrderController(),
      builder: (controller) {
        return Scaffold(
          appBar: CustomAppbar(
            bgColor: AppThemeData.primary200,
            title: 'All Parcels'.tr,
            isLeadingIcon: false,
            onClick: () {
              log("::::::All Parcels::::::");
              Get.offAll(DashBoard());
            },
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
                      flex: 10,
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
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        height: Responsive.height(70, context),
                        color: themeChange.getThem()
                            ? AppThemeData.surface50Dark
                            : AppThemeData.surface50,
                        child: Theme(
                          data: ThemeData(
                            tabBarTheme: TabBarThemeData(
                              indicatorColor: AppThemeData.primary200,
                            ),
                          ),
                          child: DefaultTabController(
                            length: 3,
                            child: Column(children: [
                              TabBar(
                                isScrollable: false,
                                indicatorSize: TabBarIndicatorSize.tab,
                                indicatorColor: AppThemeData.primary200,
                                indicatorWeight: 0.1,
                                labelPadding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                dividerColor: Colors.transparent,
                                labelColor: AppThemeData.primary200,
                                automaticIndicatorColorAdjustment: true,
                                labelStyle: TextStyle(
                                    fontFamily: AppThemeData.medium,
                                    fontSize: 16,
                                    color: AppThemeData.primary200),
                                unselectedLabelStyle: TextStyle(
                                    fontFamily: AppThemeData.regular,
                                    fontSize: 16,
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey300Dark
                                        : AppThemeData.grey400),
                                tabs: [
                                  Tab(
                                    text: 'New'.tr,
                                  ),
                                  Tab(
                                    text: 'Completed'.tr,
                                  ),
                                  Tab(
                                    text: 'Rejected'.tr,
                                  ),
                                ],
                              ),
                              Expanded(
                                child: TabBarView(children: [
                                  SizedBox(
                                    child: RefreshIndicator(
                                      onRefresh: () => controller.getParcel(),
                                      child: controller.isLoading.value
                                          ? SizedBox()
                                          : controller.newParcelList.isEmpty
                                              ? Constant.emptyView(
                                                  context,
                                                  "You have not booked any parcel.",
                                                  false)
                                              : ListView.builder(
                                                  padding: EdgeInsets.zero,
                                                  physics:
                                                      const BouncingScrollPhysics(),
                                                  itemCount: controller
                                                      .newParcelList.length,
                                                  shrinkWrap: true,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return buildHistory(
                                                        context,
                                                        controller,
                                                        controller
                                                                .newParcelList[
                                                            index]);
                                                  },
                                                ),
                                    ),
                                  ),
                                  SizedBox(
                                    child: RefreshIndicator(
                                      onRefresh: () => controller.getParcel(),
                                      child: controller.isLoading.value
                                          ? SizedBox()
                                          : controller
                                                  .completedParcelList.isEmpty
                                              ? Constant.emptyView(
                                                  context,
                                                  "You have not Completed any parcel.",
                                                  false)
                                              : ListView.builder(
                                                  padding: EdgeInsets.zero,
                                                  physics:
                                                      const BouncingScrollPhysics(),
                                                  itemCount: controller
                                                      .completedParcelList
                                                      .length,
                                                  shrinkWrap: true,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return buildHistory(
                                                        context,
                                                        controller,
                                                        controller
                                                                .completedParcelList[
                                                            index]);
                                                  },
                                                ),
                                    ),
                                  ),
                                  SizedBox(
                                    child: RefreshIndicator(
                                      onRefresh: () => controller.getParcel(),
                                      child: controller.isLoading.value
                                          ? SizedBox()
                                          : controller
                                                  .rejectedParcelList.isEmpty
                                              ? Constant.emptyView(
                                                  context,
                                                  "You have not rejected any parcel.",
                                                  false)
                                              : ListView.builder(
                                                  padding: EdgeInsets.zero,
                                                  physics:
                                                      const BouncingScrollPhysics(),
                                                  itemCount: controller
                                                      .rejectedParcelList
                                                      .length,
                                                  shrinkWrap: true,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return buildHistory(
                                                        context,
                                                        controller,
                                                        controller
                                                                .rejectedParcelList[
                                                            index]);
                                                  },
                                                ),
                                    ),
                                  ),
                                ]),
                              )
                            ]),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  buildHistory(context, ParcelOrderController controller, ParcelData data) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GestureDetector(
      onTap: () async {
        log("Parcel Click :: ${data.toJson().toString()}");

        await Get.to(ParcelDetailsScreen(), arguments: {
          "parcelData": data,
        })?.then((v) {
          controller.getParcel();
        });
      },
      child: Container(
        margin: const EdgeInsets.only(top: 22),
        decoration: BoxDecoration(
            border: Border.all(
          color: themeChange.getThem()
              ? AppThemeData.grey200Dark
              : AppThemeData.grey200,
        )),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(children: [
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
                                  height: 60,
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
                                    data.senderName.toString(),
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
                                    data.source.toString(),
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
                              child: data.status == "new"
                                  ? statusTile(
                                      title: 'New',
                                      bgColor:
                                          AppThemeData.primary50.withAlpha(200),
                                      txtColor: AppThemeData.primary200)
                                  : data.status == "onride"
                                      ? statusTile(
                                          title: 'Active',
                                          bgColor: AppThemeData.primary50
                                              .withAlpha(200),
                                          txtColor: AppThemeData.primary200)
                                      : data.status == "confirmed"
                                          ? statusTile(
                                              title: 'Confirmed',
                                              bgColor: AppThemeData.primary50
                                                  .withAlpha(200),
                                              txtColor: AppThemeData.primary200)
                                          : data.status == "completed"
                                              ? statusTile(
                                                  title: 'Completed',
                                                  bgColor: AppThemeData
                                                      .success50
                                                      .withAlpha(200),
                                                  txtColor:
                                                      AppThemeData.success300)
                                              : statusTile(
                                                  title: 'Rejected',
                                                  bgColor: AppThemeData.error50
                                                      .withAlpha(200),
                                                  txtColor:
                                                      AppThemeData.error200,
                                                ),
                            ),
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
                              width: 5,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data.receiverName.toString(),
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
                                    data.destination.toString(),
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
                      ]),
                    ],
                  ),
                ),
                (data.status.toString() == "confirmed" &&
                        Constant.rideOtp.toString().toLowerCase() ==
                            'yes'.toLowerCase())
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: Text(
                          "${"OTP : ".tr}${data.otp.toString()}",
                          style: TextStyle(
                            fontFamily: AppThemeData.medium,
                            color: themeChange.getThem()
                                ? AppThemeData.grey400
                                : AppThemeData.grey300Dark,
                            fontSize: 14,
                          ),
                        ),
                      )
                    : Container(
                        height: 1,
                        color: themeChange.getThem()
                            ? AppThemeData.grey200Dark
                            : AppThemeData.grey200,
                      ),
                Visibility(
                  visible: data.status.toString() != "confirmed" ||
                      Constant.rideOtp.toString().toLowerCase() ==
                          'no'.toLowerCase(),
                  child: const SizedBox(
                    height: 10,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextScroll(
                                "${double.parse(data.distance.toString()).toStringAsFixed(int.parse(Constant.decimal!))} ${data.distanceUnit}",
                                mode: TextScrollMode.bouncing,
                                pauseBetween: const Duration(seconds: 2),
                                style: TextStyle(
                                  fontFamily: AppThemeData.semiBold,
                                  color: AppThemeData.primary200,
                                  fontSize: 18,
                                )),
                            const SizedBox(
                              height: 2,
                            ),
                            Text('Distance'.tr,
                                maxLines: 1,
                                style: TextStyle(
                                  fontFamily: AppThemeData.regular,
                                  color: themeChange.getThem()
                                      ? AppThemeData.grey900Dark
                                      : AppThemeData.grey900,
                                  fontSize: 12,
                                )),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextScroll(data.duration.toString(),
                                  mode: TextScrollMode.bouncing,
                                  pauseBetween: const Duration(seconds: 2),
                                  style: TextStyle(
                                    fontFamily: AppThemeData.semiBold,
                                    color: AppThemeData.primary200,
                                    fontSize: 18,
                                  )),
                              const SizedBox(
                                height: 2,
                              ),
                              Text('Duration'.tr,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontFamily: AppThemeData.regular,
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey900Dark
                                        : AppThemeData.grey900,
                                    fontSize: 12,
                                  )),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  Constant().amountShow(
                                      amount: data.amount.toString()),
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontFamily: AppThemeData.semiBold,
                                    color: AppThemeData.primary200,
                                    fontSize: 18,
                                  )),
                              const SizedBox(
                                height: 2,
                              ),
                              Text("Amount".tr,
                                  style: TextStyle(
                                    fontFamily: AppThemeData.regular,
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey900Dark
                                        : AppThemeData.grey900,
                                    fontSize: 12,
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if ((data.status.toString() != "new" ||
                        data.status.toString() != "canceled") &&
                    data.idConducteur.toString() != "null")
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: InkWell(
                      onTap: () {
                        Get.to(() => DriverProfileScreen(), arguments: {
                          "driverId": data.idConducteur.toString()
                        });
                      },
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(80),
                            child: CachedNetworkImage(
                              imageUrl: data.driverPhoto.toString(),
                              height: 60,
                              width: 60,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  Constant.loader(context),
                              errorWidget: (context, url, error) => Image.asset(
                                "assets/images/appIcon.png",
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${data.driverName}",
                                      style: TextStyle(
                                        fontFamily: AppThemeData.semiBold,
                                        color: themeChange.getThem()
                                            ? AppThemeData.grey900Dark
                                            : AppThemeData.grey900,
                                        fontSize: 16,
                                        letterSpacing: 0.6,
                                      )),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      StarRating(
                                        size: 20,
                                        rating: data.moyenne != "null"
                                            ? double.parse(
                                                data.moyenne.toString())
                                            : 0.0,
                                        color: AppThemeData.warning200,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      data.status == "new" ||
                                              data.status == "active" ||
                                              data.status == "confirmed" ||
                                              data.status == "onride"
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: InkWell(
                                                  onTap: () async {
                                                    ShowToastDialog.showLoader(
                                                        "Please wait");
                                                    final Location
                                                        currentLocation =
                                                        Location();
                                                    LocationData location =
                                                        await currentLocation
                                                            .getLocation();
                                                    ShowToastDialog
                                                        .closeLoader();
                                                    await Share.share(
                                                      'https://www.google.com/maps/search/?api=1&query=${location.latitude},${location.longitude}',
                                                      subject: "Cabme".tr,
                                                    );
                                                    // await FlutterShareMe()
                                                    //     .shareToWhatsApp(msg: 'https://www.google.com/maps/search/?api=1&query=${location.latitude},${location.longitude}');
                                                  },
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    height: 44,
                                                    width: 44,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: AppThemeData
                                                          .secondary200,
                                                    ),
                                                    child: SvgPicture.asset(
                                                      'assets/icons/ic_share.svg',
                                                      height: 20,
                                                      width: 20,
                                                      colorFilter:
                                                          ColorFilter.mode(
                                                        themeChange.getThem()
                                                            ? AppThemeData
                                                                .surface50Dark
                                                            : AppThemeData
                                                                .surface50,
                                                        BlendMode.srcIn,
                                                      ),
                                                    ),
                                                  )),
                                            )
                                          : const Offstage(),
                                    ],
                                  ),
                                  Visibility(
                                      visible: data.status == "completed" ||
                                          data.status == "rejected",
                                      child: ButtonThem.buildIconButton(
                                        btnWidthRatio: 0.3,
                                        radius: 50,
                                        btnHeight: 50,
                                        context,
                                        title: 'Ratings'.tr,
                                        btnColor: AppThemeData.info200,
                                        txtColor: AppThemeData.grey900,
                                        iconColor: AppThemeData.grey900,
                                        iconSize: 18.0,
                                        txtSize: 14,
                                        icon: Icons.add,
                                        onPress: () async {
                                          Get.to(const AddReviewScreen(),
                                                  arguments: {
                                                "data": data,
                                                "ride_type": "parcel",
                                              })!
                                              .then((value) {});
                                        },
                                      )),
                                  Visibility(
                                    visible: data.status == "new" ||
                                        data.status == "active" ||
                                        data.status == "confirmed" ||
                                        data.status == "onride",
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: InkWell(
                                              onTap: () {
                                                Constant.makePhoneCall(data
                                                    .driverPhone
                                                    .toString());
                                              },
                                              child: Container(
                                                alignment: Alignment.center,
                                                height: 44,
                                                width: 44,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color:
                                                      AppThemeData.warning200,
                                                ),
                                                child: SvgPicture.asset(
                                                  'assets/icons/call_icon.svg',
                                                  height: 20,
                                                  width: 20,
                                                  colorFilter: ColorFilter.mode(
                                                    themeChange.getThem()
                                                        ? AppThemeData
                                                            .surface50Dark
                                                        : AppThemeData
                                                            .surface50,
                                                    BlendMode.srcIn,
                                                  ),
                                                ),
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.only(
                              //     top: 5.0,
                              //   ),
                              //   child: Text(data.parcelDate.toString(), style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey900Dark : AppThemeData.grey900, fontSize: 16)),
                              // ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                Visibility(
                  visible: data.status.toString() == "completed",
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: ButtonThem.buildButton(context,
                                title: data.paymentStatus == "yes"
                                    ? "Paid".tr
                                    : "Pay Now".tr,
                                txtColor: Colors.white, onPress: () async {
                          if (data.paymentStatus == "yes") {
                          } else {
                            await Get.to(ParcelDetailsScreen(), arguments: {
                              "parcelData": data,
                            })?.then((v) {
                              controller.getParcel();
                            });
                          }
                        })),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: data.status == "completed",
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: ButtonThem.buildBorderButton(
                      context,
                      title: 'Add Complaint'.tr,
                      btnColor: themeChange.getSystemThem()
                          ? Colors.transparent
                          : AppThemeData.surface50,
                      txtColor: AppThemeData.primary200,
                      btnBorderColor: AppThemeData.primary200,
                      onPress: () async {
                        Get.to(AddComplaintScreen(), arguments: {
                          "data": data,
                          "ride_type": "parcel",
                        })!
                            .then((value) {});
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
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
