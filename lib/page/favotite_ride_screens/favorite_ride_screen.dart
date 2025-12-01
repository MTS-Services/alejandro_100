import 'package:cabme/constant/constant.dart';
import 'package:cabme/constant/show_toast_dialog.dart';
import 'package:cabme/controller/favorite_controller.dart';
import 'package:cabme/themes/appbar_cust.dart';
import 'package:cabme/themes/button_them.dart';
import 'package:cabme/themes/constant_colors.dart';
import 'package:cabme/themes/responsive.dart';
import 'package:cabme/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../model/favorite_model.dart';

class FavoriteRideScreen extends StatelessWidget {
  const FavoriteRideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<FavoriteController>(
      init: FavoriteController(),
      builder: (controller) {
        return Scaffold(
            backgroundColor: ConstantColors.background,
            appBar: CustomAppbar(
              title: 'Favourite Rides'.tr,
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
                        flex: 10,
                        child: Container(
                          color: themeChange.getThem() ? AppThemeData.surface50Dark : AppThemeData.surface50,
                        )),
                  ],
                ),
                SafeArea(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: RefreshIndicator(
                          onRefresh: () => controller.favouriteData(),
                          child: controller.isLoading.value
                              ? SizedBox()
                              : controller.favouriteList.isEmpty
                                  ? Padding(
                                      padding: EdgeInsets.only(top: Responsive.height(14, context)),
                                      child: Constant.emptyView(context, "You have not any favourite ride", true),
                                    )
                                  : ListView.builder(
                                      itemCount: controller.favouriteList.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return newRideWidgets(context, controller, controller.favouriteList[index], index);
                                      }),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ));
      },
    );
  }

  Widget newRideWidgets(BuildContext context, FavoriteController controller, Data data, int index) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 10,
      ),
      child: Container(
        decoration: BoxDecoration(
            color: themeChange.getThem() ? AppThemeData.surface50Dark : AppThemeData.surface50,
            border: Border.all(color: themeChange.getThem() ? AppThemeData.grey200Dark : AppThemeData.grey200)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/ic_location.svg',
                        colorFilter: ColorFilter.mode(
                          AppThemeData.success300,
                          BlendMode.srcIn,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            data.departName.toString(),
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: AppThemeData.regular,
                              color: themeChange.getThem() ? AppThemeData.grey400 : AppThemeData.grey300Dark,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: List.generate(
                        3,
                        (index) => Container(
                            margin: const EdgeInsets.all(2),
                            width: 3,
                            height: 3,
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                              shape: BoxShape.circle,
                            )),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/ic_location.svg',
                        colorFilter: ColorFilter.mode(
                          AppThemeData.warning200,
                          BlendMode.srcIn,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            data.destinationName.toString(),
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: AppThemeData.regular,
                              color: themeChange.getThem() ? AppThemeData.grey400 : AppThemeData.grey300Dark,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/icons/ic_distance.png",
                                height: 24,
                                width: 24,
                                color: AppThemeData.primary200,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text("${data.distance} ${data.distanceUnit}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: AppThemeData.regular,
                                      color: themeChange.getThem() ? AppThemeData.grey400 : AppThemeData.grey300Dark,
                                    )),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Icon(
                                Icons.date_range,
                                color: AppThemeData.primary200,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text("${data.creer}m",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: AppThemeData.regular,
                                      color: themeChange.getThem() ? AppThemeData.grey400 : AppThemeData.grey300Dark,
                                    )),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: themeChange.getThem() ? AppThemeData.grey200Dark : AppThemeData.grey200,
              height: 1,
            ),
            ButtonThem.buildIconButton(context, btnWidthRatio: 1, btnHeight: 50, title: 'delete'.tr, onPress: () {
              deleteFavDialog(context, themeChange.getThem(), controller, index);
            }, iconColor: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey900Dark, icon: Icons.delete),
          ],
        ),
      ),
    );
  }

  deleteFavDialog(BuildContext context, bool isDarkMode, FavoriteController controller, int index) {
    Widget continueButton = TextButton(
      child: Text(
        "Yes".tr,
        style: TextStyle(
          fontSize: 14,
          fontFamily: AppThemeData.medium,
          color: AppThemeData.primary200,
        ),
      ),
      onPressed: () {
        Get.back();
        controller.deleteFavouriteRide(controller.favouriteList[index].id.toString()).then((value) {
          if (value != null) {
            if (value['success'] == "success") {
              controller.favouriteList.removeAt(index);
              ShowToastDialog.showToast("Favourite ride delete successfully");
            } else {
              ShowToastDialog.showToast(value['error']);
            }
          }
        });
      },
    );
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(
        "No".tr,
        style: TextStyle(
          fontSize: 14,
          fontFamily: AppThemeData.medium,
          color: AppThemeData.primary200,
        ),
      ),
      onPressed: () {
        Get.back();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      surfaceTintColor: isDarkMode ? AppThemeData.surface50Dark : AppThemeData.surface50,
      backgroundColor: isDarkMode ? AppThemeData.surface50Dark : AppThemeData.surface50,
      title: Text(
        "Delete Favourite".tr,
        style: TextStyle(
          fontSize: 20,
          fontFamily: AppThemeData.semiBold,
          color: isDarkMode ? AppThemeData.grey50 : AppThemeData.grey50Dark,
        ),
      ),
      content: Text(
        "Are you sure you want to delete favourite ride?".tr,
        style: TextStyle(
          fontSize: 16,
          fontFamily: AppThemeData.medium,
          color: isDarkMode ? AppThemeData.grey50 : AppThemeData.grey50Dark,
        ),
      ),
      actions: [
        continueButton,
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
