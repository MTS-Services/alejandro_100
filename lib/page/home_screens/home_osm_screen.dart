import 'dart:developer';
import 'dart:io';

import 'package:cabme/constant/constant.dart';
import 'package:cabme/constant/show_toast_dialog.dart';
import 'package:cabme/controller/dash_board_controller.dart';
import 'package:cabme/controller/home_osm_controller.dart';
import 'package:cabme/controller/parcel_service_controller.dart';
import 'package:cabme/model/driver_model.dart';
import 'package:cabme/model/vehicle_category_model.dart';
import 'package:cabme/page/dash_board.dart';
import 'package:cabme/page/home_screens/loading_screen.dart';
import 'package:cabme/page/home_screens/sucess_screen.dart';
import 'package:cabme/page/parcel_service_screen/book_parcel_screen.dart';
import 'package:cabme/themes/button_them.dart';
import 'package:cabme/themes/constant_colors.dart';
import 'package:cabme/themes/radio_button.dart';
import 'package:cabme/themes/responsive.dart';
import 'package:cabme/themes/text_field_them.dart';
import 'package:cabme/utils/Preferences.dart';
import 'package:cabme/utils/dark_theme_provider.dart';
import 'package:cabme/widget/StarRating.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class HomeOSMScreen extends StatefulWidget {
  const HomeOSMScreen({super.key});

  @override
  State<HomeOSMScreen> createState() => _HomeOSMScreenState();
}

