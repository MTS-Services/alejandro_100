// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cabme/constant/constant.dart';
import 'package:cabme/constant/logdata.dart';
import 'package:cabme/constant/show_toast_dialog.dart';
import 'package:cabme/model/banner_model.dart';
import 'package:cabme/model/driver_location_update.dart';
import 'package:cabme/model/driver_model.dart';
import 'package:cabme/model/payment_method_model.dart';
import 'package:cabme/model/vehicle_category_model.dart';
import 'package:cabme/page/rent_vehicle_screens/rent_vehicle_screen.dart';
import 'package:cabme/service/api.dart';
import 'package:cabme/utils/Preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart' as locationData;
import '../model/payment_setting_model.dart';

class HomeOsmController extends GetxController
    with GetSingleTickerProviderStateMixin {
  RxBool isHomePageLoading = false.obs;

  // Language change tracker to force UI rebuild
  RxString currentLanguage = ''.obs;

  late MapController mapController;
  TabController? tabController;
  Map<String, GeoPoint> markers = <String, GeoPoint>{};

  Rx<RoadInfo> roadInfo = RoadInfo().obs;

  TextEditingController currentLocationController = TextEditingController();
  TextEditingController departureController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  TextEditingController addStop = TextEditingController(text: 'Add Stop'.tr);

  RxString selectPaymentMode = "Payment Method".obs;
  List<AddChildModelData> addChildList = [
    AddChildModelData(editingController: TextEditingController())
  ];
  List<AddStopModelData> multiStopList = [];
  List<AddStopModelData> multiStopListNew = [];

  Rx<VehicleData> vehicleData = VehicleData().obs;
  late PaymentMethodData? paymentMethodData;

  RxBool confirmWidgetVisible = false.obs;

  RxString tripOptionCategory = "General".obs;
  RxString paymentMethodType = "Select Method".obs;
  RxString paymentMethodId = "".obs;
  RxDouble distance = 0.0.obs;
  RxString duration = "".obs;

  var paymentSettingModel = PaymentSettingModel().obs;

  RxBool cash = false.obs;
  RxBool wallet = false.obs;
  RxBool stripe = false.obs;
  RxBool razorPay = false.obs;
  RxBool paypal = false.obs;
  RxBool payStack = false.obs;
  RxBool flutterWave = false.obs;
  RxBool mercadoPago = false.obs;
  RxBool payFast = false.obs;
  RxBool xendit = false.obs;
  RxBool orangePay = false.obs;
  RxBool midtrans = false.obs;
  RxString walletAmount = '0'.obs;

  // keep track of driver markers so we can remove them before adding new ones
  final Map<String, GeoPoint> _driverMarkers = {};

  @override
  void onInit() {
    // Initialize current language
    currentLanguage.value = Preferences.getString(Preferences.languageCodeKey);
    setInitData();
    super.onInit();
  }

  @override
  void onClose() {
    // dispose controllers and clear state
    try {
      currentLocationController.dispose();
      departureController.dispose();
      destinationController.dispose();
      addStop.dispose();
    } catch (_) {}

    markers.clear();
    _driverMarkers.clear();
    confirmWidgetVisible.value = false;
    isHomePageLoading.value = false;
    super.onClose();
  }

  setInitData() async {
    isHomePageLoading.value = true;
    await setTabr();
    await getBannerData();
    if (Constant.homeScreenType == 'UberHome') {
      await initOSMData();
      ShowToastDialog.showLoader("Please wait");
    } else {
      await getCurrentAddress();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getTaxiData();
    });
    paymentSettingModel.value = Constant.getPaymentSetting();
    isHomePageLoading.value = false;
  }

  initOSMData() async {
    await setMapController();
    await setIcons();
  }

  getCurrentAddress({bool setMarker = false}) async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: locationData.LocationAccuracy.high);
      if (Constant.selectedMapType == 'osm') {
        String url =
            'https://nominatim.openstreetmap.org/reverse?format=json&lat=${position.latitude}&lon=${position.longitude}&zoom=18&addressdetails=1';
        var addressData = <String, dynamic>{};
        var package = Platform.isAndroid ? 'com.lock.customer.android' : 'ios.lock.customer';
        http.Response response = await http.get(
          Uri.parse(url),
          headers: {
            'User-Agent': package,
          },
        );

        showLog("API :: URL :: $url");
        showLog("API :: Request Body :: ${jsonEncode({'User-Agent': package})} ");
        showLog("API :: Request Header :: ${API.header.toString()} ");
        showLog("API :: responseStatus :: ${response.statusCode} ");
        showLog("API :: responseBody :: ${response.body} ");

        if (response.statusCode == 200 && response.body.isNotEmpty) {
          Map<String, dynamic> data = json.decode(response.body);
          addressData = data;
          currentLocationController.text = addressData['display_name'] ?? '';
          departureController.text = addressData['display_name'] ?? '';
          departureLatLong.value = GeoPoint(
              latitude: position.latitude, longitude: position.longitude);
          if (setMarker) {
            for (var i = 0; i < Constant.allTaxList.length; i++) {
              try {
                if (addressData["address"]?["county"]?.toString().toUpperCase() ==
                    Constant.allTaxList[i].country?.toUpperCase()) {
                  Constant.taxList.add(Constant.allTaxList[i]);
                }
              } catch (_) {}
            }
            setDepartureMarker(GeoPoint(
                latitude: position.latitude, longitude: position.longitude));
          }
        } else {
          showLog("Nominatim returned non-200: ${response.statusCode}");
        }
      }
    } catch (e) {
      showLog("getCurrentAddress error: $e");
      ShowToastDialog.showToast("Unable to fetch current address");
    }
  }

  Rx<BannerModel> bannerModel = BannerModel().obs;
  setMapController() {
    multiStopList.clear();
    multiStopListNew.clear();
    mapController = MapController(
        initPosition: GeoPoint(latitude: 41.4219057, longitude: -102.0840772));
  }

  Future<dynamic> getBannerData() async {
    try {
      ShowToastDialog.showLoader("Please wait");
      http.Response response =
      await http.get(Uri.parse(API.bannerHome), headers: API.header).timeout(const Duration(seconds: 15));
      var decodedResponse = jsonDecode(response.body);
      showLog("API :: URL :: ${API.bannerHome}");
      showLog("API :: Request Header :: ${API.header.toString()} ");
      showLog("API :: responseStatus :: ${response.statusCode} ");
      showLog("API :: responseBody :: ${response.body} ");
      if (decodedResponse['success'] == 'success') {
        bannerModel.value =
            BannerModel.fromJson(decodedResponse as Map<String, dynamic>);
        ShowToastDialog.closeLoader();
        return decodedResponse;
      } else {
        ShowToastDialog.closeLoader();
        return null;
      }
    } on TimeoutException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }

  Rx<GeoPoint> departureLatLong = GeoPoint(latitude: 0.0, longitude: 0.0).obs;
  Rx<GeoPoint> destinationLatLong = GeoPoint(latitude: 0.0, longitude: 0.0).obs;

  setTabr() {
    if (Constant.parcelActive.toString() == "yes") {
      tabController = TabController(length: 1, vsync: this);
    } else {
      tabController = TabController(length: 1, vsync: this);
    }
    tabController?.addListener(() {
      if (tabController!.indexIsChanging) {
        if (tabController?.index == 1) {
          Get.to(RentVehicleScreen())?.then((v) {
            tabController?.animateTo(0, duration: const Duration(milliseconds: 100));
          });
        }
      }
    });
  }

  Widget? departureIcon;
  Widget? destinationIcon;
  Widget? taxiIcon;
  Widget? stopIcon;

  setIcons() async {
    departureIcon = Image.asset("assets/icons/pickup.png", width: 30, height: 30);
    destinationIcon = Image.asset("assets/icons/dropoff.png", width: 30, height: 30);
    taxiIcon = Image.asset("assets/icons/ic_taxi.png", width: 30, height: 30);
    stopIcon = Image.asset("assets/icons/location.png", width: 30, height: 30);
  }

  addStops() async {
    ShowToastDialog.showLoader("Please wait");
    multiStopList.add(AddStopModelData(editingController: TextEditingController(), latitude: "", longitude: ""));
    multiStopListNew = List<AddStopModelData>.generate(
      multiStopList.length,
          (int index) => AddStopModelData(
          editingController: multiStopList[index].editingController,
          latitude: multiStopList[index].latitude,
          longitude: multiStopList[index].longitude),
    );
    ShowToastDialog.closeLoader();
    update();
  }

  removeStops(int index) {
    if (index < 0 || index >= multiStopList.length) return;
    ShowToastDialog.showLoader("Please wait");
    try {
      multiStopList[index].editingController.dispose();
    } catch (_) {}
    multiStopList.removeAt(index);
    multiStopListNew = List<AddStopModelData>.generate(
      multiStopList.length,
          (int i) => AddStopModelData(
          editingController: multiStopList[i].editingController,
          latitude: multiStopList[i].latitude,
          longitude: multiStopList[i].longitude),
    );
    ShowToastDialog.closeLoader();
    update();
  }

  clearData() {
    selectPaymentMode.value = "Payment Method";
    tripOptionCategory.value = "General";
    paymentMethodType.value = "Select Method";
    paymentMethodId.value = "";
    distance.value = 0.0;
    duration.value = "";
    multiStopList.clear();
    multiStopListNew.clear();
  }

  RxList<DriverLocationUpdate> driverLocationList =
      <DriverLocationUpdate>[].obs;
  Future getTaxiData() async {
    try {
      Constant.driverLocationUpdateCollection
          .where("active", isEqualTo: true)
          .snapshots()
          .listen((event) async {
        // clear previous driver markers
        for (var key in _driverMarkers.keys.toList()) {
          try {
            await mapController.removeMarker(_driverMarkers[key]!);
          } catch (_) {}
          _driverMarkers.remove(key);
        }
        driverLocationList.clear();

        for (var element in event.docs) {
          DriverLocationUpdate driverLocationUpdate =
          DriverLocationUpdate.fromJson(
              element.data() as Map<String, dynamic>);
          driverLocationList.add(driverLocationUpdate);
        }

        if (Constant.homeScreenType == 'UberHome' && taxiIcon != null) {
          for (var element in driverLocationList) {
            double lat = 0.0;
            double lng = 0.0;
            try {
              lat = double.parse(element.driverLatitude?.toString() ?? "0.0");
              lng = double.parse(element.driverLongitude?.toString() ?? "0.0");
            } catch (_) {}
            if (lat != 0.0 || lng != 0.0) {
              final gp = GeoPoint(latitude: lat, longitude: lng);
              try {
                await mapController.addMarker(gp, markerIcon: MarkerIcon(iconWidget: taxiIcon!));
                String key = element.driverId?.toString() ?? "${lat}_$lng";
                _driverMarkers[key] = gp;
              } catch (e) {
                showLog("Failed to add taxi marker: $e");
              }
            }
          }
        }
      });
    } catch (e) {
      showLog("getTaxiData error: $e");
    }
  }

  Future<PlacesDetailsResponse?> placeSelectAPI(BuildContext context) async {
    try {
      Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: Constant.kGoogleApiKey,
        mode: Mode.overlay,
        onError: (response) {},
        language: 'fr',
        resultTextStyle: Theme.of(context).textTheme.titleMedium,
        types: [],
        strictbounds: false,
        components: [],
      );

      if (p == null) return null;
      return await displayPrediction(p);
    } catch (e) {
      showLog("placeSelectAPI error: $e");
      return null;
    }
  }

  Future<PlacesDetailsResponse?> displayPrediction(Prediction p) async {
    try {
      GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: Constant.kGoogleApiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders(),
      );
      PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId.toString());
      return detail;
    } catch (e) {
      showLog("displayPrediction error: $e");
      return null;
    }
  }

  Future<dynamic> getUserPendingPayment() async {
    try {
      ShowToastDialog.showLoader("Please wait");

      Map<String, dynamic> bodyParams = {
        'user_id': Preferences.getInt(Preferences.userId)
      };
      final response = await http.post(Uri.parse(API.userPendingPayment),
          headers: API.header, body: jsonEncode(bodyParams)).timeout(const Duration(seconds: 15));
      showLog("API :: URL :: ${API.userPendingPayment}");
      showLog("API :: Body :: ${jsonEncode(bodyParams)}");
      showLog("API :: Request Header :: ${API.header.toString()} ");
      showLog("API :: responseStatus :: ${response.statusCode} ");
      showLog("API :: responseBody :: ${response.body} ");
      Map<String, dynamic> responseBody = json.decode(response.body);
      ShowToastDialog.closeLoader();
      if (response.statusCode == 200) {
        return responseBody;
      } else {
        ShowToastDialog.showToast('Something went wrong. Please try again later');
        throw Exception('Failed to load pending payments');
      }
    } on TimeoutException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }

  Future<VehicleCategoryModel?> getVehicleCategory() async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.get(Uri.parse(API.getVehicleCategory),
          headers: API.header).timeout(const Duration(seconds: 15));
      showLog("API :: URL :: ${API.getVehicleCategory}");
      showLog("API :: Request Header :: ${API.header.toString()} ");
      showLog("API :: responseStatus :: ${response.statusCode} ");
      showLog("API :: responseBody :: ${response.body} ");
      Map<String, dynamic> responseBody = json.decode(response.body);
      ShowToastDialog.closeLoader();
      if (response.statusCode == 200) {
        update();
        return VehicleCategoryModel.fromJson(responseBody);
      } else {
        ShowToastDialog.showToast('Something went wrong. Please try again later');
        throw Exception('Failed to load vehicle categories');
      }
    } on TimeoutException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }

  Future<DriverModel?> getDriverDetails(
      String typeVehicle, String lat1, String lng1) async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.get(
          Uri.parse(
              "${API.driverDetails}?type_vehicle=$typeVehicle&lat1=$lat1&lng1=$lng1"),
          headers: API.header).timeout(const Duration(seconds: 15));
      showLog(
          "API :: URL :: ${API.driverDetails}?type_vehicle=$typeVehicle&lat1=$lat1&lng1=$lng1");
      showLog("API :: Request Header :: ${API.header.toString()} ");
      showLog("API :: responseStatus :: ${response.statusCode} ");
      showLog("API :: responseBody :: ${response.body} ");
      Map<String, dynamic> responseBody = json.decode(response.body);
      ShowToastDialog.closeLoader();
      if (response.statusCode == 200) {
        return DriverModel.fromJson(responseBody);
      } else {
        ShowToastDialog.showToast('Something went wrong. Please try again later');
        throw Exception('Failed to load driver details');
      }
    } on TimeoutException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }

  Future<dynamic> setFavouriteRide(Map<String, String> bodyParams) async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.post(Uri.parse(API.setFavouriteRide),
          headers: API.header, body: jsonEncode(bodyParams)).timeout(const Duration(seconds: 15));
      Map<String, dynamic> responseBody = json.decode(response.body);
      showLog("API :: URL :: ${API.setFavouriteRide}");
      showLog("API :: URL :: ${jsonEncode(bodyParams)}");
      showLog("API :: Request Header :: ${API.header.toString()} ");
      showLog("API :: responseStatus :: ${response.statusCode} ");
      showLog("API :: responseBody :: ${response.body} ");
      ShowToastDialog.closeLoader();
      if (response.statusCode == 200) {
        return responseBody;
      } else {
        ShowToastDialog.showToast('Something went wrong. Please try again later');
        throw Exception('Failed to set favourite ride');
      }
    } on TimeoutException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }

  Future<dynamic> bookRide(Map<String, dynamic> bodyParams) async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.post(Uri.parse(API.bookRides),
          headers: API.header, body: jsonEncode(bodyParams)).timeout(const Duration(seconds: 15));
      showLog("API :: URL :: ${API.bookRides}");
      showLog("API :: URL :: ${jsonEncode(bodyParams)}");
      showLog("API :: Request Header :: ${API.header.toString()} ");
      showLog("API :: responseStatus :: ${response.statusCode} ");
      showLog("API :: responseBody :: ${response.body} ");
      Map<String, dynamic> responseBody = json.decode(response.body);
      ShowToastDialog.closeLoader();
      if (response.statusCode == 200) {
        if (responseBody['success'].toString().toLowerCase() == 'failed') {
          ShowToastDialog.showToast(responseBody['error'].toString());
          return null;
        } else {
          return responseBody;
        }
      } else {
        ShowToastDialog.showToast('Something went wrong. Please try again later');
        throw Exception('Failed to book ride');
      }
    } on TimeoutException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }

  double calculateTripPrice(
      {required double distance,
        required double minimumDeliveryChargesWithin,
        required double minimumDeliveryCharges,
        required double deliveryCharges}) {
    double cout = 0.0;

    if (distance > minimumDeliveryChargesWithin) {
      cout = (distance * deliveryCharges).toDouble();
    } else {
      cout = minimumDeliveryCharges;
    }
    return cout;
  }

  setDepartureMarker(GeoPoint departure) async {
    if (Constant.homeScreenType == 'OlaHome') {
      departureLatLong.value = departure;
    } else {
      if (departure.latitude != 0 && departure.longitude != 0) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (markers.containsKey('Departure')) {
            try {
              await mapController.removeMarker(markers['Departure']!);
            } catch (_) {}
          }
          try {
            await mapController.addMarker(departure,
                markerIcon: MarkerIcon(iconWidget: departureIcon),
                angle: pi / 3,
                iconAnchor: IconAnchor(
                  anchor: Anchor.top,
                ));
            markers['Departure'] = departure;
          } catch (e) {
            showLog("Failed to add departure marker: $e");
          }

          departureLatLong.value = departure;
          if (departureLatLong.value.latitude != 0 &&
              destinationLatLong.value.latitude != 0) {
            await getDirections();
            confirmWidgetVisible.value = true;
          } else {
            try {
              await mapController.moveTo(departure, animate: true);
            } catch (_) {}
          }
        });
      }
    }
  }

  getDirections() async {
    List<GeoPoint> wayPointList = [];
    wayPointList.add(GeoPoint(
        latitude: departureLatLong.value.latitude,
        longitude: departureLatLong.value.longitude));
    for (var i = 0; i < multiStopListNew.length; i++) {
      double lat = 0;
      double lng = 0;
      try {
        lat = multiStopListNew[i].latitude.isEmpty
            ? 0
            : double.parse(multiStopListNew[i].latitude.toString());
        lng = multiStopListNew[i].longitude.isEmpty
            ? 0
            : double.parse(multiStopListNew[i].longitude.toString());
      } catch (_) {}
      if (lat != 0 || lng != 0) {
        wayPointList.add(GeoPoint(latitude: lat, longitude: lng));
      }
    }
    wayPointList.add(GeoPoint(
        latitude: destinationLatLong.value.latitude,
        longitude: destinationLatLong.value.longitude));
    addPolyLine(wayPointList);
  }

  addPolyLine(List<GeoPoint> wayPointList) async {
    if (Constant.homeScreenType != 'OlaHome') {
      try {
        await mapController.removeLastRoad();
      } catch (_) {}
      try {
        roadInfo.value = await mapController.drawRoad(
          wayPointList.first,
          wayPointList.last,
          roadType: RoadType.car,
          intersectPoint: [...wayPointList],
          roadOption: RoadOption(
            roadWidth: Platform.isIOS ? 50 : 10,
            roadColor: Colors.blue,
            roadBorderWidth:
            Platform.isIOS ? 15 : 10, // Set the road border width (outline)
            roadBorderColor: Colors.black, // Border color
            zoomInto: true,
          ),
        );
      } catch (e) {
        showLog("drawRoad error: $e");
      }

      await updateCameraLocation(
          source: wayPointList.first,
          destination: wayPointList.last,
          mapController: mapController);
    }
  }

  Future<void> updateCameraLocation(
      {required GeoPoint source,
        required GeoPoint destination,
        required MapController mapController}) async {
    try {
      // collect all relevant points (source,destination,markers,driver markers)
      List<GeoPoint> points = [source, destination];
      points.addAll(markers.values);
      points.addAll(_driverMarkers.values);

      double north = points.first.latitude;
      double south = points.first.latitude;
      double east = points.first.longitude;
      double west = points.first.longitude;

      for (var p in points) {
        if (p.latitude > north) north = p.latitude;
        if (p.latitude < south) south = p.latitude;
        if (p.longitude > east) east = p.longitude;
        if (p.longitude < west) west = p.longitude;
      }

      // add small padding to bounds
      const double padDegrees = 0.01;
      BoundingBox bounds = BoundingBox(
        north: north + padDegrees,
        south: south - padDegrees,
        east: east + padDegrees,
        west: west - padDegrees,
      );

      await mapController.zoomToBoundingBox(bounds, paddinInPixel: 300);

      await checkCameraLocation(bounds, mapController, attemptsLeft: 5);
    } catch (e) {
      showLog("updateCameraLocation error: $e");
    }
  }

  Future<void> checkCameraLocation(
      BoundingBox bounds, MapController mapController,
      {int attemptsLeft = 5}) async {
    try {
      if (attemptsLeft <= 0) return;
      BoundingBox currentBounds = await mapController.bounds;

      if (currentBounds.north == -90 || currentBounds.south == -90) {
        await Future.delayed(const Duration(milliseconds: 300));
        return checkCameraLocation(bounds, mapController, attemptsLeft: attemptsLeft - 1);
      }
    } catch (e) {
      showLog("checkCameraLocation error: $e");
    }
  }

  setDestinationMarker(GeoPoint destination) async {
    if (Constant.homeScreenType != 'UberHome') {
      destinationLatLong.value = destination;
    } else {
      if (destination.latitude != 0 && destination.longitude != 0) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (markers.containsKey('Destination')) {
            try {
              await mapController.removeMarker(markers['Destination']!);
            } catch (_) {}
          }
          try {
            await mapController.addMarker(destination,
                markerIcon: MarkerIcon(iconWidget: destinationIcon),
                angle: pi / 3,
                iconAnchor: IconAnchor(
                  anchor: Anchor.top,
                ));
            markers['Destination'] = destination;
          } catch (e) {
            showLog("Failed to add destination marker: $e");
          }

          destinationLatLong.value = destination;

          await getDirections();
          confirmWidgetVisible.value = true;
        });
      }
    }
  }

  setStopMarker(GeoPoint destination, int index) async {
    if (Constant.homeScreenType != 'UberHome') {
      // For non-UberHome behavior this function should not override destinationLatLong
      return;
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        String key = 'Stop $index';
        if (markers.containsKey(key)) {
          try {
            await mapController.removeMarker(markers[key]!);
          } catch (_) {}
        }
        try {
          await mapController.addMarker(destination,
              markerIcon: MarkerIcon(iconWidget: stopIcon),
              angle: pi / 3,
              iconAnchor: IconAnchor(
                anchor: Anchor.top,
              ));
          markers[key] = destination;
        } catch (e) {
          showLog("Failed to add stop marker: $e");
        }

        if (departureLatLong.value.latitude != 0 &&
            departureLatLong.value.longitude != 0) {
          await getDirections();
          confirmWidgetVisible.value = true;
        }
      });
    }
  }
  void updateLanguage(String newLanguage) {
    currentLanguage.value = newLanguage;
    addStop.text = 'Add Stop'.tr; // Update translation safely
    update(); // Force controller update
  }
}

class AddChildModelData {
  TextEditingController editingController = TextEditingController();

  AddChildModelData({required this.editingController});
}

class AddStopModelData {
  String latitude = "";
  String longitude = "";
  TextEditingController editingController = TextEditingController();

  AddStopModelData({
    required this.editingController,
    required this.latitude,
    required this.longitude,
  });
}
