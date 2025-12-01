// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'dart:io';
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
import 'package:cabme/themes/constant_colors.dart';
import 'package:cabme/utils/Preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import '../model/payment_setting_model.dart';
import 'package:geocoding/geocoding.dart' as get_cord_address;

import 'package:geolocator/geolocator.dart' as locationData;

class HomeController extends GetxController with GetSingleTickerProviderStateMixin {
  //for Choose your Rider
  TabController? tabController;
  LatLng center = const LatLng(41.4219057, -102.0840772);

  final TextEditingController currentLocationController = TextEditingController();
  final TextEditingController departureController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

  RxString selectPaymentMode = "Payment Method".obs;
  List<AddChildModel> addChildList = [AddChildModel(editingController: TextEditingController())];
  List<AddStopModel> multiStopList = [];
  List<AddStopModel> multiStopListNew = [];

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
  RxBool isHomePageLoading = false.obs;
  RxString walletAmount = '0'.obs;
  @override
  void onInit() {
    setInitData();
    super.onInit();
  }

  setInitData() async {
    isHomePageLoading.value = true;
    if (Constant.homeScreenType != 'OlaHome') {
      await setIcons();
    }
    await getTaxiData();
    await initData();
    await setTabr();
    await getCurrentAddress();
    await getBannerData();
    paymentSettingModel.value = Constant.getPaymentSetting();
    isHomePageLoading.value = false;
  }

  initData() async {
    multiStopList.clear();
    multiStopListNew.clear();
    await getCurrentLocation(true);
  }

