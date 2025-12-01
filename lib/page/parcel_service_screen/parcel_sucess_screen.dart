import 'package:cabme/page/parcel_service_screen/all_parcel_screen.dart';
import 'package:cabme/themes/button_them.dart';
import 'package:cabme/themes/constant_colors.dart';
import 'package:cabme/themes/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ParcelSuccessScreen extends StatelessWidget {
  const ParcelSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppThemeData.pink2,
          leading: IconButton(
              onPressed: () {
                Get.offAll(const AllParcelScreen());
              },
              icon: Transform(
                alignment: Alignment.center,
                transform: Directionality.of(context) == TextDirection.rtl ? Matrix4.rotationY(3.14159) : Matrix4.identity(),
                child: SvgPicture.asset(
                  'assets/icons/ic_left.svg',
                  width: 30,
                  height: 30,
                  colorFilter: ColorFilter.mode(
                    AppThemeData.grey900,
                    BlendMode.srcIn,
                  ),
                ),
              ))),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppThemeData.pink2,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: Responsive.height(15, context)),
              Image.asset(
                'assets/images/parcel_box.gif',
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 30),
              Text(
                'Parcel Request Created Successfully!'.tr,
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
                  'Your parcel request has been confirmed. A driver will be assigned shortly, and you’ll be able to track the delivery in real-time!'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppThemeData.grey900,
                    fontSize: 14,
                    fontFamily: AppThemeData.regular,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ButtonThem.buildButton(
                btnWidthRatio: 0.5,
                context,
                title: "Track Status".tr,
                btnColor: AppThemeData.warning200,
                txtColor: AppThemeData.grey50,
                onPress: () async {
                  Get.offAll(const AllParcelScreen());
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
