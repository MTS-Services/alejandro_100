import 'dart:developer';
import 'package:cabme/constant/constant.dart';
import 'package:cabme/controller/rented_vehicle_controller.dart';
import 'package:cabme/model/rented_vehicle_model.dart';
import 'package:cabme/themes/appbar_cust.dart';
import 'package:cabme/themes/button_them.dart';
import 'package:cabme/themes/constant_colors.dart';
import 'package:cabme/themes/responsive.dart';
import 'package:cabme/utils/dark_theme_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class RentedVehicleScreen extends StatelessWidget {
  const RentedVehicleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<RentedVehicleController>(
      init: RentedVehicleController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: ConstantColors.background,
          appBar: CustomAppbar(
            title: 'Rent Ride History'.tr,
            bgColor: AppThemeData.primary200,
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
                      flex: 9,
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
                    const SizedBox(height: 20),
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
                            child: Column(
                              children: [
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
                                  child: TabBarView(
                                    children: [
                                      SizedBox(
                                        child: RefreshIndicator(
                                          backgroundColor:
                                              AppThemeData.primary200,
                                          onRefresh: () =>
                                              controller.getRentedData(),
                                          child: controller.isLoading.value
                                              ? SizedBox()
                                              : controller
                                                      .rentedVehicleData.isEmpty
                                                  ? Constant.emptyView(
                                                      context,
                                                      "You don't have any rented vehicle. please book ride.",
                                                      false)
                                                  : ListView.builder(
                                                      itemCount: controller
                                                          .rentedVehicleData
                                                          .length,
                                                      shrinkWrap: true,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return buildVehicleCard(
                                                            context,
                                                            controller
                                                                    .rentedVehicleData[
                                                                index],
                                                            controller);
                                                      }),
                                        ),
                                      ),
                                      SizedBox(
                                        child: RefreshIndicator(
                                            backgroundColor:
                                                AppThemeData.primary200,
                                            onRefresh: () =>
                                                controller.getRentedData(),
                                            child: controller.isLoading.value
                                                ? SizedBox()
                                                : controller
                                                        .completedVehicleData
                                                        .isEmpty
                                                    ? Constant.emptyView(
                                                        context,
                                                        "You don't have any completed rent vehicle.",
                                                        false)
                                                    : ListView.builder(
                                                        itemCount: controller
                                                            .completedVehicleData
                                                            .length,
                                                        shrinkWrap: true,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return buildVehicleCard(
                                                              context,
                                                              controller
                                                                      .completedVehicleData[
                                                                  index],
                                                              controller);
                                                        })),
                                      ),
                                      SizedBox(
                                          child: RefreshIndicator(
                                        backgroundColor:
                                            AppThemeData.primary200,
                                        onRefresh: () =>
                                            controller.getRentedData(),
                                        child: controller.isLoading.value
                                            ? SizedBox()
                                            : controller
                                                    .rejectedVehicleData.isEmpty
                                                ? Constant.emptyView(
                                                    context,
                                                    "You don't have any rejected rent vehicle.",
                                                    false)
                                                : ListView.builder(
                                                    itemCount: controller
                                                        .rejectedVehicleData
                                                        .length,
                                                    shrinkWrap: true,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return buildVehicleCard(
                                                          context,
                                                          controller
                                                                  .rejectedVehicleData[
                                                              index],
                                                          controller);
                                                    }),
                                      )),
                                    ],
                                  ),
                                ),
                              ],
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
        );
      },
    );
  }

  Widget buildVehicleCard(BuildContext context, RentedVehicleData data,
      RentedVehicleController controller) {
    log("Rental :: ${data.statut}");
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Container(
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
          border: Border.all(
        color: themeChange.getThem()
            ? AppThemeData.grey200Dark
            : AppThemeData.grey200,
      )),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Row(
              children: [
                CachedNetworkImage(
                  imageUrl: data.image.toString(),
                  width: Responsive.width(30, context),
                  height: Responsive.width(21, context),
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Constant.loader(context),
                  errorWidget: (context, url, error) => Image.asset(
                    "assets/images/appIcon.png",
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.libTypeVehicule.toString(),
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: AppThemeData.regular,
                        color: themeChange.getThem()
                            ? AppThemeData.grey900Dark
                            : AppThemeData.grey900,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Constant().amountShow(amount: data.prix.toString()),
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: AppThemeData.regular,
                            color: themeChange.getThem()
                                ? AppThemeData.grey400
                                : AppThemeData.grey300Dark,
                          ),
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: AppThemeData.secondary200,
                              borderRadius: BorderRadius.circular(4)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 3.0, horizontal: 6),
                            child: Text(
                              data.statut ?? '',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: AppThemeData.regular,
                                color: themeChange.getThem()
                                    ? AppThemeData.grey900Dark
                                    : AppThemeData.grey900,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        " ${data.dateDebut.toString()} to ${data.dateFin.toString()}",
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: AppThemeData.regular,
                          color: themeChange.getThem()
                              ? AppThemeData.grey400
                              : AppThemeData.grey300Dark,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Visibility(
              visible:
                  data.statut == 'in progress' || data.statut == 'accepted',
              child: ButtonThem.buildButton(context,
                  title: "Cancel".tr,
                  btnHeight: 46,
                  txtColor: themeChange.getThem()
                      ? AppThemeData.grey900
                      : AppThemeData.grey900Dark, onPress: () {
                Map<String, dynamic> bodyParams = {
                  'id': data.id.toString(),
                };
                controller.cancelBooking(bodyParams).then((value) {
                  if (value != null) {
                    Get.back();
                    controller.getRentedData();
                  }
                });
              })),
        ],
      ),
    );
  }
}
