import 'dart:developer';
import 'dart:io';
import 'package:cabme/constant/constant.dart';
import 'package:cabme/constant/show_toast_dialog.dart';
import 'package:cabme/controller/parcel_service_controller.dart';
import 'package:cabme/page/parcel_service_screen/parcel_cart_screen.dart';
import 'package:cabme/page/parcel_service_screen/place_picker_osm.dart';
import 'package:cabme/themes/appbar_cust.dart';
import 'package:cabme/themes/button_them.dart';
import 'package:cabme/themes/constant_colors.dart';
import 'package:cabme/themes/text_field_them.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cabme/themes/responsive.dart';
import 'package:cabme/utils/dark_theme_provider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart';

class BookParcelScreen extends StatelessWidget {
  const BookParcelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    bool isDarkMode = themeChange.getThem();

    return GetX<ParcelServiceController>(
        init: ParcelServiceController(),
        builder: (controller) {
          return Scaffold(
            appBar: CustomAppbar(
              title:
                  "${"Send".tr} ${controller.selectedParcelCategory.value.title}",
              bgColor: AppThemeData.primary200,
            ),
            resizeToAvoidBottomInset: true,
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
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: isDarkMode
                                      ? AppThemeData.surface50Dark
                                      : AppThemeData.surface50,
                                  border: Border.all(
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey300Dark
                                        : AppThemeData.grey300,
                                    width: 0.8,
                                  )),
                              child: Column(
                                children: [
                                  SvgPicture.asset(
                                      'assets/icons/ic_upload_doc.svg'),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    "Upload Parcel Image".tr,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: AppThemeData.semiBold,
                                      color: isDarkMode
                                          ? AppThemeData.grey900Dark
                                          : AppThemeData.grey900,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    "Take a clear picture of your parcel or choose an image from your gallery to ensure smooth delivery."
                                        .tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: AppThemeData.regular,
                                      color: isDarkMode
                                          ? AppThemeData.grey500Dark
                                          : AppThemeData.grey500,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    "Max. 5MB, Accepted: JPG, PNG".tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: AppThemeData.regular,
                                      color: isDarkMode
                                          ? AppThemeData.grey500Dark
                                          : AppThemeData.grey500,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  ButtonThem.buildButton(
                                    txtSize: 14,
                                    btnWidthRatio: 0.4,
                                    context,
                                    title: 'Click to Upload'.tr,
                                    btnColor: themeChange.getThem()
                                        ? AppThemeData.primary300Dark
                                        : AppThemeData.primary300,
                                    onPress: () async {
                                      controller.onCameraClick(context);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Visibility(
                          visible: controller.parcelImages.isNotEmpty,
                          child: SizedBox(
                            height: 100,
                            width: Responsive.width(100, context),
                            child: ListView.builder(
                              itemCount: controller.parcelImages.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 16),
                                  child: Container(
                                    width: 100,
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: FileImage(File(controller
                                            .parcelImages[index].path)),
                                      ),
                                    ),
                                    child: InkWell(
                                        onTap: () {
                                          controller.parcelImages
                                              .removeAt(index);
                                        },
                                        child: const Icon(
                                          Icons.remove_circle,
                                          size: 30,
                                        )),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Sender Informations".tr,
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: AppThemeData.semiBold,
                            color: isDarkMode
                                ? AppThemeData.grey900Dark
                                : AppThemeData.grey900,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Column(
                          children: [
                            InkWell(
                              splashColor: Colors.transparent,
                              onTap: () async {
                                if (Constant.selectedMapType == 'osm') {
                                  Get.to(() => const LocationPicker())
                                      ?.then((value) {
                                    if (value != null) {
                                      controller.senderAddress.value =
                                          value['address'];
                                      controller.senderLocation =
                                          LatLng(value['lat'], value['lng']);
                                      controller.senderAddressCity.value =
                                          value['city']!;
                                      log("Sender Addres :: ${controller.senderAddressCity.value.toString()}");
                                      log("Reciver Addres :: ${controller.senderAddressCity.value.toString()}");
                                    }
                                  });
                                } else {
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //       builder: (context) => PlacePicker(
                                  //         apiKey: Constant.kGoogleApiKey!,
                                  //         onPlacePicked: (result) async {
                                  //           controller.senderAddress.value = result.formattedAddress!;
                                  //           // controller.sAddressController.text =
                                  //           //     result.formattedAddress!;
                                  //           controller.senderLocation =
                                  //               LatLng(double.parse(result.geometry!.location.lat.toString()), double.parse(result.geometry!.location.lng.toString()));

                                  //           await Constant()
                                  //               .getAddressFromLatLong(Position.fromMap({
                                  //             'latitude': double.parse(result.geometry!.location.lat.toString()),
                                  //             'longitude': double.parse(result.geometry!.location.lng.toString()),
                                  //             'timestamp': 0
                                  //           }))
                                  //               .then((value) {
                                  //             controller.senderAddressCity.value = value.toString().split(",").last.trim();
                                  //           });
                                  //           Get.back();
                                  //         },
                                  //         initialPosition: const LatLng(-33.8567844, 151.213108),
                                  //         useCurrentLocation: true,
                                  //         selectInitialPosition: true,
                                  //         usePinPointingSearch: true,
                                  //         usePlaceDetailSearch: true,
                                  //         zoomGesturesEnabled: true,
                                  //         zoomControlsEnabled: true,
                                  //         initialMapType: MapType.terrain,
                                  //         resizeToAvoidBottomInset: false, // only works in page mode, less flickery, remove if wrong offsets
                                  //       ),
                                  //     ));
                                  String apiKey = Constant.kGoogleApiKey!;
                                  Prediction? p = await PlacesAutocomplete.show(
                                    context: context,
                                    apiKey: apiKey,
                                    mode: Mode
                                        .overlay, // Options: fullscreen or overlay
                                    language: "en",
                                    components: [
                                      Component(Component.country, "us")
                                    ], // Restrict search to a specific country if needed
                                  );

                                  if (p != null) {
                                    final places =
                                        GoogleMapsPlaces(apiKey: apiKey);
                                    final detail = await places
                                        .getDetailsByPlaceId(p.placeId!);

                                    final location =
                                        detail.result.geometry!.location;

                                    controller.senderAddress.value =
                                        detail.result.formattedAddress!;
                                    controller.senderLocation =
                                        LatLng(location.lat, location.lng);

                                    await Constant()
                                        .getAddressFromLatLong(
                                            Position.fromMap({
                                      'latitude': location.lat,
                                      'longitude': location.lng,
                                      'timestamp': 0,
                                    }))
                                        .then((value) {
                                      controller.senderAddressCity.value = value
                                          .toString()
                                          .split(",")
                                          .last
                                          .trim();
                                    });

                                    Get.back();
                                  }
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: isDarkMode
                                        ? AppThemeData.surface50Dark
                                        : AppThemeData.surface50,
                                    border: Border.all(
                                      color: themeChange.getThem()
                                          ? AppThemeData.grey300Dark
                                          : AppThemeData.grey300,
                                      width: 0.8,
                                    )),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 18),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/ic_location.svg',
                                        colorFilter: ColorFilter.mode(
                                          themeChange.getThem()
                                              ? AppThemeData.grey500Dark
                                              : AppThemeData.grey300Dark,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                            controller.senderAddress.toString(),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: themeChange.getThem()
                                                  ? AppThemeData.grey900Dark
                                                  : AppThemeData.grey900,
                                              fontFamily: AppThemeData.regular,
                                            )),
                                      ),
                                      const SizedBox(width: 5),
                                      Text('Change'.tr,
                                          style: TextStyle(
                                            decorationColor: themeChange
                                                    .getThem()
                                                ? AppThemeData.primary300Dark
                                                : AppThemeData.primary300,
                                            decoration:
                                                TextDecoration.underline,
                                            fontSize: 14,
                                            color: themeChange.getThem()
                                                ? AppThemeData.primary300Dark
                                                : AppThemeData.primary300,
                                            fontFamily: AppThemeData.regular,
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            TextFieldWidget(
                              prefix: IconButton(
                                  onPressed: () {},
                                  icon: SvgPicture.asset(
                                    'assets/icons/ic_user.svg',
                                    colorFilter: ColorFilter.mode(
                                      themeChange.getThem()
                                          ? AppThemeData.grey500Dark
                                          : AppThemeData.grey300Dark,
                                      BlendMode.srcIn,
                                    ),
                                  )),
                              controller: controller.sNameController,
                              hintText: 'Name'.tr,
                            ),
                            MobileTextFieldWidget(
                              onChanged: (number) {
                                controller.sPhoneController.value.text =
                                    number.completeNumber;
                              },
                              hintText: 'Mobile number'.tr,
                              controller: controller.sPhoneController.value,
                            ),
                            SizedBox(
                              height: 53,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFieldWidget(
                                      onTap: () {
                                        controller.selectDate(
                                          context,
                                        );
                                      },
                                      isReadOnly: true,
                                      suffix: IconButton(
                                          onPressed: () {
                                            controller.selectDate(
                                              context,
                                            );
                                          },
                                          icon: SvgPicture.asset(
                                            'assets/icons/ic_date.svg',
                                            colorFilter: ColorFilter.mode(
                                              themeChange.getThem()
                                                  ? AppThemeData.grey500Dark
                                                  : AppThemeData.grey300Dark,
                                              BlendMode.srcIn,
                                            ),
                                          )),
                                      controller: TextEditingController(
                                          text: controller.senderDate.value),
                                      hintText: 'Date'.tr,
                                    ),
                                  ),
                                  Expanded(
                                    child: TextFieldWidget(
                                      onTap: () {
                                        controller.selectTime(
                                          context,
                                        );
                                      },
                                      isReadOnly: true,
                                      suffix: IconButton(
                                          onPressed: () {
                                            controller.selectTime(
                                              context,
                                            );
                                          },
                                          icon: SvgPicture.asset(
                                            'assets/icons/ic_time.svg',
                                            colorFilter: ColorFilter.mode(
                                              themeChange.getThem()
                                                  ? AppThemeData.grey500Dark
                                                  : AppThemeData.grey300Dark,
                                              BlendMode.srcIn,
                                            ),
                                          )),
                                      controller: TextEditingController(
                                          text: controller.senderTime.value),
                                      hintText: 'Time'.tr,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 53,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFieldWidget(
                                      textInputType: TextInputType.number,
                                      controller:
                                          controller.parcelWeightController,
                                      hintText: 'Enter kg'.tr,
                                      suffix: IconButton(
                                          onPressed: () {},
                                          icon: Text(
                                            'kg'.tr,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: AppThemeData.semiBold,
                                              color: isDarkMode
                                                  ? AppThemeData.grey500Dark
                                                  : AppThemeData.grey300Dark,
                                            ),
                                          )),
                                    ),
                                  ),
                                  Expanded(
                                    child: TextFieldWidget(
                                      textInputType: TextInputType.number,
                                      suffix: IconButton(
                                          onPressed: () {},
                                          icon: Text(
                                            'cm'.tr,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: AppThemeData.semiBold,
                                              color: isDarkMode
                                                  ? AppThemeData.grey500Dark
                                                  : AppThemeData.grey300Dark,
                                            ),
                                          )),
                                      controller:
                                          controller.parcelDimentionController,
                                      hintText: 'Enter cm'.tr,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 70, // increase height to fit two-line hint
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      controller: controller.numberOfItemsController,
                                      maxLines: 1,
                                      decoration: InputDecoration(
                                        hintText: 'Number of Items'.tr,
                                        hintStyle: TextStyle(fontSize: 14),
                                        hintMaxLines: 2, // <-- allows hint text to wrap
                                        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                                        prefixIcon: Padding(
                                          padding: const EdgeInsets.only(left: 8.0, right: 4.0),
                                          child: Icon(
                                            Icons.inventory_outlined,
                                            size: 18,
                                            color: themeChange.getThem()
                                                ? AppThemeData.grey500Dark
                                                : AppThemeData.grey500,
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  //const SizedBox(width: 8),
                                  Expanded(
                                    child: TextField(
                                      keyboardType: TextInputType.text,
                                      controller: controller.customerDniController,
                                      maxLines: 1,
                                      decoration: InputDecoration(
                                        hintText: 'DNI (ID Number)'.tr,
                                        hintStyle: TextStyle(fontSize: 14),
                                        hintMaxLines: 2,
                                        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                                        prefixIcon: Padding(
                                          padding: const EdgeInsets.only(left: 8.0, right: 4.0),
                                          child: Icon(
                                            Icons.credit_card,
                                            size: 18,
                                            color: themeChange.getThem()
                                                ? AppThemeData.grey500Dark
                                                : AppThemeData.grey500,
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            TextFieldWidget(
                              prefix: IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.mode_edit_outline_outlined,
                                    size: 16,
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey500Dark
                                        : AppThemeData.grey500,
                                  )),
                              controller: controller.noteController,
                              hintText: 'Note'.tr,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Receiver's Information".tr,
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: AppThemeData.semiBold,
                            color: isDarkMode
                                ? AppThemeData.grey900Dark
                                : AppThemeData.grey900,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Column(
                          children: [
                            InkWell(
                              splashColor: Colors.transparent,
                              onTap: () async {
                                if (Constant.selectedMapType == 'osm') {
                                  Get.to(() => const LocationPicker())
                                      ?.then((value) {
                                    if (value != null) {
                                      log("value :: ${value.toString()}");
                                      controller.receiverAddress.value =
                                          value['address'];
                                      controller.receiverLocation =
                                          LatLng(value['lat'], value['lng']);
                                      controller.receiverAddressCity.value =
                                          value['city'];
                                    }
                                  });
                                } else {
                                  String apiKey = Constant.kGoogleApiKey!;

                                  Prediction? p = await PlacesAutocomplete.show(
                                    context: context,
                                    apiKey: apiKey,
                                    mode: Mode
                                        .overlay, // Use overlay mode (or Mode.fullscreen if needed)
                                    language: "en",
                                    components: [
                                      Component(Component.country, "us")
                                    ], // Restrict to specific country if necessary
                                  );

                                  if (p != null) {
                                    final places =
                                        GoogleMapsPlaces(apiKey: apiKey);
                                    final detail = await places
                                        .getDetailsByPlaceId(p.placeId!);
                                    final location =
                                        detail.result.geometry!.location;

                                    // Update receiver address and location
                                    controller.receiverAddress.value =
                                        detail.result.formattedAddress!;
                                    controller.receiverLocation =
                                        LatLng(location.lat, location.lng);

                                    // Get city name from coordinates
                                    await Constant()
                                        .getAddressFromLatLong(
                                            Position.fromMap({
                                      'latitude': location.lat,
                                      'longitude': location.lng,
                                      'timestamp': 0,
                                    }))
                                        .then((value) {
                                      controller.receiverAddressCity.value =
                                          value
                                              .toString()
                                              .split(",")
                                              .last
                                              .trim();
                                    });

                                    Get.back();
                                  }
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => PlacePicker(
                                  //       apiKey: Constant.kGoogleApiKey!,
                                  //       onPlacePicked: (result) async {
                                  //         controller.receiverAddress.value = result.formattedAddress!;
                                  //         controller.receiverLocation =
                                  //             LatLng(double.parse(result.geometry!.location.lat.toString()), double.parse(result.geometry!.location.lng.toString()));

                                  //         await Constant()
                                  //             .getAddressFromLatLong(Position.fromMap({
                                  //           'latitude': double.parse(result.geometry!.location.lat.toString()),
                                  //           'longitude': double.parse(result.geometry!.location.lng.toString()),
                                  //           'timestamp': 0
                                  //         }))
                                  //             .then((value) {
                                  //           controller.receiverAddressCity.value = value.toString().split(",").last.trim();
                                  //         });

                                  //         Get.back();
                                  //       },
                                  //       initialPosition: const LatLng(-33.8567844, 151.213108),
                                  //       useCurrentLocation: true,
                                  //       selectInitialPosition: true,
                                  //       usePinPointingSearch: true,
                                  //       usePlaceDetailSearch: true,
                                  //       zoomGesturesEnabled: true,
                                  //       zoomControlsEnabled: true,
                                  //       initialMapType: MapType.terrain,
                                  //       resizeToAvoidBottomInset: false, // only works in page mode, less flickery, remove if wrong offsets
                                  //     ),
                                  //   ),
                                  // );
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: isDarkMode
                                        ? AppThemeData.surface50Dark
                                        : AppThemeData.surface50,
                                    border: Border.all(
                                      color: themeChange.getThem()
                                          ? AppThemeData.grey300Dark
                                          : AppThemeData.grey300,
                                      width: 0.8,
                                    )),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 18),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/ic_location.svg',
                                        colorFilter: ColorFilter.mode(
                                          themeChange.getThem()
                                              ? AppThemeData.grey500Dark
                                              : AppThemeData.grey300Dark,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                            controller.receiverAddress
                                                .toString(),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: themeChange.getThem()
                                                  ? AppThemeData.grey900Dark
                                                  : AppThemeData.grey900,
                                              fontFamily: AppThemeData.regular,
                                            )),
                                      ),
                                      const SizedBox(width: 5),
                                      Text('Change'.tr,
                                          style: TextStyle(
                                            decorationColor: themeChange
                                                    .getThem()
                                                ? AppThemeData.primary300Dark
                                                : AppThemeData.primary300,
                                            decoration:
                                                TextDecoration.underline,
                                            fontSize: 14,
                                            color: themeChange.getThem()
                                                ? AppThemeData.primary300Dark
                                                : AppThemeData.primary300,
                                            fontFamily: AppThemeData.regular,
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            TextFieldWidget(
                              prefix: IconButton(
                                  onPressed: () {},
                                  icon: SvgPicture.asset(
                                    'assets/icons/ic_user.svg',
                                    colorFilter: ColorFilter.mode(
                                      themeChange.getThem()
                                          ? AppThemeData.grey500Dark
                                          : AppThemeData.grey300Dark,
                                      BlendMode.srcIn,
                                    ),
                                  )),
                              controller: controller.rNameController,
                              hintText: 'Name'.tr,
                            ),
                            MobileTextFieldWidget(
                              onChanged: (number) {
                                controller.rPhoneController.value.text =
                                    number.completeNumber;
                              },
                              hintText: 'Mobile number'.tr,
                              controller: controller.rPhoneController.value,
                            ),
                            SizedBox(
                              height: 53,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFieldWidget(
                                      onTap: () {
                                        controller.selectDate(context,
                                            isPickUp: false);
                                      },
                                      isReadOnly: true,
                                      suffix: IconButton(
                                          onPressed: () {
                                            controller.selectDate(context,
                                                isPickUp: false);
                                          },
                                          icon: SvgPicture.asset(
                                            'assets/icons/ic_date.svg',
                                            colorFilter: ColorFilter.mode(
                                              themeChange.getThem()
                                                  ? AppThemeData.grey500Dark
                                                  : AppThemeData.grey300Dark,
                                              BlendMode.srcIn,
                                            ),
                                          )),
                                      controller: TextEditingController(
                                          text: controller.receiverDate.value),
                                      hintText: 'Arrive Date'.tr,
                                    ),
                                  ),
                                  Expanded(
                                    child: TextFieldWidget(
                                      onTap: () {
                                        controller.selectTime(context,
                                            isPickUp: false);
                                      },
                                      isReadOnly: true,
                                      suffix: IconButton(
                                          onPressed: () {
                                            controller.selectTime(context,
                                                isPickUp: false);
                                          },
                                          icon: SvgPicture.asset(
                                            'assets/icons/ic_time.svg',
                                            colorFilter: ColorFilter.mode(
                                              themeChange.getThem()
                                                  ? AppThemeData.grey500Dark
                                                  : AppThemeData.grey300Dark,
                                              BlendMode.srcIn,
                                            ),
                                          )),
                                      controller: TextEditingController(
                                          text: controller.receiverTime.value),
                                      hintText: 'Arrive Time'.tr,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
                        ButtonThem.buildButton(
                          context,
                          title: 'Continue'.tr,
                          onPress: () async {
                            if (controller.sNameController.value.text.isEmpty) {
                              ShowToastDialog.showToast(
                                "Please Enter Sender Name.",
                              );
                            } else if (controller
                                .sPhoneController.value.text.isEmpty) {
                              ShowToastDialog.showToast(
                                "Please Enter Sender Phone number.",
                              );
                            } else if (controller.senderDate.isEmpty ||
                                controller.senderTime.isEmpty) {
                              ShowToastDialog.showToast(
                                "Select Sender date and time.",
                              );
                            } else if (controller
                                .parcelWeightController.value.text.isEmpty) {
                              ShowToastDialog.showToast(
                                "Please Enter Kg.",
                              );
                            } else if (controller
                                .parcelDimentionController.value.text.isEmpty) {
                              ShowToastDialog.showToast(
                                "Please Enter cm.",
                              );
                            } else if (controller
                                .numberOfItemsController.value.text.isEmpty) {
                              ShowToastDialog.showToast(
                                "Please Enter Number of Items.",
                              );
                            } else if (controller
                                .customerDniController.value.text.isEmpty) {
                              ShowToastDialog.showToast(
                                "Please Enter DNI (ID Number).",
                              );
                            } else if (controller
                                .rNameController.value.text.isEmpty) {
                              ShowToastDialog.showToast(
                                "Please Enter Receiver Name.",
                              );
                            } else if (controller
                                .rPhoneController.value.text.isEmpty) {
                              ShowToastDialog.showToast(
                                "Please Enter Receiver Phone number.",
                              );
                            } else if (controller.receiverDate.isEmpty ||
                                controller.receiverTime.isEmpty) {
                              ShowToastDialog.showToast(
                                  "Select receiver date and time.");
                            } else if (controller.parcelImages.isEmpty) {
                              ShowToastDialog.showToast("Select parcel image");
                            } else {
                              if (Constant.selectedMapType == 'google') {
                                controller.getDurationDistance(
                                    controller.senderLocation!,
                                    controller.receiverLocation!);
                              } else {
                                controller.getDurationOSMDistance(
                                    controller.senderLocation!,
                                    controller.receiverLocation!);
                              }
                              Get.to(() => const CartParcelScreen());
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
