import 'package:cabme/constant/show_toast_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

class LocationPermissionDisclosureDialog extends StatelessWidget {
  const LocationPermissionDisclosureDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Location Access Disclosure'),
      content: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'We need access to your location to assign for booking feature.',
            ),
            SizedBox(height: 10),
            Text(
              'This information will only be used for booking purpose and will not be shared with any third parties.',
            ),
          ],
        ),
      ),
      actions: <Widget>[
        MaterialButton(
          onPressed: () {
            _requestLocationPermission();
          },
          child: const Text(
            'Accept',
            style: TextStyle(color: Colors.green),
          ),
        ),
        MaterialButton(
          onPressed: () {
            SystemNavigator.pop();
          },
          child: const Text('Decline', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }

  // Method to request location permission using permission_handler package
  void _requestLocationPermission() async {
    PermissionStatus location = await Location().requestPermission();
    if (location == PermissionStatus.granted) {
      Get.back();
    } else {
      ShowToastDialog.showToast("Permission Denied");
    }
  }
}
