import 'dart:io';
import 'dart:math';
import 'package:cabme/constant/constant.dart';
import 'package:cabme/constant/show_toast_dialog.dart';
import 'package:cabme/controller/dash_board_controller.dart';
import 'package:cabme/controller/parcel_details_controller.dart';
import 'package:cabme/model/driver_location_update.dart';
import 'package:cabme/model/parcel_model.dart';
import 'package:cabme/themes/button_them.dart';
import 'package:cabme/themes/constant_colors.dart';
import 'package:cabme/themes/custom_alert_dialog.dart';
import 'package:cabme/themes/custom_dialog_box.dart';
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
import 'package:share_plus/share_plus.dart';

class ParcelRouteOsmViewScreen extends StatefulWidget {
  const ParcelRouteOsmViewScreen({super.key});

  @override
  State<ParcelRouteOsmViewScreen> createState() => _ParcelRouteOsmViewScreenState();
}

class _ParcelRouteOsmViewScreenState extends State<ParcelRouteOsmViewScreen> {
  dynamic argumentData = Get.arguments;

  late MapController mapController;

  Map<String, GeoPoint> markers = <String, GeoPoint>{};

  Widget? departureIcon;
  Widget? destinationIcon;
  Widget? taxiIcon;
  Widget? stopIcon;

  GeoPoint? departureLatLong;
  GeoPoint? destinationLatLong;

  String? type;
  ParcelData? parcelData;
  String driverEstimateArrivalTime = '';

  RoadInfo roadInfo = RoadInfo();

  @override
  void initState() {
    if (argumentData != null) {
      type = argumentData['type'];
      parcelData = argumentData['data'];
    }
    ShowToastDialog.showLoader("Please wait");
    mapController = MapController(initPosition: GeoPoint(latitude: 48.8561, longitude: 2.2930));
    setIcons();
    super.initState();
  }

  final controllerRideDetails = Get.put(ParcelDetailsController());
  final controllerDashBoard = Get.put(DashBoardController());

  getArgumentData() {
    if (argumentData != null) {
      type = argumentData['type'];
      parcelData = argumentData['data'];

      departureLatLong = GeoPoint(latitude: double.parse(parcelData!.latSource.toString()), longitude: double.parse(parcelData!.lngSource.toString()));
      destinationLatLong = GeoPoint(latitude: double.parse(parcelData!.latDestination.toString()), longitude: double.parse(parcelData!.lngDestination.toString()));

      if (parcelData!.status == "onride" || parcelData!.status == 'confirmed') {
        Constant.driverLocationUpdateCollection.doc(parcelData!.idConducteur).snapshots().listen((event) async {
          DriverLocationUpdate driverLocationUpdate = DriverLocationUpdate.fromJson(event.data() as Map<String, dynamic>);

          // String url =
          //     'http://router.project-osrm.org/route/v1/driving/${parcelData!.latSource},${parcelData!.lngSource};${double.parse(driverLocationUpdate.driverLatitude.toString())},${double.parse(driverLocationUpdate.driverLongitude.toString())}';
          // http.Response response = await http.get(Uri.parse('$url?overview=false'));
          // var decodedResponse = jsonDecode(response.body);
          // int hours = decodedResponse['routes'].first['duration'] ~/ 3600;
          // int minutes = ((decodedResponse['routes'].first['duration'] % 3600) / 60).round();
          // driverEstimateArrivalTime = '$hours hours $minutes minutes';

          departureLatLong =
              GeoPoint(latitude: double.parse(driverLocationUpdate.driverLatitude.toString()), longitude: double.parse(driverLocationUpdate.driverLongitude.toString()));

          WidgetsBinding.instance.addPostFrameCallback((_) async {
            if (markers.containsKey(parcelData!.id.toString())) {
              await mapController.removeMarker(markers[parcelData!.id.toString()]!);
            }
            await mapController
                .addMarker(departureLatLong!,
                    markerIcon: MarkerIcon(iconWidget: taxiIcon),
                    angle: pi / 3,
                    iconAnchor: IconAnchor(
                      anchor: Anchor.top,
                    ))
                .then((v) {
              markers[parcelData!.id.toString()] = departureLatLong!;
            });

            getDirections(dLat: double.parse(driverLocationUpdate.driverLatitude.toString()), dLng: double.parse(driverLocationUpdate.driverLongitude.toString()));
          });
          mapController.moveTo(departureLatLong!, animate: true);
          setState(() {});
        });
      } else {
        getDirections(dLat: 0.0, dLng: 0.0);
      }
      updateCameraLocation(source: departureLatLong!, destination: destinationLatLong!, mapController: mapController);
    }
  }

