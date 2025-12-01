import 'package:cabme/constant/constant.dart';
import 'package:cabme/controller/driver_profile_controller.dart';
import 'package:cabme/themes/appbar_cust.dart';
import 'package:cabme/themes/constant_colors.dart';
import 'package:cabme/themes/responsive.dart';
import 'package:cabme/utils/dark_theme_provider.dart';
import 'package:cached_network_image/cached_network_image.dart'
    show CachedNetworkImage;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class DriverProfileScreen extends StatelessWidget {
  const DriverProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
        init: DriverProfileController(),
        builder: (controller) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: CustomAppbar(
              title: 'Driver Details'.tr,
              bgColor: AppThemeData.primary200,
            ),
            body: controller.isLoading.value
                ? Constant.loader(context)
                : controller.driverDetails != null
                    ? Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                              child: vehicleDetailsWidget(
                                  themeChange.getThem(),
                                  "Total completed ride:".tr,
                                  controller.driverDetails != null &&
                                          controller
                                                  .driverDetails!.value.data !=
                                              null
                                      ? controller.driverDetails!.value.data!
                                          .totalCompletedRide
                                          .toString()
                                      : "0"),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text("Driver Documents".tr,
                                style: TextStyle(
                                  fontFamily: AppThemeData.semiBold,
                                  color: themeChange.getThem()
                                      ? AppThemeData.grey900Dark
                                      : AppThemeData.grey900,
                                  fontSize: 16,
                                )),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
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
                              child: ListView.builder(
                                itemCount: controller.driverDetails != null &&
                                        controller.driverDetails!.value.data !=
                                            null
                                    ? controller.driverDetails!.value.data!
                                        .documents!.length
                                    : 0,
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                itemBuilder: (context, index) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          controller.driverDetails != null &&
                                                  controller.driverDetails!
                                                          .value.data !=
                                                      null &&
                                                  controller
                                                          .driverDetails!
                                                          .value
                                                          .data!
                                                          .documents![index]
                                                          .title !=
                                                      null
                                              ? controller
                                                  .driverDetails!
                                                  .value
                                                  .data!
                                                  .documents![index]
                                                  .title!
                                                  .tr
                                              : "",
                                          style: TextStyle(
                                            fontFamily: AppThemeData.medium,
                                            color: themeChange.getThem()
                                                ? AppThemeData.grey900Dark
                                                : AppThemeData.grey900,
                                            fontSize: 16,
                                          )),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        child: CachedNetworkImage(
                                          height:
                                              Responsive.height(20, context),
                                          width: Responsive.width(90, context),
                                          fit: BoxFit.cover,
                                          imageUrl: controller.driverDetails !=
                                                      null &&
                                                  controller.driverDetails!
                                                          .value.data !=
                                                      null &&
                                                  controller
                                                          .driverDetails!
                                                          .value
                                                          .data!
                                                          .documents![index]
                                                          .documentPath !=
                                                      null
                                              ? controller
                                                  .driverDetails!
                                                  .value
                                                  .data!
                                                  .documents![index]
                                                  .documentPath!
                                              : "",
                                          placeholder: (context, url) =>
                                              Constant.loader(
                                            context,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text("Vehicle Details".tr,
                                style: TextStyle(
                                  fontFamily: AppThemeData.semiBold,
                                  color: themeChange.getThem()
                                      ? AppThemeData.grey900Dark
                                      : AppThemeData.grey900,
                                  fontSize: 16,
                                )),
                            SizedBox(
                              height: 5,
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
                                  vehicleDetailsWidget(
                                      themeChange.getThem(),
                                      "Vehicle name".tr,
                                      controller.driverDetails != null &&
                                              controller.driverDetails!.value
                                                      .data !=
                                                  null &&
                                              controller.driverDetails!.value
                                                      .data!.vehicle !=
                                                  null
                                          ? "${controller.driverDetails!.value.data!.vehicle!.vehicleType!.libelle}"
                                          : ""),
                                  Container(
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey300Dark
                                        : AppThemeData.grey300,
                                    height: 1,
                                  ),
                                  vehicleDetailsWidget(
                                      themeChange.getThem(),
                                      "Make".tr,
                                      controller.driverDetails != null &&
                                              controller.driverDetails!.value
                                                      .data !=
                                                  null &&
                                              controller.driverDetails!.value
                                                      .data!.vehicle !=
                                                  null
                                          ? controller.driverDetails!.value
                                              .data!.vehicle!.carMake
                                              .toString()
                                          : ""),
                                  Container(
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey300Dark
                                        : AppThemeData.grey300,
                                    height: 1,
                                  ),
                                  vehicleDetailsWidget(
                                      themeChange.getThem(),
                                      "Model".tr,
                                      controller.driverDetails != null &&
                                              controller.driverDetails!.value
                                                      .data !=
                                                  null &&
                                              controller.driverDetails!.value
                                                      .data!.vehicle !=
                                                  null
                                          ? controller.driverDetails!.value
                                              .data!.vehicle!.model
                                              .toString()
                                          : ""),
                                  Container(
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey300Dark
                                        : AppThemeData.grey300,
                                    height: 1,
                                  ),
                                  vehicleDetailsWidget(
                                      themeChange.getThem(),
                                      "Brand".tr,
                                      controller.driverDetails != null &&
                                              controller.driverDetails!.value
                                                      .data !=
                                                  null &&
                                              controller.driverDetails!.value
                                                      .data!.vehicle !=
                                                  null
                                          ? controller.driverDetails!.value
                                              .data!.vehicle!.brand
                                              .toString()
                                          : ""),
                                  Container(
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey300Dark
                                        : AppThemeData.grey300,
                                    height: 1,
                                  ),
                                  vehicleDetailsWidget(
                                      themeChange.getThem(),
                                      "Color".tr,
                                      controller.driverDetails != null &&
                                              controller.driverDetails!.value
                                                      .data !=
                                                  null &&
                                              controller.driverDetails!.value
                                                      .data!.vehicle !=
                                                  null
                                          ? controller.driverDetails!.value
                                              .data!.vehicle!.color
                                              .toString()
                                          : ""),
                                  Container(
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey300Dark
                                        : AppThemeData.grey300,
                                    height: 1,
                                  ),
                                  vehicleDetailsWidget(
                                      themeChange.getThem(),
                                      "Vehicle Number".tr,
                                      controller.driverDetails != null &&
                                              controller.driverDetails!.value
                                                      .data !=
                                                  null &&
                                              controller.driverDetails!.value
                                                      .data!.vehicle !=
                                                  null
                                          ? controller.driverDetails!.value
                                              .data!.vehicle!.numberplate
                                              .toString()
                                          : ""),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    : Offstage(),
          );
        });
  }

  vehicleDetailsWidget(bool isDarkMode, String title, String name) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(title.tr,
                maxLines: 1,
                style: TextStyle(
                  fontFamily: AppThemeData.regular,
                  color: isDarkMode
                      ? AppThemeData.grey900Dark
                      : AppThemeData.grey900,
                  fontSize: 16,
                )),
          ),
          Expanded(
            flex: 1,
            child: Text(name,
                textAlign: TextAlign.end,
                maxLines: 1,
                style: TextStyle(
                  fontFamily: AppThemeData.medium,
                  color: isDarkMode
                      ? AppThemeData.grey500Dark
                      : AppThemeData.grey500,
                  fontSize: 16,
                )),
          ),
        ],
      ),
    );
  }
}
