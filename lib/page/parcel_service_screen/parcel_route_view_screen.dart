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
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class ParcelRouteViewScreen extends StatefulWidget {
  const ParcelRouteViewScreen({super.key});

  @override
  State<ParcelRouteViewScreen> createState() => _ParcelRouteViewScreenState();
}

class _ParcelRouteViewScreenState extends State<ParcelRouteViewScreen> {
  dynamic argumentData = Get.arguments;

  GoogleMapController? _controller;

  Map<PolylineId, Polyline> polyLines = {};

  PolylinePoints polylinePoints = PolylinePoints();

  BitmapDescriptor? departureIcon;
  BitmapDescriptor? destinationIcon;
  BitmapDescriptor? taxiIcon;
  BitmapDescriptor? stopIcon;

  late LatLng departureLatLong;
  late LatLng destinationLatLong;

  final Map<String, Marker> _markers = {};

  String? type;
  ParcelData? parcelData;
  String driverEstimateArrivalTime = '';

  @override
  void initState() {
    getArgumentData();
    setIcons();

    super.initState();
  }

  final controllerRideDetails = Get.put(ParcelDetailsController());
  final controllerDashBoard = Get.put(DashBoardController());

  getArgumentData() {
    if (argumentData != null) {
      type = argumentData['type'];
      parcelData = argumentData['data'];

      departureLatLong = LatLng(double.parse(parcelData!.latSource.toString()), double.parse(parcelData!.lngSource.toString()));
      destinationLatLong = LatLng(double.parse(parcelData!.latDestination.toString()), double.parse(parcelData!.lngDestination.toString()));

      if (parcelData!.status == "onride" || parcelData!.status == 'confirmed') {
        Constant.driverLocationUpdateCollection.doc(parcelData!.idConducteur).snapshots().listen((event) async {
          DriverLocationUpdate driverLocationUpdate = DriverLocationUpdate.fromJson(event.data() as Map<String, dynamic>);

          Dio dio = Dio();
          dynamic response = await dio.get(
              "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=${parcelData!.latSource},${parcelData!.lngSource}&destinations=${double.parse(driverLocationUpdate.driverLatitude.toString())},${double.parse(driverLocationUpdate.driverLongitude.toString())}&key=${Constant.kGoogleApiKey}");

          driverEstimateArrivalTime = response.data['rows'][0]['elements'][0]['duration']['text'].toString();

          setState(() {
            departureLatLong = LatLng(double.parse(driverLocationUpdate.driverLatitude.toString()), double.parse(driverLocationUpdate.driverLongitude.toString()));
            _markers[parcelData!.id.toString()] = Marker(
                markerId: MarkerId(parcelData!.id.toString()),
                infoWindow: InfoWindow(title: parcelData!.prenomConducteur.toString()),
                position: departureLatLong,
                icon: taxiIcon!,
                rotation: double.parse(driverLocationUpdate.rotation.toString()));
            getDirections(dLat: double.parse(driverLocationUpdate.driverLatitude.toString()), dLng: double.parse(driverLocationUpdate.driverLongitude.toString()));
          });
        });
      } else {
        getDirections(dLat: 0.0, dLng: 0.0);
      }
    }
  }

