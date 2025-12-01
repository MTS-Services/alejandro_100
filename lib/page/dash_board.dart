// ignore_for_file: must_be_immutable

import 'package:cabme/constant/constant.dart';
import 'package:cabme/controller/dash_board_controller.dart';
import 'package:cabme/page/home_screens/home_osm_screen.dart';
import 'package:cabme/page/home_screens/home_screen.dart';
import 'package:cabme/themes/constant_colors.dart';
import 'package:cabme/themes/responsive.dart';
import 'package:cabme/utils/dark_theme_provider.dart';
import 'package:cabme/utils/Preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class DashBoard extends StatelessWidget {
  DashBoard({super.key});

  DateTime backPress = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashBoardController>(
      init: DashBoardController(),
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            final timeGap = DateTime.now().difference(backPress);
            final cantExit = timeGap >= const Duration(seconds: 2);
            backPress = DateTime.now();
            if (cantExit) {
              var snack = SnackBar(
                content: Text(
                  'Press Back button again to Exit'.tr,
                  style: TextStyle(color: Colors.white),
                ),
                duration: Duration(seconds: 2),
                backgroundColor: Colors.black,
              );
              ScaffoldMessenger.of(context).showSnackBar(snack);
              return false; // false will do nothing when back press
            } else {
              return true; // true will exit the app
            }
          },
          child: Scaffold(
            body: (Constant.selectedMapType == 'osm' &&
                    controller.selectedDrawerIndex.value == 0)
                ? const HomeOSMScreen()
                : const HomeScreen(),
          ),
        );
      },
    );
  }

  // buildAppDrawers(BuildContext context, DashBoardController controller) {
  //   var drawerOptions = <Widget>[];
  //   for (var i = 0; i < controller.drawerItems.length; i++) {
  //     var d = controller.drawerItems[i];
  //     drawerOptions.add(ListTile(
  //       leading: Icon(d.icon),
  //       title: Text(d.title),
  //       selected: i == controller.selectedDrawerIndex.value,
  //       onTap: () => controller.onSelectItem(i),
  //     ));
  //   }
  //   return Drawer(
  //     child: ListView(
  //       padding: EdgeInsets.zero,
  //       children: [
  //         controller.userModel == null
  //             ? Center(
  //                 child: CircularProgressIndicator(color: AppThemeData.primary200),
  //               )
  //             : UserAccountsDrawerHeader(
  //                 decoration: BoxDecoration(
  //                   color: AppThemeData.primary200,
  //                 ),
  //                 currentAccountPicture: ClipOval(
  //                   child: Padding(
  //                     padding: const EdgeInsets.all(3.0040096),
  //                     child: ClipOval(
  //                       child: Container(
  //                         color: Colors.white,
  //                         child: CachedNetworkImage(
  //                           imageUrl: controller.userModel!.data!.photoPath.toString(),
  //                           fit: BoxFit.cover,
  //                           placeholder: (context, url) => Constant.loader(),
  //                           errorWidget: (context, url, error) => Image.asset(
  //                             "assets/images/appIcon.png",
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 accountName: Text(
  //                   "${controller.userModel!.data!.prenom} ${controller.userModel!.data!.nom}",
  //                   style: const TextStyle(color: Colors.white),
  //                 ),
  //                 accountEmail: Text(controller.userModel!.data!.email.toString(), style: const TextStyle(color: Colors.white)),
  //               ),
  //         Column(children: drawerOptions),
  //         Text(
  //           'V : ${Constant.appVersion}',
  //           textAlign: TextAlign.center,
  //           style: const TextStyle(fontSize: 16),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}

buildAppDrawer(BuildContext context, DashBoardController controller) {
  final themeChange = Provider.of<DarkThemeProvider>(context);
  final bool isGuestUser = Preferences.getBoolean(Preferences.isGuestUser);

  // Get fresh drawer items each time to ensure translations are current
  final drawerItems = controller.getDrawerItems();

  var drawerOptions = <Widget>[];
  for (var i = 0; i < drawerItems.length; i++) {
    var d = drawerItems[i];
    drawerOptions.add(InkWell(
      onTap: () {
        controller.onSelectItem(i);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Visibility(
            visible: d.section != null,
            child: Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 10, left: 16),
              child: Text(
                d.section ?? '',
                style: TextStyle(
                  color: themeChange.getThem()
                      ? AppThemeData.grey500Dark
                      : AppThemeData.grey300Dark,
                  fontSize: 14,
                  fontFamily: AppThemeData.regular,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  SvgPicture.asset(
                    d.icon,
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      drawerItems[i].title ==
                              drawerItems[drawerItems.length - 1].title
                          ? AppThemeData.error200
                          : controller.selectedDrawerIndex.value == i
                              ? AppThemeData.primary200
                              : themeChange.getThem()
                                  ? AppThemeData.grey900Dark
                                  : AppThemeData.grey900,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Text(
                    d.title ?? 'guest'.tr,
                    style: TextStyle(
                      color: drawerItems[i].title ==
                              drawerItems[drawerItems.length - 1].title
                          ? AppThemeData.error200
                          : controller.selectedDrawerIndex.value == i
                              ? AppThemeData.primary200
                              : themeChange.getThem()
                                  ? AppThemeData.grey900Dark
                                  : AppThemeData.grey900,
                      fontSize: 16,
                      fontFamily: AppThemeData.medium,
                    ),
                  ),
                ]),
                d.isSwitch == null
                    ? SvgPicture.asset(
                        'assets/icons/ic_right_arrow.svg',
                        width: 20,
                        height: 20,
                        colorFilter: ColorFilter.mode(
                          themeChange.getThem()
                              ? AppThemeData.grey400Dark
                              : AppThemeData.grey400,
                          BlendMode.srcIn,
                        ),
                      )
                    : SizedBox(
                        height: 25,
                        child: Switch(
                          trackOutlineColor:
                              WidgetStateProperty.resolveWith<Color>(
                                  (Set<WidgetState> states) {
                            return Colors.transparent;
                          }),
                          inactiveTrackColor: themeChange.getThem()
                              ? AppThemeData.grey300Dark
                              : AppThemeData.grey300,
                          activeTrackColor: AppThemeData.primary200,
                          thumbColor: WidgetStateProperty.resolveWith<Color>(
                              (Set<WidgetState> states) {
                            return themeChange.getThem()
                                ? AppThemeData.grey50
                                : AppThemeData.grey50Dark;
                          }),
                          value: themeChange.getThem(),
                          onChanged: (value) =>
                              (themeChange.darkTheme = value == true ? 0 : 1),
                        ),
                      ),
              ],
            ),
          ),
          if ((drawerItems.length - 2) > i)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              height: 0.5,
              color: themeChange.getThem()
                  ? AppThemeData.grey200Dark
                  : AppThemeData.grey200,
            )
        ],
      ),
    ));
  }
  return Drawer(
    width: Responsive.width(85, context),
    backgroundColor: themeChange.getThem()
        ? AppThemeData.surface50Dark
        : AppThemeData.surface50,
    child: ListView(
      children: [
        const SizedBox(height: 40),
        isGuestUser
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () {},
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(80.0),
                        child: Image.asset(
                          "assets/images/appIcon.png",
                          height: 120,
                          width: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      "Guest User".tr,
                      style: TextStyle(
                        color: themeChange.getThem()
                            ? AppThemeData.grey900Dark
                            : AppThemeData.grey900,
                        fontSize: 22,
                        fontFamily: AppThemeData.regular,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Sign in to access all features'.tr,
                      style: TextStyle(
                        color: themeChange.getThem()
                            ? AppThemeData.grey500Dark
                            : AppThemeData.grey500,
                        fontSize: 14,
                        fontFamily: AppThemeData.regular,
                      ),
                    ),
                  )
                ],
              )
            : controller.userModel == null
                ? Center(
                    child: CircularProgressIndicator(
                        color: AppThemeData.primary200),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: () {},
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(80.0),
                            child: controller
                                        .userModel?.data?.photoPath?.isEmpty ==
                                    true
                                ? CachedNetworkImage(
                                    imageUrl: Constant.placeholderUrl,
                                    height: 120,
                                    width: 120,
                                    fit: BoxFit.cover,
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) =>
                                            Center(
                                      child: CircularProgressIndicator(
                                          value: downloadProgress.progress),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        color: themeChange.getThem()
                                            ? AppThemeData.surface50
                                            : AppThemeData.surface50Dark,
                                        borderRadius:
                                            BorderRadius.circular(80.0),
                                      ),
                                      child: Image.asset(
                                        "assets/icons/app_logo.png",
                                        // "assets/images/appIcon.png",
                                      ),
                                    ),
                                  )
                                : CachedNetworkImage(
                                    imageUrl:
                                        controller.userModel?.data?.photoPath ??
                                            '',
                                    height: 120,
                                    width: 120,
                                    fit: BoxFit.cover,
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) =>
                                            Center(
                                      child: CircularProgressIndicator(
                                          value: downloadProgress.progress),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        color: themeChange.getThem()
                                            ? AppThemeData.surface50
                                            : AppThemeData.surface50Dark,
                                        borderRadius:
                                            BorderRadius.circular(80.0),
                                      ),
                                      child: Image.asset(
                                        "assets/icons/app_logo.png",
                                        // "assets/images/appIcon.png",
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          "${controller.userModel!.data!.prenom} ${controller.userModel!.data!.nom}",
                          style: TextStyle(
                            color: themeChange.getThem()
                                ? AppThemeData.grey900Dark
                                : AppThemeData.grey900,
                            fontSize: 22,
                            fontFamily: AppThemeData.regular,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '${controller.userModel!.data!.email}',
                          style: TextStyle(
                            color: themeChange.getThem()
                                ? AppThemeData.grey500Dark
                                : AppThemeData.grey500,
                            fontSize: 14,
                            fontFamily: AppThemeData.regular,
                          ),
                        ),
                      )
                    ],
                  ),
        const SizedBox(height: 30),
        Column(children: drawerOptions),
      ],
    ),
  );
}

class DrawerItem {
  String? title;
  String? icon;
  String? section;
  bool? isSwitch;

  DrawerItem(this.title, this.icon, {this.section, this.isSwitch});
}