  setIcons() async {
    departureIcon = Image.asset("assets/icons/pickup.png", width: 30, height: 30);

    destinationIcon = Image.asset("assets/icons/dropoff.png", width: 30, height: 30);

    taxiIcon = Image.asset("assets/icons/ic_taxi.png", width: 30, height: 30);

    stopIcon = Image.asset("assets/icons/location.png", width: 30, height: 30);
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          OSMFlutter(
              controller: mapController,
              osmOption: OSMOption(
                userTrackingOption: const UserTrackingOption(
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
                  roadBorderWidth: Platform.isIOS ? 15 : 10, // Set the road border width (outline)
                  roadBorderColor: Colors.black, // Border color
                  zoomInto: true,
                ),
              ),
              onMapIsReady: (active) async {
                if (active) {
                  getArgumentData();
                  ShowToastDialog.closeLoader();
                }
              }),
          Positioned(
              top: 10,
              left: 8,
              child: SafeArea(
                child: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.arrow_back_ios_outlined, color: Colors.black)),
              )),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (parcelData!.status.toString() != "new" || parcelData!.status.toString() != "canceled" && parcelData!.idConducteur.toString() != "null")
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 10,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: themeChange.getThem() ? AppThemeData.surface50Dark : AppThemeData.surface50,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
                      child: Column(
                        children: [
                          if (Constant.rideOtp.toString().toLowerCase() == 'yes'.toLowerCase() && parcelData!.status == 'confirmed' ? true : false)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Divider(
                                  color: themeChange.getThem() ? AppThemeData.grey200Dark : AppThemeData.grey200,
                                  thickness: 1,
                                ),
                                Text(
                                  '${'OTP : '.tr}${parcelData!.otp}',
                                  style: TextStyle(
                                    fontFamily: AppThemeData.regular,
                                    color: themeChange.getThem() ? AppThemeData.grey400 : AppThemeData.grey300Dark,
                                    fontSize: 14,
                                  ),
                                ),
                                Divider(
                                  color: themeChange.getThem() ? AppThemeData.grey200Dark : AppThemeData.grey200,
                                  thickness: 1,
                                ),
                              ],
                            ),
                          if (Constant.rideOtp.toString().toLowerCase() == 'yes'.toLowerCase() && parcelData!.status == 'confirmed' ? true : false)
                            Container(
                              height: 1,
                              color: themeChange.getThem() ? AppThemeData.grey200Dark : AppThemeData.grey200,
                            ),
                          if ((parcelData!.status.toString() != "new" || parcelData!.status.toString() != "canceled") && parcelData!.idConducteur.toString() != "null")
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(80),
                                  child: CachedNetworkImage(
                                    imageUrl: parcelData!.driverPhoto.toString(),
                                    height: 80,
                                    width: 80,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Constant.loader(context),
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
                                        Text("${parcelData!.driverName}",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontFamily: AppThemeData.semiBold,
                                              color: themeChange.getThem() ? AppThemeData.grey900Dark : AppThemeData.grey900,
                                              fontSize: 16,
                                              letterSpacing: 0.6,
                                            )),
                                        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                                          StarRating(
                                              size: 20,
                                              rating: parcelData!.moyenne != "null" ? double.parse(parcelData!.moyenne.toString()) : 0.0,
                                              color: AppThemeData.secondary200),
                                        ])
                                      ],
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        parcelData!.status != "completed"
                                            ? Padding(
                                                padding: const EdgeInsets.only(left: 10),
                                                child: InkWell(
                                                    onTap: () async {
                                                      ShowToastDialog.showLoader("Please wait".tr);
                                                      final Location currentLocation = Location();
                                                      LocationData location = await currentLocation.getLocation();

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
                                                        color: AppThemeData.secondary200,
                                                      ),
                                                      child: SvgPicture.asset(
                                                        'assets/icons/ic_share.svg',
                                                        height: 20,
                                                        width: 20,
                                                        colorFilter: ColorFilter.mode(
                                                          themeChange.getThem() ? AppThemeData.surface50Dark : AppThemeData.surface50,
                                                          BlendMode.srcIn,
                                                        ),
                                                      ),
                                                    )))
                                            : const Offstage(),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10),
                                          child: InkWell(
                                              onTap: () {
                                                Constant.makePhoneCall(parcelData!.driverPhone.toString());
                                              },
                                              child: Container(
                                                alignment: Alignment.center,
                                                height: 44,
                                                width: 44,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: AppThemeData.warning200,
                                                ),
                                                child: SvgPicture.asset(
                                                  'assets/icons/call_icon.svg',
                                                  height: 20,
                                                  width: 20,
                                                  colorFilter: ColorFilter.mode(
                                                    themeChange.getThem() ? AppThemeData.surface50Dark : AppThemeData.surface50,
                                                    BlendMode.srcIn,
                                                  ),
                                                ),
                                              )),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Text(parcelData!.parcelDate.toString(),
                                          style: TextStyle(
                                            color: themeChange.getThem() ? AppThemeData.grey900Dark : AppThemeData.grey900,
                                            fontFamily: AppThemeData.medium,
                                            fontSize: 16,
                                          )),
                                    ),
                                  ],
                                )
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Visibility(
                  visible: parcelData!.status == "rejected" || parcelData!.status == "canceled" || parcelData!.status == "onride" ? false : true,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10, left: 10),
                    child: ButtonThem.buildButton(
                      context,
                      btnColor: AppThemeData.error200,
                      title: 'Cancel Parcel'.tr,
                      btnWidthRatio: 0.9,
                      onPress: () async {
                        buildShowBottomSheet(context, themeChange.getThem());
                      },
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  final resonController = TextEditingController();

  buildShowBottomSheet(BuildContext context, bool isDarkMode) {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15))),
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        backgroundColor: isDarkMode ? AppThemeData.surface50Dark : AppThemeData.surface50,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
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
                          color: isDarkMode ? AppThemeData.grey900Dark : AppThemeData.grey900,
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
                          color: isDarkMode ? AppThemeData.grey400 : AppThemeData.grey300Dark,
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
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                                title: 'Submit'.tr,
                                btnWidthRatio: 0.8,
                                onPress: () async {
                                  if (resonController.text.isNotEmpty) {
                                    Get.back();
                                    showDialog(
                                      barrierColor: Colors.black26,
                                      context: context,
                                      builder: (context) {
                                        return CustomAlertDialog(
                                          title: "Do you want to cancel this booking?".tr,
                                          onPressNegative: () {
                                            Get.back();
                                          },
                                          onPressPositive: () {
                                            if (parcelData!.status.toString() == "new") {
                                              Map<String, String> bodyParams = {
                                                'parcel_id': parcelData!.id.toString(),
                                                'reason': resonController.text.toString(),
                                              };
                                              controllerRideDetails.rejectParcel(bodyParams).then((value) {
                                                Get.back();
                                                if (value != null) {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return CustomDialogBox(
                                                          title: "Cancel Successfully".tr,
                                                          descriptions: "Parcel Successfully cancel.".tr,
                                                          onPress: () {
                                                            Get.back();
                                                            controllerDashBoard.onSelectItem(6);
                                                          },
                                                          img: Image.asset('assets/images/green_checked.png'),
                                                        );
                                                      });
                                                }
                                              });
                                            } else {
                                              Map<String, String> bodyParams = {
                                                'id_parcel': parcelData!.id.toString(),
                                                'id_user': parcelData!.idConducteur.toString(),
                                                'name': "${parcelData!.senderName}",
                                                'from_id': Preferences.getInt(Preferences.userId).toString(),
                                                'user_cat': controllerRideDetails.userModel!.data!.userCat.toString(),
                                                'reason': resonController.text.toString(),
                                              };
                                              controllerRideDetails.canceledParcel(bodyParams).then((value) {
                                                Get.back();
                                                if (value != null) {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return CustomDialogBox(
                                                          title: "Cancel Successfully".tr,
                                                          descriptions: "Parcel Successfully cancel.".tr,
                                                          onPress: () {
                                                            Get.back();
                                                            Get.back();
                                                            Get.back();
                                                          },
                                                          img: Image.asset('assets/images/green_checked.png'),
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
                                    ShowToastDialog.showToast("Please enter a reason");
                                  }
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 5, left: 10),
                              child: ButtonThem.buildBorderButton(
                                context,
                                title: 'Close'.tr,
                                btnWidthRatio: 0.8,
                                btnColor: isDarkMode ? AppThemeData.surface50Dark : AppThemeData.surface50,
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

  drawRoad({required GeoPoint startPoint, required GeoPoint lastPoint}) async {
    await mapController.removeLastRoad();
    roadInfo = await mapController.drawRoad(
      startPoint,
      lastPoint,
      roadType: RoadType.car,
      roadOption: RoadOption(
        roadWidth: Platform.isIOS ? 50 : 10,
        roadColor: Colors.blue,
        roadBorderWidth: Platform.isIOS ? 15 : 10, // Set the road border width (outline)
        roadBorderColor: Colors.black, // Border color
        zoomInto: true,
      ),
    );
    int hours = (roadInfo.duration! ~/ 3600);
    int minutes = ((roadInfo.duration! % 3600) / 60).round();
    setState(() {
      driverEstimateArrivalTime = '$hours hours $minutes minutes';
    });
  }

  getDirections({required double dLat, required double dLng}) async {
    if (markers.containsKey('Departure')) {
      await mapController.removeMarker(markers['Departure']!);
    }
    await mapController
        .addMarker(
            GeoPoint(
              latitude: double.parse(parcelData!.latSource.toString()),
              longitude: double.parse(parcelData!.lngSource.toString()),
            ),
            markerIcon: MarkerIcon(iconWidget: departureIcon),
            angle: pi / 3,
            iconAnchor: IconAnchor(
              anchor: Anchor.top,
            ))
        .then((v) {
      markers['Departure'] = GeoPoint(
        latitude: double.parse(parcelData!.latSource.toString()),
        longitude: double.parse(parcelData!.lngSource.toString()),
      );
    });

    if (markers.containsKey('Destination')) {
      await mapController.removeMarker(markers['Destination']!);
    }
    await mapController
        .addMarker(destinationLatLong!,
            markerIcon: MarkerIcon(iconWidget: destinationIcon),
            angle: pi / 3,
            iconAnchor: IconAnchor(
              anchor: Anchor.top,
            ))
        .then((v) {
      markers['Destination'] = destinationLatLong!;
    });

    if (parcelData!.status == "confirmed") {
      drawRoad(
          startPoint: GeoPoint(
            latitude: double.parse(parcelData!.latSource.toString()),
            longitude: double.parse(parcelData!.lngSource.toString()),
          ),
          lastPoint: GeoPoint(latitude: dLat, longitude: dLng));
    } else if (parcelData!.status == "on ride") {
      drawRoad(
        startPoint: GeoPoint(latitude: dLat, longitude: dLng),
        lastPoint: GeoPoint(
          latitude: destinationLatLong!.latitude,
          longitude: destinationLatLong!.longitude,
        ),
      );
    } else {
      drawRoad(
        startPoint: GeoPoint(
          latitude: departureLatLong!.latitude,
          longitude: departureLatLong!.longitude,
        ),
        lastPoint: GeoPoint(
          latitude: destinationLatLong!.latitude,
          longitude: destinationLatLong!.longitude,
        ),
      );
    }
  }

  Future<void> updateCameraLocation({required GeoPoint source, required GeoPoint destination, required MapController mapController}) async {
    BoundingBox bounds;

    if (source.latitude > destination.latitude && source.longitude > destination.longitude) {
      bounds = BoundingBox(
        north: source.latitude,
        south: destination.latitude,
        east: source.longitude,
        west: destination.longitude,
      );
    } else if (source.longitude > destination.longitude) {
      bounds = BoundingBox(
        north: destination.latitude,
        south: source.latitude,
        east: source.longitude,
        west: destination.longitude,
      );
    } else if (source.latitude > destination.latitude) {
      bounds = BoundingBox(
        north: source.latitude,
        south: destination.latitude,
        east: destination.longitude,
        west: source.longitude,
      );
    } else {
      bounds = BoundingBox(
        north: destination.latitude,
        south: source.latitude,
        east: destination.longitude,
        west: source.longitude,
      );
    }

    await mapController.zoomToBoundingBox(bounds, paddinInPixel: 300);

    // Verify the camera location
    await checkCameraLocation(bounds, mapController);
  }

  Future<void> checkCameraLocation(BoundingBox bounds, MapController mapController) async {
    // await mapController.rotateMapCamera(0);
    BoundingBox currentBounds = await mapController.bounds;

    if (currentBounds.north == -90 || currentBounds.south == -90) {
      return checkCameraLocation(bounds, mapController);
    }
  }
}