  setIcons() async {
    BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(10, 10)), "assets/icons/pickup.png").then((value) {
      departureIcon = value;
    });

    BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(10, 10)), "assets/icons/dropoff.png").then((value) {
      destinationIcon = value;
    });

    BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(10, 10)), "assets/icons/ic_taxi.png").then((value) {
      taxiIcon = value;
    });

    BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(10, 10)), "assets/icons/location.png").then((value) {
      stopIcon = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          GoogleMap(
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            myLocationEnabled: false,
            initialCameraPosition: const CameraPosition(
              target: LatLng(48.8561, 2.2930),
              zoom: 14.0,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
              _controller!.moveCamera(CameraUpdate.newLatLngZoom(departureLatLong, 12));
            },
            polylines: Set<Polyline>.of(polyLines.values),
            markers: _markers.values.toSet(),
          ),
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
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          parcelData!.status != "completed"
                                              ? Padding(
                                                  padding: const EdgeInsets.only(left: 10),
                                                  child: InkWell(
                                                      onTap: () async {
                                                        ShowToastDialog.showLoader("Please wait");
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
                                                      )),
                                                )
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
                    padding: const EdgeInsets.only(
                      bottom: 20,
                    ),
                    child: ButtonThem.buildButton(
                      context,
                      btnColor: AppThemeData.error200,
                      title: 'Cancel Parcel'.tr,
                      btnWidthRatio: 1,
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

  getDirections({required double dLat, required double dLng}) async {
    List<LatLng> polylineCoordinates = [];
    PolylineResult result;

    if (parcelData!.status == "confirmed") {
      PolylineRequest resultdata = PolylineRequest(
        origin: PointLatLng(double.parse(parcelData!.latSource.toString()), double.parse(parcelData!.lngSource.toString())),
        destination: PointLatLng(dLat, dLng),
        mode: TravelMode.driving,
        optimizeWaypoints: true,
      );
      result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: Constant.kGoogleApiKey.toString(),
        request: resultdata,
      );
    } else if (parcelData!.status == "on ride") {
      PolylineRequest resultdata = PolylineRequest(
        origin: PointLatLng(dLat, dLng),
        destination: PointLatLng(destinationLatLong.latitude, destinationLatLong.longitude),
        mode: TravelMode.driving,
        optimizeWaypoints: true,
      );
      result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: Constant.kGoogleApiKey.toString(),
        request: resultdata,
      );
    } else {
      PolylineRequest resultdata = PolylineRequest(
        origin: PointLatLng(departureLatLong.latitude, departureLatLong.longitude),
        destination: PointLatLng(destinationLatLong.latitude, destinationLatLong.longitude),
        mode: TravelMode.driving,
        optimizeWaypoints: true,
      );
      result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: Constant.kGoogleApiKey.toString(),
        request: resultdata,
      );
    }

    _markers['Departure'] = Marker(
      markerId: const MarkerId('Departure'),
      infoWindow: const InfoWindow(title: "Departure"),
      position: LatLng(double.parse(parcelData!.latSource.toString()), double.parse(parcelData!.lngSource.toString())),
      icon: departureIcon!,
    );

    _markers['Destination'] = Marker(
      markerId: const MarkerId('Destination'),
      infoWindow: const InfoWindow(title: "Destination"),
      position: destinationLatLong,
      icon: destinationIcon!,
    );

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }

    addPolyLine(polylineCoordinates);
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: AppThemeData.primary200,
      points: polylineCoordinates,
      width: 6,
      geodesic: true,
    );
    polyLines[id] = polyline;
    updateCameraLocation(polylineCoordinates.first, polylineCoordinates.last, _controller);

    setState(() {});
  }

  Future<void> updateCameraLocation(
    LatLng source,
    LatLng destination,
    GoogleMapController? mapController,
  ) async {
    if (mapController == null) return;

    LatLngBounds bounds;

    if (source.latitude > destination.latitude && source.longitude > destination.longitude) {
      bounds = LatLngBounds(southwest: destination, northeast: source);
    } else if (source.longitude > destination.longitude) {
      bounds = LatLngBounds(southwest: LatLng(source.latitude, destination.longitude), northeast: LatLng(destination.latitude, source.longitude));
    } else if (source.latitude > destination.latitude) {
      bounds = LatLngBounds(southwest: LatLng(destination.latitude, source.longitude), northeast: LatLng(source.latitude, destination.longitude));
    } else {
      bounds = LatLngBounds(southwest: source, northeast: destination);
    }

    CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 10);

    return checkCameraLocation(cameraUpdate, mapController);
  }

  Future<void> checkCameraLocation(CameraUpdate cameraUpdate, GoogleMapController mapController) async {
    mapController.animateCamera(cameraUpdate);
    LatLngBounds l1 = await mapController.getVisibleRegion();
    LatLngBounds l2 = await mapController.getVisibleRegion();

    if (l1.southwest.latitude == -90 || l2.southwest.latitude == -90) {
      return checkCameraLocation(cameraUpdate, mapController);
    }
  }
}
