import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:http/http.dart' as http;

class SearchAddressController extends GetxController {
  //for Choose your Rider

  Rx<TextEditingController> searchTxtController = TextEditingController().obs;
  RxList<SearchInfo> suggestionsList = <SearchInfo>[].obs;
  final debouncer = Debouncer(delay: const Duration(milliseconds: 500));
  RxBool isSearch = false.obs;

  // fetchAddress(text) async {
  //   isSearch.value = true;
  //   log(":: fetchAddress :: $text");
  //   try {
  //     suggestionsList.value = await addressSuggestion(text);
  //     isSearch.value = false;
  //   } catch (e) {
  //     log(e.toString());
  //     isSearch.value = false;
  //   }
  // }

  fetchAddress(text) async {
    log(":: fetchAddress :: $text");

    // Skip if text is empty or too short
    if (text == null ||
        text.toString().trim().isEmpty ||
        text.toString().trim().length < 3) {
      suggestionsList.clear();
      return;
    }

    try {
      // Use custom implementation due to plugin URL issue
      suggestionsList.value =
          await _customAddressSearch(text.toString().trim());
    } catch (e) {
      log("Address search error: ${e.toString()}");
      suggestionsList.clear();
    }
  }

  // Custom address search function that fixes the URL issue
  Future<List<SearchInfo>> _customAddressSearch(String query) async {
    try {
      // Properly format the URL with https://
      final String encodedQuery = Uri.encodeComponent(query);
      final String url =
          'https://photon.komoot.io/api/?q=$encodedQuery&limit=5&lang=en';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'User-Agent': 'FlexDriverApp/1.0',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<SearchInfo> results = [];

        if (data['features'] != null) {
          for (var feature in data['features']) {
            try {
              // Parse coordinates
              final coords = feature['geometry']['coordinates'];
              final double lon = coords[0].toDouble();
              final double lat = coords[1].toDouble();

              // Parse properties
              final props = feature['properties'];

              // Create address object
              final address = Address(
                name: props['name']?.toString() ??
                    props['display_name']?.toString(),
                city: props['city']?.toString(),
                country: props['country']?.toString(),
                state: props['state']?.toString(),
                postcode: props['postcode']?.toString(),
              );

              final searchInfo = SearchInfo(
                point: GeoPoint(latitude: lat, longitude: lon),
                address: address,
              );

              results.add(searchInfo);
            } catch (parseError) {
              log("Error parsing search result: $parseError");
              continue;
            }
          }
        }

        return results;
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      log("Custom address search error: $e");
      rethrow;
    }
  }
}