  getCurrentAddress() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: locationData.LocationAccuracy.high);
    if (Constant.selectedMapType != 'osm') {
      currentLocationController.text = await Constant().getAddressFromLatLong(position);
      departureController.text = await Constant().getAddressFromLatLong(position);
      departureLatLong.value = LatLng(position.latitude, position.longitude);
    }
  }

  Rx<Location> currentLocation = Location().obs;
  getCurrentLocation(bool isDepartureSet) async {
    if (isDepartureSet) {
      LocationData location = await currentLocation.value.getLocation();
      List<get_cord_address.Placemark> placeMarks = await get_cord_address.placemarkFromCoordinates(location.latitude ?? 0.0, location.longitude ?? 0.0);

      for (var i = 0; i < Constant.allTaxList.length; i++) {
        if (placeMarks.first.country.toString().toUpperCase() == Constant.allTaxList[i].country!.toUpperCase()) {
          Constant.taxList.add(Constant.allTaxList[i]);
        }
      }

      final address = (placeMarks.first.subLocality!.isEmpty ? '' : "${placeMarks.first.subLocality}, ") +
          (placeMarks.first.street!.isEmpty ? '' : "${placeMarks.first.street}, ") +
          (placeMarks.first.name!.isEmpty ? '' : "${placeMarks.first.name}, ") +
          (placeMarks.first.subAdministrativeArea!.isEmpty ? '' : "${placeMarks.first.subAdministrativeArea}, ") +
          (placeMarks.first.administrativeArea!.isEmpty ? '' : "${placeMarks.first.administrativeArea}, ") +
          (placeMarks.first.country!.isEmpty ? '' : "${placeMarks.first.country}, ") +
          (placeMarks.first.postalCode!.isEmpty ? '' : "${placeMarks.first.postalCode}, ");
      currentLocationController.text = address;
      departureController.text = address;
      setDepartureMarker(LatLng(location.latitude ?? 0.0, location.longitude ?? 0.0));
    }
  }

  GoogleMapController? mapController;
  setDepartureMarker(LatLng departure) {
    departureLatLong.value = departure;

    if (Constant.homeScreenType != 'OlaHome') {
      markers.remove("Departure");
      markers['Departure'] = Marker(
        markerId: const MarkerId('Departure'),
        infoWindow: InfoWindow(title: "Departure".tr),
        position: departure,
        icon: departureIcon!,
      );

      mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(departure.latitude, departure.longitude), zoom: 14)));

      // _controller?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(departure.latitude, departure.longitude), zoom: 18)));
      if (departureLatLong.value.latitude != 0 && destinationLatLong.value.latitude != 0) {
        getDirections();
        confirmWidgetVisible.value = true;
        // conformationBottomSheet(context);
      }
    }
  }

  setDestinationMarker(LatLng destination) {
    destinationLatLong.value = destination;
    if (Constant.homeScreenType != 'OlaHome') {
      markers['Destination'] = Marker(
        markerId: const MarkerId('Destination'),
        infoWindow: InfoWindow(title: "Destination".tr),
        position: destination,
        icon: destinationIcon!,
      );

      if (departureLatLong.value.latitude != 0 && destinationLatLong.value.latitude != 0) {
        getDirections();
        confirmWidgetVisible.value = true;
        // conformationBottomSheet(context);
      }
    }
  }

  setStopMarker(LatLng destination, int index) {
    // final List<int> codeUnits = "Anand".codeUnits;
    // final Uint8List unit8List = Uint8List.fromList(codeUnits);
    // print('\x1b[97m ===== $unit8List =====');
    markers['Stop $index'] = Marker(
      markerId: MarkerId('Stop $index'),
      infoWindow: InfoWindow(title: "${"Stop".tr} ${String.fromCharCode(index + 65)}"),
      position: destination,
      icon: stopIcon!,
    ); //BitmapDescriptor.fromBytes(unit8List));
    // destinationLatLong = destination;

    if (departureLatLong.value.latitude != 0 && destinationLatLong.value.latitude != 0) {
      getDirections();
      confirmWidgetVisible.value = true;
      // conformationBottomSheet(context);
    }
  }

  Rx<LatLng> departureLatLong = const LatLng(0.0, 0.0).obs;
  Rx<LatLng> destinationLatLong = const LatLng(0.0, 0.0).obs;
  getDirections() async {
    if (Constant.homeScreenType != 'OlaHome') {
      List<PolylineWayPoint> wayPointList = [];
      for (var i = 0; i < multiStopList.length; i++) {
        wayPointList.add(PolylineWayPoint(location: multiStopList[i].editingController.text));
      }
      List<LatLng> polylineCoordinates = [];

      PolylineRequest requestData = PolylineRequest(
        wayPoints: wayPointList,
        optimizeWaypoints: true,
        mode: TravelMode.driving,
        origin: PointLatLng(departureLatLong.value.latitude, departureLatLong.value.longitude),
        destination: PointLatLng(destinationLatLong.value.latitude, destinationLatLong.value.longitude),
      );
      PolylineResult result = await PolylinePoints().getRouteBetweenCoordinates(
        googleApiKey: Constant.kGoogleApiKey.toString(),
        request: requestData,
      );

      if (result.points.isNotEmpty) {
        for (var point in result.points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
      }
      addPolyLine(polylineCoordinates);
    }
  }

  RxMap<PolylineId, Polyline> polyLines = <PolylineId, Polyline>{}.obs;
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
    updateCameraLocation(polylineCoordinates.first, polylineCoordinates.last, mapController);
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

    CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 90);

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

  setTabr() {
    if (Constant.parcelActive.toString() == "yes") {
      tabController = TabController(length: 3, vsync: this);
    } else {
      tabController = TabController(length: 2, vsync: this);
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

  BitmapDescriptor? departureIcon;
  BitmapDescriptor? destinationIcon;
  BitmapDescriptor? taxiIcon;
  BitmapDescriptor? stopIcon;

  final Map<String, Marker> markers = {};

  Future<void> setIcons() async {
    try {
      const ImageConfiguration imageConfig = ImageConfiguration(size: Size(48, 48));
      departureIcon = await BitmapDescriptor.fromAssetImage(imageConfig, "assets/icons/pickup.png");
      destinationIcon = await BitmapDescriptor.fromAssetImage(imageConfig, "assets/icons/dropoff.png");
      taxiIcon = await BitmapDescriptor.fromAssetImage(imageConfig, "assets/icons/ic_taxi.png");
      stopIcon = await BitmapDescriptor.fromAssetImage(imageConfig, "assets/icons/location.png");
    } catch (e) {
      print('Error loading icons: $e');
    }
  }

  addStops() async {
    ShowToastDialog.showLoader("Please wait");
    multiStopList.add(AddStopModel(editingController: TextEditingController(), latitude: "", longitude: ""));
    multiStopListNew = List<AddStopModel>.generate(
      multiStopList.length,
      (int index) => AddStopModel(editingController: multiStopList[index].editingController, latitude: multiStopList[index].latitude, longitude: multiStopList[index].longitude),
    );
    ShowToastDialog.closeLoader();
    update();
  }

  removeStops(int index) {
    ShowToastDialog.showLoader("Please wait");
    multiStopList.removeAt(index);
    multiStopListNew = List<AddStopModel>.generate(
      multiStopList.length,
      (int index) => AddStopModel(editingController: multiStopList[index].editingController, latitude: multiStopList[index].latitude, longitude: multiStopList[index].longitude),
    );
    ShowToastDialog.closeLoader();
    update();
  }

  clearData() {
    selectPaymentMode.value = "Payment Method";
    tripOptionCategory = "General".obs;
    paymentMethodType = "Select Method".obs;
    paymentMethodId = "".obs;
    distance = 0.0.obs;
    duration = "".obs;
    multiStopList.clear();
    multiStopListNew.clear();
  }

  RxList<DriverLocationUpdate> driverLocationList = <DriverLocationUpdate>[].obs;

  Future getTaxiData() async {
    Constant.driverLocationUpdateCollection.where("active", isEqualTo: true).snapshots().listen((event) {
      for (var element in event.docs) {
        DriverLocationUpdate driverLocationUpdate = DriverLocationUpdate.fromJson(element.data() as Map<String, dynamic>);
        driverLocationList.add(driverLocationUpdate);
        if (Constant.homeScreenType != 'OlaHome') {
          for (var element in driverLocationList) {
            markers[element.driverId.toString()] = Marker(
              markerId: MarkerId(element.driverId.toString()),
              rotation: double.parse(element.rotation.toString()),
              // infoWindow: InfoWindow(title: element.prenom.toString(), snippet: "${element.brand},${element.model},${element.numberplate}"),
              position: LatLng(double.parse(element.driverLatitude.toString().isNotEmpty ? element.driverLatitude.toString() : "0.0"),
                  double.parse(element.driverLongitude.toString().isNotEmpty ? element.driverLongitude.toString() : "0.0")),
              icon: taxiIcon!,
            );
          }
        }
      }
    });
  }

  Future<dynamic> getBannerData() async {
    try {
      http.Response response = await http.get(Uri.parse(API.bannerHome), headers: API.header);
      var decodedResponse = jsonDecode(response.body);
      showLog("API :: URL :: ${API.bannerHome}");
      showLog("API :: Request Header :: ${API.header.toString()} ");
      showLog("API :: responseStatus :: ${response.statusCode} ");
      showLog("API :: responseBody :: ${response.body} ");
      if (decodedResponse['success'] == 'success') {
        bannerModel.value = BannerModel.fromJson(decodedResponse as Map<String, dynamic>);
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
    } on Error catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    ShowToastDialog.closeLoader();
    return null;
  }

  Future<dynamic> getDurationDistance(LatLng departureLatLong, LatLng destinationLatLong) async {
    try {
      ShowToastDialog.showLoader("Please wait");
      double originLat, originLong, destLat, destLong;
      originLat = departureLatLong.latitude;
      originLong = departureLatLong.longitude;
      destLat = destinationLatLong.latitude;
      destLong = destinationLatLong.longitude;

      String url = 'https://maps.googleapis.com/maps/api/distancematrix/json';
      http.Response response = await http.get(Uri.parse('$url?units=metric&origins=$originLat,'
          '$originLong&destinations=$destLat,$destLong&key=${Constant.kGoogleApiKey}'));

      showLog("API :: URL :: '${'$url?units=metric&origins=$originLat,'
          '$originLong&destinations=$destLat,$destLong&key=${Constant.kGoogleApiKey}'}");
      showLog("API :: Request Header :: ${API.header.toString()} ");
      showLog("API :: responseStatus :: ${response.statusCode} ");
      showLog("API :: responseBody :: ${response.body} ");

      var decodedResponse = jsonDecode(response.body);

      if (decodedResponse['status'] == 'OK' && decodedResponse['rows'].first['elements'].first['status'] == 'OK') {
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
    } on Error catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
  }

  Future<dynamic> getUserPendingPayment() async {
    try {
      Map<String, dynamic> bodyParams = {'user_id': Preferences.getInt(Preferences.userId)};
      final response = await http.post(Uri.parse(API.userPendingPayment), headers: API.header, body: jsonEncode(bodyParams));
      showLog("API :: URL :: '${API.userPendingPayment}");
      showLog("API :: Body :: '${jsonEncode(bodyParams)}");
      showLog("API :: Request Header :: ${API.header.toString()} ");
      showLog("API :: responseStatus :: ${response.statusCode} ");
      showLog("API :: responseBody :: ${response.body} ");
      Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == 200) {
        return responseBody;
      } else {
        ShowToastDialog.showToast('Something want wrong. Please try again later');
        throw Exception('Failed to load album');
      }
    } on TimeoutException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }

  Future<VehicleCategoryModel?> getVehicleCategory() async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.get(Uri.parse(API.getVehicleCategory), headers: API.header);
      showLog("API :: URL :: '${API.getVehicleCategory}");
      showLog("API :: Request Header :: ${API.header.toString()} ");
      showLog("API :: responseStatus :: ${response.statusCode} ");
      showLog("API :: responseBody :: ${response.body} ");
      Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == 200) {
        update();
        ShowToastDialog.closeLoader();
        return VehicleCategoryModel.fromJson(responseBody);
      } else {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast('Something want wrong. Please try again later');
        throw Exception('Failed to load album');
      }
    } on TimeoutException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }

  Future<DriverModel?> getDriverDetails(String typeVehicle, String lat1, String lng1) async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.get(Uri.parse("${API.driverDetails}?type_vehicle=$typeVehicle&lat1=$lat1&lng1=$lng1"), headers: API.header);
      showLog("API :: URL :: ${API.driverDetails}?type_vehicle=$typeVehicle&lat1=$lat1&lng1=$lng1");
      showLog("API :: Request Header :: ${API.header.toString()} ");
      showLog("API :: responseStatus :: ${response.statusCode} ");
      showLog("API :: responseBody :: ${response.body} ");

      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200) {
        ShowToastDialog.closeLoader();
        return DriverModel.fromJson(responseBody);
      } else {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast('Something want wrong. Please try again later');
        throw Exception('Failed to load album');
      }
    } on TimeoutException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }

  Future<dynamic> setFavouriteRide(Map<String, String> bodyParams) async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.post(Uri.parse(API.setFavouriteRide), headers: API.header, body: jsonEncode(bodyParams));
      Map<String, dynamic> responseBody = json.decode(response.body);
      showLog("API :: URL :: ${API.setFavouriteRide}");
      showLog("API :: Request Body :: ${jsonEncode(bodyParams)} ");
      showLog("API :: Request Header :: ${API.header.toString()} ");
      showLog("API :: responseStatus :: ${response.statusCode} ");
      showLog("API :: responseBody :: ${response.body} ");

      if (response.statusCode == 200) {
        ShowToastDialog.closeLoader();
        return responseBody;
      } else {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast('Something want wrong. Please try again later');
        throw Exception('Failed to load album');
      }
    } on TimeoutException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
  }

  Future<dynamic> bookRide(Map<String, dynamic> bodyParams) async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.post(Uri.parse(API.bookRides), headers: API.header, body: jsonEncode(bodyParams));
      showLog("API :: URL :: ${API.bookRides}");
      showLog("API :: Request Body :: ${jsonEncode(bodyParams)} ");
      showLog("API :: Request Header :: ${API.header.toString()} ");
      showLog("API :: responseStatus :: ${response.statusCode} ");
      showLog("API :: responseBody :: ${response.body} ");
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200) {
        ShowToastDialog.closeLoader();
        if (responseBody['success'].toString().toLowerCase() == 'failed') {
          ShowToastDialog.showToast(responseBody['error'].toString());
        } else {
          return responseBody;
        }
      } else {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast('Something want wrong. Please try again later');
        throw Exception('Failed to load album');
      }
    } on TimeoutException catch (e) {
      ShowToastDialog.closeLoader();

      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      ShowToastDialog.closeLoader();

      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      ShowToastDialog.closeLoader();

      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      ShowToastDialog.closeLoader();

      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }

  double calculateTripPrice({required double distance, required double minimumDeliveryChargesWithin, required double minimumDeliveryCharges, required double deliveryCharges}) {
    double cout = 0.0;

    if (distance > minimumDeliveryChargesWithin) {
      cout = (distance * deliveryCharges).toDouble();
    } else {
      cout = minimumDeliveryCharges;
    }
    return cout;
  }

  Rx<BannerModel> bannerModel = BannerModel().obs;
}

class AddChildModel {
  TextEditingController editingController = TextEditingController();

  AddChildModel({required this.editingController});
}

class AddStopModel {
  String latitude = "";
  String longitude = "";
  TextEditingController editingController = TextEditingController();

  AddStopModel({
    required this.editingController,
    required this.latitude,
    required this.longitude,
  });
}
