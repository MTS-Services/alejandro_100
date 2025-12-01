import 'package:cabme/page/new_ride_screens/new_ride_screen.dart';
import 'package:cabme/themes/button_them.dart';
import 'package:cabme/themes/constant_colors.dart';
import 'package:cabme/themes/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RideBookingSuccessScreen extends StatelessWidget {
  const RideBookingSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppThemeData.pink,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: Responsive.height(30, context)),
            Image.asset(
              'assets/images/ic_car.gif',
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
            Text(
              'Booking Confirmed!'.tr,
              style: TextStyle(
                color: AppThemeData.grey900,
                fontSize: 22,
                fontFamily: AppThemeData.semiBold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Your ride has been successfully booked. Sit back and relax as your driver is on the way. Track your ride in real-time.'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppThemeData.grey900,
                  fontSize: 14,
                  fontFamily: AppThemeData.regular,
                ),
              ),
            ),
            const SizedBox(height: 40),
            ButtonThem.buildButton(
              btnWidthRatio: 0.5,
              context,
              title: "Track Ride".tr,
              btnColor: AppThemeData.secondary200,
              txtColor: AppThemeData.grey900,
              onPress: () async {
                Get.off(const NewRideScreen());
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
