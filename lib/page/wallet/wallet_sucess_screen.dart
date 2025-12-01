import 'package:cabme/page/dash_board.dart';
import 'package:cabme/themes/button_them.dart';
import 'package:cabme/themes/constant_colors.dart';
import 'package:cabme/themes/responsive.dart';
import 'package:cabme/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class WalletSuccessScreen extends StatelessWidget {
  const WalletSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppThemeData.blue200,
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Directionality.of(context) == TextDirection.rtl ? Matrix4.rotationY(3.14159) : Matrix4.identity(),
                      child: SvgPicture.asset(
                        'assets/icons/ic_left.svg',
                        colorFilter: ColorFilter.mode(
                          AppThemeData.grey900,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: Responsive.height(20, context)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(children: [
                  Image.asset(
                    'assets/icons/ic_done.gif',
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  Text(
                    'Top-Up Successful!',
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
                      'Your wallet has been topped up successfully. You’re all set to book your next ride or service with us.'.tr,
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
                    btnWidthRatio: 0.4,
                    context,
                    title: "Book Now".tr,
                    btnColor: AppThemeData.success300,
                    txtColor: themeChange.getThem() ? AppThemeData.grey900Dark : AppThemeData.grey900,
                    onPress: () async {
                      Get.to(DashBoard());
                    },
                  ),
                  const SizedBox(height: 20),
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
