import 'dart:developer';

import 'package:cabme/constant/constant.dart';
import 'package:cabme/page/search_location_screen.dart';
import 'package:cabme/themes/constant_colors.dart';
import 'package:cabme/themes/text_field_them.dart';
import 'package:cabme/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart' as locationData;

class LocationPicker extends StatefulWidget {
  const LocationPicker({super.key});

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  GeoPoint? selectedLocation;
  late MapController mapController;
  Map<String, dynamic>? placeData;
  TextEditingController textController = TextEditingController();
  final List<GeoPoint> _markers = [];

  @override
  void initState() {
    super.initState();
    mapController = MapController(
      initMapWithUserPosition:
          const UserTrackingOption(enableTracking: true, unFollowUser: true),
    );
    _setUserLocation();
    _listerTapPosition();
  }

  _listerTapPosition() async {
    mapController.listenerMapSingleTapping.addListener(() async {
      if (mapController.listenerMapSingleTapping.value != null) {
        GeoPoint position = mapController.listenerMapSingleTapping.value!;
        addMarker(position);
      }
    });
  }

  addMarker(GeoPoint position) async {
    for (var marker in _markers) {
      await mapController.removeMarker(marker);
    }
    _markers.clear();

    mapController.moveTo(position, animate: true);
    var searchAddress = await Constant().getOSMAddressFromLatLongLatlng(
        lat: position.latitude, lng: position.longitude);
    log("value :: city :: ${searchAddress['address']['city']} ::Village :: ${searchAddress['address']['village']} :: state_district :: ${searchAddress['address']['state_district']} :: ${searchAddress['address']['suburb']} :: ${searchAddress.toString()}");
    placeData = {
      'address': searchAddress['display_name'] ?? '',
      'lat': position.latitude,
      'lng': position.longitude,
      'city': searchAddress['address']['city'] ??
          searchAddress['address']['village'] ??
          searchAddress['address']['state_district'] ??
          searchAddress['address']['suburb'] ??
          ''
    };
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await mapController.addMarker(position,
          markerIcon: MarkerIcon(
            iconWidget: Image.asset("assets/icons/location.png",
                color: Colors.red, width: 30, height: 30),
          ));
      _markers.add(position);
    });
    setState(() {});
  }

  Future<void> _setUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: locationData.LocationAccuracy.high);
      setState(() async {
        selectedLocation = GeoPoint(
          latitude: position.latitude,
          longitude: position.longitude,
        );
        await addMarker(selectedLocation!);
        mapController.moveTo(selectedLocation!, animate: true);
        var searchAddress = await Constant().getOSMAddressFromLatLongLatlng(
            lat: position.latitude, lng: position.longitude);
        log("value :: city :: ${searchAddress['address']['city']} ::Village :: ${searchAddress['address']['village']} :: state_district :: ${searchAddress['address']['state_district']} :: ${searchAddress['address']['suburb']} :: ${searchAddress.toString()}");
        placeData = {
          'address': searchAddress['display_name'] ?? '',
          'lat': position.latitude,
          'lng': position.longitude,
          'city': searchAddress['address']['city'] ??
              searchAddress['address']['village'] ??
              searchAddress['address']['state_district'] ??
              searchAddress['address']['suburb'] ??
              ''
        };
      });
    } catch (e) {
      print("Error getting location: $e");
      // Handle error (e.g., show a snackbar to the user)
    }
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      body: Stack(
        children: [
          OSMFlutter(
            controller: mapController,
            mapIsLoading: Center(child: Constant.loader(context)),
            osmOption: OSMOption(
              userLocationMarker: UserLocationMaker(
                  personMarker: MarkerIcon(
                      iconWidget: Image.asset("assets/icons/pickup.png")),
                  directionArrowMarker: MarkerIcon(
                      iconWidget: Image.asset("assets/icons/pickup.png"))),
              isPicker: true,
              zoomOption: const ZoomOption(initZoom: 14),
            ),
          ),
          if (placeData?['address'] != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(bottom: 100, left: 40, right: 40),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: themeChange.getThem()
                        ? AppThemeData.surface50Dark
                        : AppThemeData.surface50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: themeChange.getThem()
                          ? AppThemeData.grey200Dark
                          : AppThemeData.grey200,
                    )),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        placeData?['address'] ?? '',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: AppThemeData.medium,
                          color: themeChange.getThem()
                              ? AppThemeData.grey900Dark
                              : AppThemeData.grey900,
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          Get.back(result: placeData);
                        },
                        icon: const Icon(
                          Icons.check_circle,
                          size: 40,
                        ))
                  ],
                ),
              ),
            ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                  left:
                      Directionality.of(context) == TextDirection.rtl ? 16 : 0,
                  right: 16,
                  top: 20),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Transform(
                      alignment: Alignment.center,
                      transform: Directionality.of(context) == TextDirection.rtl
                          ? Matrix4.rotationY(3.14159)
                          : Matrix4.identity(),
                      child: SvgPicture.asset(
                        'assets/icons/ic_left.svg',
                        width: 35,
                        height: 35,
                        colorFilter: ColorFilter.mode(
                          AppThemeData.grey500,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        Get.to(AddressSearchScreen())?.then((value) {
                          if (value != null) {
                            SearchInfo place = value;
                            textController = TextEditingController(
                                text: place.address.toString());
                            addMarker(place.point!);
                          }
                        });
                      },
                      child: TextFieldWidgetBorder(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        borderColor: AppThemeData.grey800,
                        radius: BorderRadius.circular(40),
                        enabled: false,
                        isReadOnly: true,
                        hintText: "Search Address".tr,
                        controller: textController,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _setUserLocation,
        child: const Icon(Icons.my_location),
      ),
    );
  }

  Widget buildTextField(
      {required title,
      required TextEditingController textController,
      required bool isDarkMode}) {
    return Padding(
        padding: const EdgeInsets.only(left: 4.0),
        child: TextFieldWidget(
          hintText: title,
          controller: textController,
          prefix: IconButton(
            icon: Icon(Icons.location_on,
                color: isDarkMode
                    ? AppThemeData.grey500Dark
                    : AppThemeData.grey300Dark),
            onPressed: () {},
          ),
        ));
  }
}
