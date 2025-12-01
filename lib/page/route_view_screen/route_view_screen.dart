import 'package:cabme/constant/constant.dart';
import 'package:cabme/constant/show_toast_dialog.dart';
import 'package:cabme/controller/dash_board_controller.dart';
import 'package:cabme/controller/ride_details_controller.dart';
import 'package:cabme/model/driver_location_update.dart';
import 'package:cabme/model/ride_model.dart';
import 'package:cabme/page/chats_screen/conversation_screen.dart';
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

class RouteViewScreen extends StatefulWidget {
  const RouteViewScreen({super.key});

  @override
  State<RouteViewScreen> createState() => _RouteViewScreenState();
}

class _RouteViewScreenState extends State<RouteViewScreen> {
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
  RideData? rideData;
  String driverEstimateArrivalTime = '';

  @override
  void initState() {
    getArgumentData();
    setIcons();

    super.initState();
  }

  final controllerRideDetails = Get.put(RideDetailsController());
  final controllerDashBoard = Get.put(DashBoardController());

  getArgumentData() {
    if (argumentData != null) {
      type = argumentData['type'];
      rideData = argumentData['data'];

      departureLatLong = LatLng(double.parse(rideData!.latitudeDepart.toString()), double.parse(rideData!.longitudeDepart.toString()));
      destinationLatLong = LatLng(double.parse(rideData!.latitudeArrivee.toString()), double.parse(rideData!.longitudeArrivee.toString()));

      if (rideData!.statut == "on ride" || rideData!.statut == 'confirmed') {
        Constant.driverLocationUpdateCollection.doc(rideData!.idConducteur).snapshots().listen((event) async {
          DriverLocationUpdate driverLocationUpdate = DriverLocationUpdate.fromJson(event.data() as Map<String, dynamic>);

          Dio dio = Dio();
          dynamic response = await dio.get(
              "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=${rideData!.latitudeDepart},${rideData!.longitudeDepart}&destinations=${double.parse(driverLocationUpdate.driverLatitude.toString())},${double.parse(driverLocationUpdate.driverLongitude.toString())}&key=${Constant.kGoogleApiKey}");

          driverEstimateArrivalTime = response.data['rows'][0]['elements'][0]['duration']['text'].toString();

          setState(() {
            departureLatLong = LatLng(double.parse(driverLocationUpdate.driverLatitude.toString()), double.parse(driverLocationUpdate.driverLongitude.toString()));
            _markers[rideData!.id.toString()] = Marker(
                markerId: MarkerId(rideData!.id.toString()),
                infoWindow: InfoWindow(title: rideData!.prenomConducteur.toString()),
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
            left: 5,
            child: SafeArea(
              child: IconButton(
                onPressed: () => Get.back(),
                icon: Transform(
                  alignment: Alignment.center,
                  transform: Directionality.of(context) == TextDirection.rtl ? Matrix4.rotationY(3.14159) : Matrix4.identity(),
                  child: SvgPicture.asset(
                    'assets/icons/ic_left.svg',
                    width: 35,
                    height: 35,
                    colorFilter: ColorFilter.mode(
                      AppThemeData.grey900,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: themeChange.getThem() ? AppThemeData.grey200Dark : AppThemeData.grey200,
                    ),
                    color: themeChange.getThem() ? AppThemeData.surface50Dark : AppThemeData.surface50,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                    child: Column(
                      children: [
                        if (rideData!.statut == 'confirmed')
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Driver Estimate Arrival Time : '.tr,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: AppThemeData.medium,
                                      color: themeChange.getThem() ? AppThemeData.grey900Dark : AppThemeData.grey900,
                                    ),
                                  ),
                                ),
                                Text(
                                  driverEstimateArrivalTime,
                                  style: TextStyle(fontFamily: AppThemeData.medium, color: AppThemeData.secondary200, fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        Visibility(
                          visible:
                              Constant.rideOtp.toString().toLowerCase() == 'yes'.toLowerCase() && rideData!.statut == 'confirmed' && rideData!.rideType != 'driver' ? true : false,
                          child: Column(
                            children: [
                              Divider(
                                color: themeChange.getThem() ? AppThemeData.grey200Dark : AppThemeData.grey200,
                                thickness: 1,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'OTP : '.tr,
                                    style: TextStyle(
                                      fontFamily: AppThemeData.regular,
                                      color: themeChange.getThem() ? AppThemeData.grey400 : AppThemeData.grey300Dark,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    rideData!.otp.toString(),
                                    style: TextStyle(
                                      letterSpacing: 1.2,
                                      fontFamily: AppThemeData.semiBold,
                                      color: themeChange.getThem() ? AppThemeData.grey900Dark : AppThemeData.grey900,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                color: themeChange.getThem() ? AppThemeData.grey200Dark : AppThemeData.grey200,
                                thickness: 1,
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.only(top: rideData!.statut == 'confirmed' ? 10 : 0),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(80),
                                child: CachedNetworkImage(
                                  imageUrl: rideData!.photoPath.toString(),
                                  height: 60,
                                  width: 60,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Constant.loader(context),
                                  errorWidget: (context, url, error) => Image.asset(
                                    "assets/images/appIcon.png",
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${rideData!.prenomConducteur.toString()} ${rideData!.nomConducteur.toString()}",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: AppThemeData.semiBold,
                                          color: themeChange.getThem() ? AppThemeData.grey900Dark : AppThemeData.grey900,
                                          fontSize: 16,
                                          letterSpacing: 0.6,
                                        )),
                                    const SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        StarRating(
                                            size: 20, rating: rideData!.moyenne != "null" ? double.parse(rideData!.moyenne.toString()) : 0.0, color: AppThemeData.secondary200),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        Visibility(
                                          visible: rideData!.statut == "confirmed" ? true : false,
                                          child: InkWell(
                                              onTap: () {
                                                Get.to(ConversationScreen(), arguments: {
                                                  'receiverId': int.parse(rideData!.idConducteur.toString()),
                                                  'orderId': int.parse(rideData!.id.toString()),
                                                  'receiverName': "${rideData!.prenomConducteur} ${rideData!.nomConducteur}",
                                                  'receiverPhoto': rideData!.photoPath
                                                });
                                              },
                                              child: Image.asset(
                                                'assets/icons/chat_icon.png',
                                                height: 40,
                                                width: 40,
                                                fit: BoxFit.cover,
                                              )),
                                        ),
                                        rideData!.statut != "rejected"
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
                                                      height: 40,
                                                      width: 40,
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
                                                Constant.makePhoneCall(rideData!.driverPhone.toString());
                                              },
                                              child: Container(
                                                alignment: Alignment.center,
                                                height: 40,
                                                width: 40,
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
                                        Visibility(
                                          visible: rideData!.statut == "on ride" ? true : false,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 10),
                                            child: ButtonThem.buildButton(
                                              context,
                                              radius: 5,
                                              txtSize: 12,
                                              title: 'sos'.tr,
                                              btnHeight: 40,
                                              btnWidthRatio: 0.15,
                                              onPress: () async {
                                                LocationData location = await Location().getLocation();
                                                Map<String, dynamic> bodyParams = {
                                                  'lat': location.latitude,
                                                  'lng': location.longitude,
                                                  'ride_id': rideData!.id,
                                                };
                                                controllerRideDetails.sos(bodyParams).then((value) {
                                                  if (value != null) {
                                                    if (value['success'] == "success") {
                                                      ShowToastDialog.showToast(value['message']);
                                                    }
                                                  }
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Text(
                                      rideData!.dateRetour.toString(),
                                      style: TextStyle(
                                        color: themeChange.getThem() ? AppThemeData.grey900Dark : AppThemeData.grey900,
                                        fontFamily: AppThemeData.medium,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    Visibility(
                      visible: rideData!.statut == "on ride" ? true : false,
                      child: Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: ButtonThem.buildButton(
                            context,
                            title: 'I do not feel safe'.tr,
                            btnWidthRatio: 1,
                            onPress: () async {
                              LocationData location = await Location().getLocation();
                              Map<String, dynamic> bodyParams = {
                                'lat': location.latitude,
                                'lng': location.longitude,
                                'user_id': Preferences.getInt(Preferences.userId).toString(),
                                'user_name': "${controllerRideDetails.userModel!.data!.prenom} ${controllerRideDetails.userModel!.data!.nom}",
                                'user_cat': controllerRideDetails.userModel!.data!.userCat,
                                'id_driver': rideData!.idConducteur,
                                'feel_safe': 0,
                                'trip_id': rideData!.id,
                              };
                              controllerRideDetails.feelNotSafe(bodyParams).then((value) {
                                if (value != null) {
                                  if (value['success'] == "success") {
                                    ShowToastDialog.showToast("Report submitted".tr);
                                  }
                                }
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    // Visibility(
                    //   visible: rideData!.statut == "confirmed" ? true : false,
                    //   child: Expanded(
                    //     child: Padding(
                    //       padding: const EdgeInsets.only(bottom: 5),
                    //       child: ButtonThem.buildButton(
                    //         context,
                    //         title: 'Conform Ride'.tr,
                    //         btnHeight: 45,
                    //         btnWidthRatio: 0.8,
                    //         btnColor: AppThemeData.primary200,
                    //         txtColor: Colors.white,
                    //         onPress: () async {
                    //           showDialog(
                    //             barrierColor: Colors.black26,
                    //             context: context,
                    //             builder: (context) {
                    //               return CustomAlertDialog(
                    //                 title: "Do you want to confirm this ride?",
                    //                 onPressNegative: () {
                    //                   Get.back();
                    //                 },
                    //                 onPressPositive: () {
                    //                   Map<String, dynamic> bodyParams = {
                    //                     'id_ride': rideData!.id.toString(),
                    //                     'id_user': rideData!.idConducteur.toString(),
                    //                     'use_name': rideData!.prenomConducteur.toString(),
                    //                     'car_driver_confirmed': 1,
                    //                     'from_id': Preferences.getInt(Preferences.userId).toString(),
                    //                   };
                    //                   controllerRideDetails.setConformRequest(bodyParams).then((value) {
                    //                     if (value != null) {
                    //                       Get.back();
                    //                       showDialog(
                    //                           context: context,
                    //                           builder: (BuildContext context) {
                    //                             return CustomDialogBox(
                    //                               title: "On ride Successfully",
                    //                               descriptions: "Ride Successfully On ride .",
                    //                               onPress: () {
                    //                                 Get.back();
                    //                                 controllerDashBoard.onSelectItem(4);
                    //                               },
                    //                               img: Image.asset('assets/images/green_checked.png'),
                    //                             );
                    //                           });
                    //                     }
                    //                   });
                    //                 },
                    //               );
                    //             },
                    //           );
                    //         },
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Visibility(
                      visible: rideData!.statut == "on ride" ? true : false,
                      child: const SizedBox(width: 10),
                    ),
                    Visibility(
                      visible: rideData!.statut == "rejected" ? false : true,
                      child: Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: ButtonThem.buildButton(
                            context,
                            btnColor: AppThemeData.error200,
                            title: 'Cancel Ride'.tr,
                            btnWidthRatio: 1,
                            onPress: () async {
                              buildShowBottomSheet(context, themeChange.getThem());
                              // showDialog(
                              //   barrierColor: Colors.black26,
                              //   context: context,
                              //   builder: (context) {
                              //     return CustomAlertDialog(
                              //       title: "Do you want to cancel this booking?",
                              //       onPressNegative: () {
                              //         Get.back();
                              //       },
                              //       onPressPositive: () {
                              //         Map<String, String> bodyParams = {
                              //           'id_ride': rideData!.id.toString(),
                              //           'id_user': rideData!.idConducteur.toString(),
                              //           'name': rideData!.prenom.toString(),
                              //           'from_id': Preferences.getInt(Preferences.userId).toString(),
                              //           'user_cat': controllerRideDetails.userModel!.data!.userCat.toString(),
                              //         };
                              //         controllerRideDetails.canceledRide(bodyParams).then((value) {
                              //           Get.back();
                              //           if (value != null) {
                              //             showDialog(
                              //                 context: context,
                              //                 builder: (BuildContext context) {
                              //                   return CustomDialogBox(
                              //                     title: "Cancel Successfully",
                              //                     descriptions: "Ride Successfully cancel.",
                              //                     onPress: () {
                              //                       Get.back();
                              //                       controllerDashBoard.onSelectItem(4);
                              //                     },
                              //                     img: Image.asset('assets/images/green_checked.png'),
                              //                   );
                              //                 });
                              //           }
                              //         });
                              //       },
                              //     );
                              //   },
                              // );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
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
                        "Cancel Trip".tr,
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
                        "Write a reason for trip cancellation".tr,
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
                                title: 'Cancel Trip'.tr,
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
                                            Map<String, String> bodyParams = {
                                              'id_ride': rideData!.id.toString(),
                                              'id_user': rideData!.idConducteur.toString(),
                                              'name': "${rideData!.prenom} ${rideData!.nom}",
                                              'from_id': Preferences.getInt(Preferences.userId).toString(),
                                              'user_cat': controllerRideDetails.userModel!.data!.userCat.toString(),
                                              'reason': resonController.text.toString(),
                                            };
                                            controllerRideDetails.canceledRide(bodyParams).then((value) {
                                              Get.back();
                                              if (value != null) {
                                                showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return CustomDialogBox(
                                                        title: "Cancel Successfully".tr,
                                                        descriptions: "Ride Successfully cancel.".tr,
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
    List<PolylineWayPoint> wayPointList = [];
    for (var i = 0; i < rideData!.stops!.length; i++) {
      wayPointList.add(PolylineWayPoint(location: rideData!.stops![i].location!));
    }

    if (rideData!.statut == "confirmed") {
      PolylineRequest requestData = PolylineRequest(
        wayPoints: [],
        optimizeWaypoints: true,
        mode: TravelMode.driving,
        origin: PointLatLng(dLat, dLng),
        destination: PointLatLng(double.parse(rideData!.latitudeDepart.toString()), double.parse(rideData!.longitudeDepart.toString())),
      );
      result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: Constant.kGoogleApiKey.toString(),
        request: requestData,
      );
    } else if (rideData!.statut == "on ride") {
      PolylineRequest requestData = PolylineRequest(
        wayPoints: wayPointList,
        optimizeWaypoints: true,
        mode: TravelMode.driving,
        origin: PointLatLng(dLat, dLng),
        destination: PointLatLng(destinationLatLong.latitude, destinationLatLong.longitude),
      );
      result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: Constant.kGoogleApiKey.toString(),
        request: requestData,
      );
    } else {
      PolylineRequest requestData = PolylineRequest(
        wayPoints: wayPointList,
        optimizeWaypoints: true,
        mode: TravelMode.driving,
        origin: PointLatLng(departureLatLong.latitude, departureLatLong.longitude),
        destination: PointLatLng(destinationLatLong.latitude, destinationLatLong.longitude),
      );
      result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: Constant.kGoogleApiKey.toString(),
        request: requestData,
      );
    }

    _markers['Departure'] = Marker(
      markerId: const MarkerId('Departure'),
      infoWindow: const InfoWindow(title: "Departure"),
      position: LatLng(double.parse(rideData!.latitudeDepart.toString()), double.parse(rideData!.longitudeDepart.toString())),
      icon: departureIcon!,
    );

    _markers['Destination'] = Marker(
      markerId: const MarkerId('Destination'),
      infoWindow: const InfoWindow(title: "Destination"),
      position: destinationLatLong,
      icon: destinationIcon!,
    );

    for (var i = 0; i < rideData!.stops!.length; i++) {
      _markers['${rideData!.stops![i]}'] = Marker(
        markerId: MarkerId('${rideData!.stops![i]}'),
        infoWindow: InfoWindow(title: rideData!.stops![i].location!),
        position: LatLng(double.parse(rideData!.stops![i].latitude!), double.parse(rideData!.stops![i].longitude!)),
        icon: stopIcon!,
      );
    }

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