class _HomeOSMScreenState extends State<HomeOSMScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final dashBoardController = Get.put(DashBoardController());
  final Location currentLocation = Location();

  /// Helper function to translate parcel category titles
  /// This function maps the fixed backend parcel category titles to their translated versions
  ///
  /// Example usage:
  /// - When backend returns "Documents", this returns "Documents".tr (localized version)
  /// - When backend returns "Moving Services", this returns "Servicios de Mudanza" (Spanish)
  /// - When backend returns "Container Rental", this returns "Location de Conteneurs" (French)
  ///
  /// Supported categories:
  /// - Documents
  /// - Construction Aggregates
  /// - Medium Sized Packages
  /// - Moving Services
  /// - Tow Truck Service
  /// - Container Rental
  /// - Transport of Material
  /// - Others
  String translateParcelCategory(String categoryTitle) {
    switch (categoryTitle) {
      case 'Documents':
        return 'Documents'.tr;
      case 'Construction Aggregates':
        return 'Construction Aggregates'.tr;
      case 'Medium Sized Packages':
        return 'Medium Sized Packages'.tr;
      case 'Moving Services':
        return 'Moving Services'.tr;
      case 'Tow Truck Service':
        return 'Tow Truck Service'.tr;
      case 'Container Rental':
        return 'Container Rental'.tr;
      case 'Transport of Material':
        return 'Transport of Material'.tr;
      case 'Others':
        return 'Others'.tr;
      default:
        // If no match found, return the original title
        return categoryTitle;
    }
  }

  String getServiceIcon(String title) {
    switch (title.toLowerCase()) {
      case "documents":
        return 'assets/icons/ic_documents.png';
      case "construction aggregates":
        return 'assets/icons/ic_construction_aggregate.png';
      case "medium sized packages":
        return 'assets/icons/ic_medium_sized_pacakge.png';
      case "moving services":
        return 'assets/icons/ic_medium_sized_packages.png';
      case "tow truck service":
        return 'assets/icons/ic_tow_truck.png';
      case "container rental":
        return 'assets/icons/ic_brick.png';
      case "transport of material":
        return 'assets/icons/ic_box.png';
      case "others":
        return 'assets/icons/ic_others.png';
      default:
        return 'assets/icons/ic_box.png'; // fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      key: _scaffoldKey,
      drawer: buildAppDrawer(context, dashBoardController),
      body: GetX<HomeOsmController>(
          init: HomeOsmController(),
          builder: (controller) {
            // Add dependency on currentLanguage to force rebuild on language change
            controller.currentLanguage.value;

            return Stack(alignment: AlignmentDirectional.topStart, children: [
              if (Constant.homeScreenType == 'OlaHome')
                Container(
                  color: AppThemeData.primary200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(flex: 3, child: SizedBox()),
                      Expanded(
                        flex: 13,
                        child: Container(
                          color: themeChange.getThem()
                              ? AppThemeData.surface50Dark
                              : AppThemeData.surface50,
                        ),
                      ),
                    ],
                  ),
                ),
              controller.isHomePageLoading.value
                  ? LoadingScreen(controller: controller)
                  : setRouteWidget(
                      Column(
                        children: [
                          if (Constant.homeScreenType == 'OlaHome')
                            Column(
                              children: [
                                // AppBar with address only (in yellow background)
                                _olaHomeAppBar(
                                  controller: controller,
                                  isDarkMode: themeChange.getThem(),
                                  context: context,
                                  scaffoldKey: _scaffoldKey,
                                ),
                                // Servicios card, centered below
                                _olaHomeServiciosCard(themeChange),
                              ],
                            ),
                          if (Constant.homeScreenType != 'OlaHome')
                            Expanded(
                              flex: 1,
                              child: Stack(children: [
                                OSMFlutter(
                                    controller: controller.mapController,
                                    osmOption: OSMOption(
                                      userTrackingOption:
                                          const UserTrackingOption(
                                        enableTracking: false,
                                        unFollowUser: false,
                                      ),
                                      zoomOption: const ZoomOption(
                                        initZoom: 14,
                                        minZoomLevel: 2,
                                        maxZoomLevel: 19,
                                        stepZoom: 1.0,
                                      ),
                                      roadConfiguration: RoadOption(
                                        roadWidth: Platform.isIOS ? 50 : 10,
                                        roadColor: Colors.blue,
                                        roadBorderWidth: Platform.isIOS
                                            ? 15
                                            : 10, // Set the road border width (outline)
                                        roadBorderColor:
                                            Colors.black, // Border color
                                        zoomInto: true,
                                      ),
                                    ),
                                    onMapIsReady: (active) async {
                                      if (active) {
                                        controller.getCurrentAddress(
                                            setMarker: true);
                                        ShowToastDialog.closeLoader();
                                      }
                                    }),
                                SafeArea(
                                    child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                ))
                              ]),
                            ),
                          if (Constant.homeScreenType == 'OlaHome')
                            Container(
                              padding: EdgeInsets.only(
                                  top: Constant.homeScreenType == 'OlaHome'
                                      ? 10
                                      : 0),
                              height: Responsive.height(
                                  Constant.homeScreenType != 'OlaHome'
                                      ? 44
                                      : 86,
                                  context),
                              color: themeChange.getThem()
                                  ? AppThemeData.surface50Dark
                                  : AppThemeData.surface50,
                              child: Theme(
                                  data: ThemeData(
                                    tabBarTheme: TabBarThemeData(
                                      indicatorColor: AppThemeData.primary200,
                                    ),
                                  ),
                                  child:
                                      Constant.parcelActive.toString() == "yes"
                                          ? SizedBox(
                                              child: GetX<
                                                      ParcelServiceController>(
                                                  init:
                                                      ParcelServiceController(),
                                                  builder:
                                                      (parcelServiceController) {
                                                    return Padding(
                                                      padding: EdgeInsets.symmetric(
                                                          horizontal:
                                                              Constant.homeScreenType ==
                                                                      'OlaHome'
                                                                  ? 0
                                                                  : 16),
                                                      child:
                                                          SingleChildScrollView(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const SizedBox(
                                                                height: 20),
                                                            Text(
                                                              "Select what are you sending?"
                                                                  .tr,
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                fontFamily:
                                                                    AppThemeData
                                                                        .semiBold,
                                                                color: themeChange.getThem()
                                                                    ? AppThemeData
                                                                        .grey900Dark
                                                                    : AppThemeData
                                                                        .grey900,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 12),
                                                            Container(
                                                              width: double
                                                                  .infinity,
                                                              color: Colors
                                                                  .transparent,
                                                              child: ListView
                                                                  .separated(
                                                                primary: false,
                                                                padding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                separatorBuilder: (context,
                                                                        index) =>
                                                                    SizedBox(
                                                                        height:
                                                                            12),
                                                                shrinkWrap:
                                                                    true,
                                                                itemCount:
                                                                    parcelServiceController
                                                                        .parcelCategoryList
                                                                        .length,
                                                                itemBuilder:
                                                                    (BuildContext
                                                                            context,
                                                                        int index) {
                                                                  final item =
                                                                      parcelServiceController
                                                                              .parcelCategoryList[
                                                                          index];
                                                                  return InkWell(
                                                                    splashColor:
                                                                        Colors
                                                                            .transparent,
                                                                    onTap: () {
                                                                      parcelServiceController
                                                                          .selectedParcelCategory
                                                                          .value = item;
                                                                      Get.to(() =>
                                                                          const BookParcelScreen());
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: themeChange.getThem()
                                                                            ? AppThemeData.surface50Dark
                                                                            : Colors.white,
                                                                        borderRadius:
                                                                            BorderRadius.circular(16),
                                                                        boxShadow: [
                                                                          BoxShadow(
                                                                            color:
                                                                                Colors.black.withOpacity(0.06),
                                                                            blurRadius:
                                                                                8,
                                                                            offset:
                                                                                Offset(0, 2),
                                                                          ),
                                                                        ],
                                                                        border:
                                                                            Border.all(
                                                                          color: themeChange.getThem()
                                                                              ? AppThemeData.grey300Dark.withOpacity(0.2)
                                                                              : Color(0xFFE9E9E9),
                                                                          width:
                                                                              1.5,
                                                                        ),
                                                                      ),
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          vertical:
                                                                              14,
                                                                          horizontal:
                                                                              14),
                                                                      child:
                                                                          Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: [
                                                                          // Icon/image (left)
                                                                          Image
                                                                              .asset(
                                                                            getServiceIcon(item.title.toString()),
                                                                            height:
                                                                                20,
                                                                            width:
                                                                                20,
                                                                            fit:
                                                                                BoxFit.contain,
                                                                          ),
                                                                          const SizedBox(
                                                                              width: 18),
                                                                          // Name
                                                                          Expanded(
                                                                            child:
                                                                                Text(
                                                                              item.title.toString().tr,
                                                                              style: TextStyle(
                                                                                fontSize: 16,
                                                                                fontFamily: AppThemeData.semiBold,
                                                                                color: themeChange.getThem() ? AppThemeData.grey900Dark : Colors.black,
                                                                              ),
                                                                              maxLines: 2,
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                              width: 8),
                                                                          // Arrow
                                                                          Icon(
                                                                            Icons.arrow_forward_ios_rounded,
                                                                            size:
                                                                                18,
                                                                            color: themeChange.getThem()
                                                                                ? AppThemeData.grey500Dark
                                                                                : Colors.grey[400],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 20,
                                                            ),
                                                            ListView.builder(
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              primary: false,
                                                              shrinkWrap: true,
                                                              itemCount:
                                                                  controller
                                                                      .bannerModel
                                                                      .value
                                                                      .data
                                                                      ?.length,
                                                              itemBuilder:
                                                                  (BuildContext
                                                                          context,
                                                                      int i) {
                                                                return Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          bottom:
                                                                              20),
                                                                  child: Center(
                                                                    child:
                                                                        Stack(
                                                                      alignment:
                                                                          Alignment
                                                                              .bottomLeft,
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .symmetric(
                                                                              horizontal: 16,
                                                                              vertical: 12),
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              const SizedBox(height: 2),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                            )
                                          : Offstage()),
                            )
                        ],
                      ),
                    ),
            ]);
          }),
    );
  }

  Widget setRouteWidget(Widget child) {
    if (Constant.homeScreenType == 'OlaHome') {
      return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16), child: child);
    } else {
      return child;
    }
  }

  Widget _olaHomeAppBar({
    required HomeOsmController controller,
    required bool isDarkMode,
    required BuildContext context,
    required GlobalKey<ScaffoldState> scaffoldKey,
  }) {
    return Container(
      width: double.infinity,
      color: AppThemeData.primary200,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: SafeArea(
        bottom: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                scaffoldKey.currentState?.openDrawer();
              },
              icon: SvgPicture.asset(
                "assets/icons/ic_menu_fill.svg",
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                controller.currentLocationController.text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // NEW: Servicios card (centered, separated below appbar)
  Widget _olaHomeServiciosCard(DarkThemeProvider themeChange) {
    return Container(
      alignment: Alignment.center,
      transform: Matrix4.translationValues(0, -15, 0), // overlap effect
      margin: const EdgeInsets.symmetric(
          horizontal: 16), // smaller horizontal margin
      child: Container(
        width: double.infinity,
        height: 56, // Match the height in your new image (image3)
        decoration: BoxDecoration(
          color: themeChange.getThem()
              ? Colors.black
              : Colors.white, // Black for dark, white for light
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: themeChange.getThem()
                  ? Colors.black.withOpacity(0.16)
                  : Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: themeChange.getThem()
                ? Colors.white.withOpacity(0.08)
                : const Color(0xFFE9E9E9),
            width: 2,
          ),
        ),
        padding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 18), // remove vertical padding for tighter look
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/ic_parcel_icon.svg',
              width: 28,
              height: 28,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 12),
            Text(
              'Services'.tr,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: themeChange.getThem() ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
      {required title, required TextEditingController textController}) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: TextField(
        controller: textController,
        textInputAction: TextInputAction.done,
        style: TextStyle(color: ConstantColors.titleTextColor),
        decoration: InputDecoration(
          hintText: title,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabled: false,
        ),
      ),
    );
  }

  confirmWidget(bool isDarkMode, HomeOsmController controller) {
    return ButtonThem.buildButton(context,
        title: "Search Destination".tr,
        btnColor: AppThemeData.primary200,
        txtColor: Colors.white, onPress: () async {
      if (controller.roadInfo.value.distance != null) {
        await controller.getUserPendingPayment().then(
          (value) async {
            if (value != null) {
              if (value['success'] == "success") {
                if (value['data']['amount'] != 0) {
                  _pendingPaymentDialog(context);
                } else {
                  controller.distance.value =
                      controller.roadInfo.value.distance!;
                  int hours = double.parse(
                          controller.roadInfo.value.duration.toString()) ~/
                      3600;
                  int minutes = ((double.parse(controller
                                  .roadInfo.value.duration
                                  .toString()) %
                              3600) /
                          60)
                      .round();
                  controller.duration.value = '$hours hours $minutes minutes';

                  // Get.back();
                  controller.confirmWidgetVisible.value = false;
                  tripOptionBottomSheet(context, isDarkMode, controller);
                }
              } else {
                controller.distance.value = controller.roadInfo.value.distance!;
                int hours = double.parse(
                        controller.roadInfo.value.duration.toString()) ~/
                    3600;
                int minutes = ((double.parse(
                                controller.roadInfo.value.duration.toString()) %
                            3600) /
                        60)
                    .round();
                controller.duration.value = '$hours hours $minutes minutes';
                controller.confirmWidgetVisible.value = false;
                // Get.back();
                tripOptionBottomSheet(context, isDarkMode, controller);
              }
            }
          },
        );
      }
    });
  }

  final passengerController = TextEditingController(text: "1");

  tripOptionBottomSheet(
      BuildContext context, bool isDarkMode, HomeOsmController controller) {
    return showModalBottomSheet(
        barrierColor:
            isDarkMode ? AppThemeData.grey800.withAlpha(200) : Colors.black26,
        isDismissible: true,
        isScrollControlled: true,
        context: context,
        backgroundColor:
            isDarkMode ? AppThemeData.surface50Dark : AppThemeData.surface50,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          height: 8,
                          width: 75,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: isDarkMode
                                ? AppThemeData.grey300Dark
                                : AppThemeData.grey300,
                          )),
                    ),
                    IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: Transform(
                          alignment: Alignment.center,
                          transform:
                              Directionality.of(context) == TextDirection.rtl
                                  ? Matrix4.rotationY(3.14159)
                                  : Matrix4.identity(),
                          child: SvgPicture.asset(
                            'assets/icons/ic_left.svg',
                            colorFilter: ColorFilter.mode(
                              isDarkMode
                                  ? AppThemeData.grey900Dark
                                  : AppThemeData.grey900,
                              BlendMode.srcIn,
                            ),
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 8),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                TextFieldWidget(
                                  isReadOnly: true,
                                  prefix: IconButton(
                                      onPressed: () {},
                                      icon: SvgPicture.asset(
                                        'assets/icons/ic_location.svg',
                                        colorFilter: ColorFilter.mode(
                                          AppThemeData.success300,
                                          BlendMode.srcIn,
                                        ),
                                      )),
                                  controller: controller.departureController,
                                  hintText: 'Pick Up Location'.tr,
                                ),
                                TextFieldWidget(
                                  isReadOnly: true,
                                  prefix: IconButton(
                                      onPressed: () {},
                                      icon: SvgPicture.asset(
                                        'assets/icons/ic_location.svg',
                                        colorFilter: ColorFilter.mode(
                                          AppThemeData.warning200,
                                          BlendMode.srcIn,
                                        ),
                                      )),
                                  controller: controller.destinationController,
                                  hintText: 'Where you want to go?'.tr,
                                ),
                                ReorderableListView(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: <Widget>[
                                    for (int index = 0;
                                        index <
                                            controller.multiStopListNew.length;
                                        index += 1)
                                      Container(
                                        key: ValueKey(
                                            controller.multiStopListNew[index]),
                                        child: Column(
                                          children: [
                                            Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: TextFieldWidget(
                                                      isReadOnly: true,
                                                      onTap: () async {},
                                                      prefix: IconButton(
                                                        onPressed: () {},
                                                        icon: Text(
                                                          String.fromCharCode(
                                                              index + 65),
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontFamily:
                                                                AppThemeData
                                                                    .regular,
                                                            color: isDarkMode
                                                                ? AppThemeData
                                                                    .grey500Dark
                                                                : AppThemeData
                                                                    .grey500,
                                                          ),
                                                        ),
                                                      ),
                                                      hintText:
                                                          "Where do you want to stop?"
                                                              .tr,
                                                      controller: controller
                                                          .multiStopListNew[
                                                              index]
                                                          .editingController,
                                                    ),
                                                  ),
                                                ]),
                                          ],
                                        ),
                                      ),
                                  ],
                                  onReorder: (int oldIndex, int newIndex) {
                                    if (oldIndex < newIndex) {
                                      newIndex -= 1;
                                    }
                                    final AddStopModelData item = controller
                                        .multiStopListNew
                                        .removeAt(oldIndex);
                                    controller.multiStopListNew
                                        .insert(newIndex, item);
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                "Trip Options".tr,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: AppThemeData.semiBold,
                                  color: isDarkMode
                                      ? AppThemeData.grey900Dark
                                      : AppThemeData.grey900,
                                ),
                              ),
                            ),
                            Column(children: [
                              TextFieldWidget(
                                prefix: IconButton(
                                    onPressed: () {},
                                    icon: SvgPicture.asset(
                                      'assets/icons/ic_parent.svg',
                                      colorFilter: ColorFilter.mode(
                                        isDarkMode
                                            ? AppThemeData.grey500Dark
                                            : AppThemeData.grey300Dark,
                                        BlendMode.srcIn,
                                      ),
                                    )),
                                controller: passengerController,
                                hintText: 'Enter passengers'.tr,
                              ),
                              ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: controller.addChildList.length,
                                  itemBuilder: (_, index) {
                                    return TextFieldWidget(
                                      prefix: IconButton(
                                          onPressed: () {},
                                          icon: SvgPicture.asset(
                                            'assets/icons/ic_child.svg',
                                            colorFilter: ColorFilter.mode(
                                              isDarkMode
                                                  ? AppThemeData.grey500Dark
                                                  : AppThemeData.grey300Dark,
                                              BlendMode.srcIn,
                                            ),
                                          )),
                                      controller: controller.addChildList[index]
                                          .editingController,
                                      hintText:
                                          'Any children ? Age of child'.tr,
                                    );
                                  }),
                              Visibility(
                                visible: controller.addChildList.length < 3,
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                    color: isDarkMode
                                        ? AppThemeData.grey300Dark
                                        : AppThemeData.grey300,
                                    width: 0.5,
                                  )),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16, horizontal: 16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            if (controller.addChildList.length <
                                                3) {
                                              controller.addChildList.add(
                                                  AddChildModelData(
                                                      editingController:
                                                          TextEditingController()));
                                            }
                                          },
                                          child: SizedBox(
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.add,
                                                  color:
                                                      AppThemeData.warning200,
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 10),
                                                Text(
                                                  "Add Children's".tr,
                                                  style: TextStyle(
                                                    color:
                                                        AppThemeData.warning200,
                                                    fontFamily:
                                                        AppThemeData.regular,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                            const SizedBox(height: 30),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: ButtonThem.buildButton(context,
                                  title: "Select Vehicle".tr,
                                  btnColor: AppThemeData.primary200,
                                  onPress: () async {
                                if (passengerController.text.isEmpty) {
                                  ShowToastDialog.showToast(
                                      "Please Enter Passenger".tr);
                                } else {
                                  await controller
                                      .getVehicleCategory()
                                      .then((value) {
                                    controller.update();
                                    if (value != null) {
                                      if (value.success == "Success") {
                                        Get.back();
                                        // List tripPrice = [];
                                        // for (int i = 0;
                                        //     i < value.vehicleData?.length;
                                        //     i++) {
                                        //   tripPrice.add(0.0);
                                        // }
                                        // if (value.vehicleData?.isNotEmpty) {
                                        //   for (int i = 0;
                                        //       i < value.vehicleData?.length;
                                        //       i++) {
                                        //     if (controller.distance.value >
                                        //         value.vehicleData![i]
                                        //             .minimumDeliveryChargesWithin!
                                        //             .toDouble()) {
                                        //       tripPrice.add((controller
                                        //                   .distance.value *
                                        //               value.vehicleData![i]
                                        //                   .deliveryCharges!)
                                        //           .toDouble()
                                        //           .toStringAsFixed(
                                        //               int.parse(Constant.decimal ?? "2")));
                                        //     } else {
                                        //       tripPrice.add(value
                                        //           .vehicleData![i]
                                        //           .minimumDeliveryCharges!
                                        //           .toDouble()
                                        //           .toStringAsFixed(
                                        //               int.parse(Constant.decimal ?? "2")));
                                        //     }
                                        //   }
                                        // }
                                        chooseVehicleBottomSheet(context, value,
                                            isDarkMode, controller);
                                      }
                                    }
                                  });
                                }
                              }),
                            )
                          ]),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          });
        });
  }

  chooseVehicleBottomSheet(
      BuildContext context,
      VehicleCategoryModel vehicleCategoryModel,
      bool isDarkMode,
      HomeOsmController controller) {
    return showModalBottomSheet(
        barrierColor:
            isDarkMode ? AppThemeData.grey800.withAlpha(200) : Colors.black26,
        isDismissible: true,
        isScrollControlled: true,
        context: context,
        backgroundColor:
            isDarkMode ? AppThemeData.surface50Dark : AppThemeData.surface50,
        builder: (context) {
          final themeChange = Provider.of<DarkThemeProvider>(context);
          return StatefulBuilder(builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      height: 8,
                      width: 75,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: isDarkMode
                            ? AppThemeData.grey300Dark
                            : AppThemeData.grey300,
                      )),
                ),
                IconButton(
                    onPressed: () {
                      Get.back();
                      tripOptionBottomSheet(
                          context, themeChange.getThem(), controller);
                    },
                    icon: Transform(
                      alignment: Alignment.center,
                      transform: Directionality.of(context) == TextDirection.rtl
                          ? Matrix4.rotationY(3.14159)
                          : Matrix4.identity(),
                      child: SvgPicture.asset(
                        'assets/icons/ic_left.svg',
                        colorFilter: ColorFilter.mode(
                          themeChange.getThem()
                              ? AppThemeData.grey900Dark
                              : AppThemeData.grey900,
                          BlendMode.srcIn,
                        ),
                      ),
                    )),
                const SizedBox(height: 10),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
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
                                    horizontal: 16, vertical: 14),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/ic_map.svg',
                                          colorFilter: ColorFilter.mode(
                                            AppThemeData.success300,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          'Total Distances'.tr,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: AppThemeData.regular,
                                            color: themeChange.getThem()
                                                ? AppThemeData.grey900Dark
                                                : AppThemeData.grey900,
                                          ),
                                        )
                                      ],
                                    ),
                                    Text(
                                      '${controller.distance.value.toStringAsFixed(2)} ${Constant.distanceUnit}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: AppThemeData.medium,
                                        color: themeChange.getThem()
                                            ? AppThemeData.grey900Dark
                                            : AppThemeData.grey900,
                                      ),
                                    )
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
                                    horizontal: 16, vertical: 14),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/ic_group.svg',
                                          colorFilter: ColorFilter.mode(
                                            AppThemeData.warning200,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          'About Passengers'.tr,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: AppThemeData.regular,
                                            color: themeChange.getThem()
                                                ? AppThemeData.grey900Dark
                                                : AppThemeData.grey900,
                                          ),
                                        )
                                      ],
                                    ),
                                    Text(
                                      '${passengerController.text} ${'Persons'.tr}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: AppThemeData.medium,
                                        color: themeChange.getThem()
                                            ? AppThemeData.grey900Dark
                                            : AppThemeData.grey900,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            "Recommended for you".tr,
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: AppThemeData.semiBold,
                              color: themeChange.getThem()
                                  ? AppThemeData.grey900Dark
                                  : AppThemeData.grey900,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 200,
                          child: ListView.separated(
                              separatorBuilder: (context, index) {
                                return Container(
                                  color: themeChange.getThem()
                                      ? AppThemeData.grey300Dark
                                      : AppThemeData.grey300,
                                  height: 1,
                                );
                              },
                              itemCount: vehicleCategoryModel.data?.length ?? 0,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              primary: true,
                              itemBuilder: (context, index) {
                                return Obx(
                                  () => InkWell(
                                    onTap: () {
                                      controller.vehicleData.value =
                                          vehicleCategoryModel.data![index];
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color:
                                            controller.vehicleData.value.id ==
                                                    vehicleCategoryModel
                                                        .data![index].id
                                                        .toString()
                                                ? AppThemeData.secondary50
                                                : themeChange.getThem()
                                                    ? AppThemeData.surface50Dark
                                                    : AppThemeData.surface50,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 12),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  CachedNetworkImage(
                                                    imageUrl:
                                                        vehicleCategoryModel
                                                            .data![index].image
                                                            .toString(),
                                                    fit: BoxFit.cover,
                                                    width: 40,
                                                    height: 40,
                                                    placeholder:
                                                        (context, url) =>
                                                            Constant.loader(
                                                                context),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Image.asset(
                                                      "assets/images/appIcon.png",
                                                    ),
                                                  ),
                                                  const SizedBox(width: 16),
                                                  Column(
                                                    children: [
                                                      Text(
                                                        vehicleCategoryModel
                                                            .data![index]
                                                            .libelle
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: controller
                                                                      .vehicleData
                                                                      .value
                                                                      .id ==
                                                                  vehicleCategoryModel
                                                                      .data![
                                                                          index]
                                                                      .id
                                                                      .toString()
                                                              ? AppThemeData
                                                                  .grey900
                                                              : themeChange
                                                                      .getThem()
                                                                  ? AppThemeData
                                                                      .grey900Dark
                                                                  : AppThemeData
                                                                      .grey900,
                                                          fontFamily:
                                                              AppThemeData
                                                                  .semiBold,
                                                        ),
                                                      ),
                                                      Text(
                                                        vehicleCategoryModel
                                                            .data![index].prix
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: controller
                                                                      .vehicleData
                                                                      .value
                                                                      .id ==
                                                                  vehicleCategoryModel
                                                                      .data![
                                                                          index]
                                                                      .id
                                                                      .toString()
                                                              ? AppThemeData
                                                                  .grey900
                                                              : themeChange
                                                                      .getThem()
                                                                  ? AppThemeData
                                                                      .grey900Dark
                                                                  : AppThemeData
                                                                      .grey900,
                                                          fontFamily:
                                                              AppThemeData
                                                                  .regular,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        Constant().amountShow(
                                                            amount:
                                                                "${controller.calculateTripPrice(
                                                          distance: controller
                                                              .distance.value,
                                                          deliveryCharges: double.parse(
                                                              vehicleCategoryModel
                                                                  .data![index]
                                                                  .deliveryCharges!),
                                                          minimumDeliveryCharges:
                                                              double.parse(
                                                                  vehicleCategoryModel
                                                                      .data![
                                                                          index]
                                                                      .minimumDeliveryCharges!),
                                                          minimumDeliveryChargesWithin:
                                                              double.parse(
                                                                  vehicleCategoryModel
                                                                      .data![
                                                                          index]
                                                                      .minimumDeliveryChargesWithin!),
                                                        )}"),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: controller
                                                                      .vehicleData
                                                                      .value
                                                                      .id ==
                                                                  vehicleCategoryModel
                                                                      .data![
                                                                          index]
                                                                      .id
                                                                      .toString()
                                                              ? AppThemeData
                                                                  .grey900
                                                              : themeChange
                                                                      .getThem()
                                                                  ? AppThemeData
                                                                      .grey900Dark
                                                                  : AppThemeData
                                                                      .grey900,
                                                          fontFamily:
                                                              AppThemeData
                                                                  .semiBold,
                                                        ),
                                                      ),
                                                      Text(
                                                        controller
                                                            .duration.value,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: controller
                                                                      .vehicleData
                                                                      .value
                                                                      .id ==
                                                                  vehicleCategoryModel
                                                                      .data![
                                                                          index]
                                                                      .id
                                                                      .toString()
                                                              ? AppThemeData
                                                                  .grey900
                                                              : themeChange
                                                                      .getThem()
                                                                  ? AppThemeData
                                                                      .grey900Dark
                                                                  : AppThemeData
                                                                      .grey900,
                                                          fontFamily:
                                                              AppThemeData
                                                                  .regular,
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
                                    ),
                                  ),
                                );
                              }),
                        ),
                        const SizedBox(height: 20),
                        ButtonThem.buildButton(context,
                            title: "Next".tr, btnColor: AppThemeData.primary200,
                            onPress: () async {
                          log("controller.vehicleData?.id :: ${controller.vehicleData.value.id}");
                          if (controller.vehicleData.value.id != null) {
                            double cout = 0.0;
                            if (controller.distance.value >
                                double.parse(controller.vehicleData.value
                                        .minimumDeliveryChargesWithin ??
                                    '0')) {
                              cout = (controller.distance.value *
                                      double.parse(controller.vehicleData.value
                                              .deliveryCharges ??
                                          '0'))
                                  .toDouble();
                            } else {
                              cout = double.parse(controller.vehicleData.value
                                      .minimumDeliveryCharges ??
                                  '0');
                            }

                            await controller
                                .getDriverDetails(
                                    controller.vehicleData.value.id ?? '',
                                    '${controller.departureLatLong.value.latitude}',
                                    '${controller.departureLatLong.value.longitude}')
                                .then((value) {
                              if (value != null) {
                                if (value.success == "Success") {
                                  if (value.data?.first.id?.isNotEmpty ==
                                      true) {
                                    Get.back();
                                    conformDataBottomSheet(
                                        context,
                                        vehicleCategoryModel,
                                        value.data!.first,
                                        cout,
                                        themeChange.getThem(),
                                        controller);
                                  } else {
                                    ShowToastDialog.showToast(
                                        "Driver not found in your area.".tr);
                                  }
                                } else {
                                  ShowToastDialog.showToast(
                                      "Driver not found in your area.".tr);
                                }
                              }
                            });
                          } else {
                            ShowToastDialog.showToast(
                                "Please select Vehicle Type".tr);
                          }
                        }),
                        const SizedBox(height: 20),
                      ]),
                ),
              ],
            );
          });
        });
  }

  conformDataBottomSheet(
      BuildContext context,
      VehicleCategoryModel vehicleCategoryModel,
      DriverData driverModel,
      double tripPrice,
      bool isDarkMode,
      HomeOsmController controller) {
    return showModalBottomSheet(
        barrierColor:
            isDarkMode ? AppThemeData.grey800.withAlpha(200) : Colors.black26,
        isDismissible: true,
        isScrollControlled: true,
        context: context,
        backgroundColor:
            isDarkMode ? AppThemeData.surface50Dark : AppThemeData.surface50,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Obx(
              () => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        height: 8,
                        width: 75,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: isDarkMode
                              ? AppThemeData.grey300Dark
                              : AppThemeData.grey300,
                        )),
                  ),
                  IconButton(
                      onPressed: () {
                        Get.back();
                        chooseVehicleBottomSheet(context, vehicleCategoryModel,
                            isDarkMode, controller);
                      },
                      icon: Transform(
                        alignment: Alignment.center,
                        transform:
                            Directionality.of(context) == TextDirection.rtl
                                ? Matrix4.rotationY(3.14159)
                                : Matrix4.identity(),
                        child: SvgPicture.asset(
                          'assets/icons/ic_left.svg',
                          colorFilter: ColorFilter.mode(
                            isDarkMode
                                ? AppThemeData.grey900Dark
                                : AppThemeData.grey900,
                            BlendMode.srcIn,
                          ),
                        ),
                      )),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CachedNetworkImage(
                            imageUrl: driverModel.photo.toString(),
                            fit: BoxFit.cover,
                            height: 110,
                            width: 110,
                            placeholder: (context, url) =>
                                Constant.loader(context),
                            errorWidget: (context, url, error) => Image.asset(
                              "assets/images/appIcon.png",
                              fit: BoxFit.cover,
                              height: 110,
                              width: 110,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${driverModel.prenom ?? ''} ${driverModel.nom ?? ''}',
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: AppThemeData.semiBold,
                                color: isDarkMode
                                    ? AppThemeData.grey900Dark
                                    : AppThemeData.grey900,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: StarRating(
                                size: 20,
                                rating: double.parse(
                                    driverModel.moyenne.toString()),
                                color: AppThemeData.warning200,
                              ),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.only(top: 3),
                            //   child: Text(
                            //     "${"Total trips".tr} ${driverModel.totalCompletedRide.toString()}",
                            //     style: TextStyle(
                            //       color: ConstantColors.subTitleTextColor,
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Row(
                            children: [
                              Expanded(
                                  child: buildDetails(
                                title:
                                    driverModel.totalCompletedRide.toString(),
                                value: 'Total Trips'.tr,
                                isDarkMode: isDarkMode,
                              )),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: buildDetails(
                                title: controller.duration.value,
                                value: 'Duration'.tr,
                                isDarkMode: isDarkMode,
                              )),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: buildDetails(
                                title: Constant()
                                    .amountShow(amount: tripPrice.toString()),
                                value: 'Trip Price'.tr,
                                isDarkMode: isDarkMode,
                              )),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: isDarkMode
                                  ? AppThemeData.grey300Dark
                                  : AppThemeData.grey300,
                            ),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Cab Details".tr,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: AppThemeData.regular,
                                        color: isDarkMode
                                            ? AppThemeData.grey900Dark
                                            : AppThemeData.grey900,
                                      ),
                                    ),
                                    Text(
                                      "${driverModel.numberplate}",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: AppThemeData.medium,
                                        color: isDarkMode
                                            ? AppThemeData.grey900Dark
                                            : AppThemeData.grey900,
                                      ),
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
                                    vertical: 14, horizontal: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Driver's Contact No.".tr,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: AppThemeData.regular,
                                        color: isDarkMode
                                            ? AppThemeData.grey900Dark
                                            : AppThemeData.grey900,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "${driverModel.phone}",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: AppThemeData.medium,
                                            color: isDarkMode
                                                ? AppThemeData.grey900Dark
                                                : AppThemeData.grey900,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          onTap: () {
                                            Constant.makePhoneCall(
                                                driverModel.phone.toString());
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
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          onTap: () {
                            favouriteNameTextController.text = '';

                            _favouriteNameDialog(context, controller);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/ic_star.svg',
                                  height: 24,
                                  width: 24,
                                  colorFilter: ColorFilter.mode(
                                    AppThemeData.secondary300,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  "Add Favourite Name".tr,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: AppThemeData.regular,
                                    color: AppThemeData.secondary300,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: ButtonThem.buildButton(context,
                                title: "Select Payment Method".tr,
                                onPress: () async {
                              var amount = await Constant().getAmount();
                              if (amount != null) {
                                controller.walletAmount.value = amount;
                              }
                              Get.back();
                              _paymentMethodDialog(
                                  context,
                                  vehicleCategoryModel,
                                  tripPrice,
                                  driverModel,
                                  isDarkMode,
                                  controller);
                            })),
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }

  final favouriteNameTextController = TextEditingController();

  _favouriteNameDialog(
      BuildContext context, HomeOsmController controller) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Enter Favourite Name".tr),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFieldThem.buildTextField(
                  title: 'Favourite name'.tr,
                  labelText: 'Favourite name'.tr,
                  controller: favouriteNameTextController,
                  textInputType: TextInputType.text,
                  contentPadding: EdgeInsets.zero,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      InkWell(
                          splashColor: Colors.transparent,
                          onTap: () {
                            Get.back();
                          },
                          child: Text("cancel".tr)),
                      InkWell(
                          splashColor: Colors.transparent,
                          onTap: () {
                            Map<String, String> bodyParams = {
                              'id_user_app':
                                  Preferences.getInt(Preferences.userId)
                                      .toString(),
                              'lat1':
                                  '${controller.departureLatLong.value.latitude}',
                              'lng1':
                                  '${controller.departureLatLong.value.longitude}',
                              'lat2':
                                  '${controller.destinationLatLong.value.latitude}',
                              'lng2':
                                  '${controller.destinationLatLong.value.longitude}',
                              'distance': controller.distance.value.toString(),
                              'distance_unit': Constant.distanceUnit.toString(),
                              'depart_name':
                                  controller.departureController.text,
                              'destination_name':
                                  controller.destinationController.text,
                              'fav_name': favouriteNameTextController.text,
                            };
                            controller
                                .setFavouriteRide(bodyParams)
                                .then((value) {
                              if (value['success'] == "Success") {
                                Get.back();
                              } else {
                                ShowToastDialog.showToast(value['error']);
                              }
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text("Ok".tr),
                          )),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  _pendingPaymentDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK".tr),
      onPressed: () {
        Get.back();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Cab me".tr),
      content: Text(
          "You have pending payments. Please complete payment before book new trip."
              .tr),
      actions: [
        okButton,
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

  _paymentMethodDialog(
      BuildContext context,
      VehicleCategoryModel vehicleCategoryModel,
      double tripPrice,
      DriverData driverData,
      bool isDarkMode,
      HomeOsmController controller) {
    return showModalBottomSheet(
        barrierColor:
            isDarkMode ? AppThemeData.grey800.withAlpha(200) : Colors.black26,
        isDismissible: true,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15), topLeft: Radius.circular(15))),
        context: context,
        backgroundColor:
            isDarkMode ? AppThemeData.surface50Dark : AppThemeData.surface50,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return SizedBox(
              height: Get.height * 0.9,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            height: 8,
                            width: 75,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: isDarkMode
                                  ? AppThemeData.grey300Dark
                                  : AppThemeData.grey300,
                            )),
                      ),
                      InkWell(
                        onTap: () {
                          Get.back();
                          conformDataBottomSheet(context, vehicleCategoryModel,
                              driverData, tripPrice, isDarkMode, controller);
                        },
                        child: Transform(
                          alignment: Alignment.center,
                          transform:
                              Directionality.of(context) == TextDirection.rtl
                                  ? Matrix4.rotationY(3.14159)
                                  : Matrix4.identity(),
                          child: SvgPicture.asset(
                            'assets/icons/ic_left.svg',
                            colorFilter: ColorFilter.mode(
                              isDarkMode
                                  ? AppThemeData.grey900Dark
                                  : AppThemeData.grey900,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                          color: isDarkMode
                              ? AppThemeData.grey300Dark
                              : AppThemeData.grey300,
                        )),
                        child: Column(
                          children: [
                            RadioButtonCustom(
                              image: "assets/icons/cash.png",
                              name: "Cash",
                              groupValue: controller.paymentMethodType.value,
                              isEnabled: controller.paymentSettingModel.value
                                          .cash?.isEnabled ==
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
                                controller.paymentMethodType.value = value!;
                                controller.paymentMethodId.value = controller
                                    .paymentSettingModel
                                    .value
                                    .cash!
                                    .idPaymentMethod
                                    .toString();
                                setState(() {});
                              },
                            ),
                            RadioButtonCustom(
                              subName: Constant().amountShow(
                                  amount: controller.walletAmount.value),
                              image: "assets/icons/walltet_icons.png",
                              name: "Wallet",
                              groupValue: controller.paymentMethodType.value,
                              isEnabled: controller.paymentSettingModel.value
                                          .myWallet?.isEnabled ==
                                      "true"
                                  ? true
                                  : false,
                              isSelected: controller.wallet.value,
                              onClick: (String? value) {
                                controller.stripe = false.obs;
                                controller.wallet = true.obs;
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
                                controller.paymentMethodId.value = controller
                                    .paymentSettingModel
                                    .value
                                    .myWallet!
                                    .idPaymentMethod
                                    .toString();
                                setState(() {});
                              },
                            ),
                            RadioButtonCustom(
                              image: "assets/icons/stripe.png",
                              name: 'Stripe',
                              groupValue: controller.paymentMethodType.value,
                              isEnabled: controller.paymentSettingModel.value
                                          .strip?.isEnabled ==
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
                                controller.paymentMethodType.value = value!;
                                controller.paymentMethodId.value = controller
                                    .paymentSettingModel
                                    .value
                                    .strip!
                                    .idPaymentMethod
                                    .toString();
                                setState(() {});
                              },
                            ),
                            RadioButtonCustom(
                              isEnabled: controller.paymentSettingModel.value
                                          .payStack?.isEnabled ==
                                      "true"
                                  ? true
                                  : false,
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
                                controller.paymentMethodId.value = controller
                                    .paymentSettingModel
                                    .value
                                    .payStack!
                                    .idPaymentMethod
                                    .toString();
                                setState(() {});
                              },
                            ),
                            RadioButtonCustom(
                              isEnabled: controller.paymentSettingModel.value
                                          .flutterWave?.isEnabled ==
                                      "true"
                                  ? true
                                  : false,
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
                                controller.paymentMethodId.value = controller
                                    .paymentSettingModel
                                    .value
                                    .flutterWave!
                                    .idPaymentMethod
                                    .toString();
                                setState(() {});
                              },
                            ),
                            RadioButtonCustom(
                              isEnabled: controller.paymentSettingModel.value
                                          .razorpay?.isEnabled ==
                                      "true"
                                  ? true
                                  : false,
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
                                controller.paymentMethodId.value = controller
                                    .paymentSettingModel
                                    .value
                                    .razorpay!
                                    .idPaymentMethod
                                    .toString();
                                setState(() {});
                              },
                            ),
                            RadioButtonCustom(
                              isEnabled: controller.paymentSettingModel.value
                                          .payFast?.isEnabled ==
                                      "true"
                                  ? true
                                  : false,
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
                                controller.paymentMethodId.value = controller
                                    .paymentSettingModel
                                    .value
                                    .payFast!
                                    .idPaymentMethod
                                    .toString();
                                setState(() {});
                              },
                            ),
                            RadioButtonCustom(
                              isEnabled: controller.paymentSettingModel.value
                                          .mercadopago?.isEnabled ==
                                      "true"
                                  ? true
                                  : false,
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
                                controller.paymentMethodId.value = controller
                                    .paymentSettingModel
                                    .value
                                    .mercadopago!
                                    .idPaymentMethod
                                    .toString();
                                setState(() {});
                              },
                            ),
                            RadioButtonCustom(
                              isEnabled: controller.paymentSettingModel.value
                                          .payPal?.isEnabled ==
                                      "true"
                                  ? true
                                  : false,
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
                                controller.paymentMethodId.value = controller
                                    .paymentSettingModel
                                    .value
                                    .payPal!
                                    .idPaymentMethod
                                    .toString();
                                setState(() {});
                              },
                            ),
                            RadioButtonCustom(
                              isEnabled: controller.paymentSettingModel.value
                                          .xendit?.isEnabled ==
                                      "true"
                                  ? true
                                  : false,
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
                                controller.paymentMethodId.value = controller
                                    .paymentSettingModel
                                    .value
                                    .xendit!
                                    .idPaymentMethod
                                    .toString();
                                setState(() {});
                              },
                            ),
                            RadioButtonCustom(
                              isEnabled: controller.paymentSettingModel.value
                                          .orangePay?.isEnabled ==
                                      "true"
                                  ? true
                                  : false,
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
                                controller.paymentMethodId.value = controller
                                    .paymentSettingModel
                                    .value
                                    .orangePay!
                                    .idPaymentMethod
                                    .toString();
                                setState(() {});
                              },
                            ),
                            RadioButtonCustom(
                              isEnabled: controller.paymentSettingModel.value
                                          .midtrans?.isEnabled ==
                                      "true"
                                  ? true
                                  : false,
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
                                controller.paymentMethodId.value = controller
                                    .paymentSettingModel
                                    .value
                                    .midtrans!
                                    .idPaymentMethod
                                    .toString();
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      ),
                      ButtonThem.buildButton(context,
                          btnHeight: 54,
                          title:
                              "${"Book".tr} ${Constant().amountShow(amount: tripPrice.toString())}",
                          btnColor: AppThemeData.primary200,
                          txtColor: Colors.white, onPress: () {
                        if (controller.paymentMethodType.value ==
                            "Select Method".tr) {
                          ShowToastDialog.showToast(
                              "Please select payment method".tr);
                        } else {
                          List stopsList = [];
                          for (var i = 0;
                              i < controller.multiStopListNew.length;
                              i++) {
                            stopsList.add({
                              "latitude": controller
                                  .multiStopListNew[i].latitude
                                  .toString(),
                              "longitude": controller
                                  .multiStopListNew[i].longitude
                                  .toString(),
                              "location": controller
                                  .multiStopListNew[i].editingController.text
                                  .toString()
                            });
                          }

                          Map<String, dynamic> bodyParams = {
                            'user_id': Preferences.getInt(Preferences.userId)
                                .toString(),
                            'lat1': controller.departureLatLong.value.latitude
                                .toString(),
                            'lng1': controller.departureLatLong.value.longitude
                                .toString(),
                            'lat2': controller.destinationLatLong.value.latitude
                                .toString(),
                            'lng2': controller
                                .destinationLatLong.value.longitude
                                .toString(),
                            'cout': tripPrice.toString(),
                            'distance': controller.distance.toString(),
                            'distance_unit': Constant.distanceUnit.toString(),
                            'duree': controller.duration.toString(),
                            'id_conducteur': driverData.id.toString(),
                            'id_payment': controller.paymentMethodId.value,
                            'depart_name': controller.departureController.text,
                            'destination_name':
                                controller.destinationController.text,
                            'stops': stopsList,
                            'place': '',
                            'number_poeple': passengerController.text,
                            'image': '',
                            'image_name': "",
                            'statut_round': 'no',
                            'trip_objective':
                                controller.tripOptionCategory.value,
                            'age_children1': controller
                                .addChildList[0].editingController.text,
                            'age_children2': controller.addChildList.length == 2
                                ? controller
                                    .addChildList[1].editingController.text
                                : "",
                            'age_children3': controller.addChildList.length == 3
                                ? controller
                                    .addChildList[2].editingController.text
                                : "",
                          };

                          controller.bookRide(bodyParams).then((value) async {
                            if (value != null) {
                              if (value['success'] == "success") {
                                Get.back();
                                controller.departureController.clear();
                                controller.destinationController.clear();
                                controller.departureLatLong.value =
                                    GeoPoint(latitude: 0, longitude: 0);
                                controller.destinationLatLong.value =
                                    GeoPoint(latitude: 0, longitude: 0);
                                passengerController.clear();
                                tripPrice = 0.0;
                                if (Constant.homeScreenType == 'UberHome') {
                                  controller.mapController.removeLastRoad();
                                  List<GeoPoint> allGeoPoints =
                                      controller.markers.values.toList();
                                  controller.mapController
                                      .removeMarkers(allGeoPoints);
                                  controller.getDirections();
                                } else {
                                  controller.clearData();
                                }
                                Get.to(const RideBookingSuccessScreen());
                              }
                            }
                          });
                        }
                      }),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  buildDetails({title, value, required bool isDarkMode}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          maxLines: 1,
          style: TextStyle(
            fontSize: 22,
            fontFamily: AppThemeData.semiBold,
            color: AppThemeData.secondary200,
          ),
        ),
        Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontFamily: AppThemeData.regular,
            color: isDarkMode ? AppThemeData.grey900Dark : AppThemeData.grey900,
          ),
        ),
      ],
    );
  }
}
