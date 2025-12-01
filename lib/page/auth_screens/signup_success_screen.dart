import 'package:cabme/controller/sign_success_controller.dart';
import 'package:cabme/themes/constant_colors.dart';
import 'package:cabme/themes/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpSuccessScreen extends StatelessWidget {
  const SignUpSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignSuccessController>(
        init: SignSuccessController(),
        builder: (controller) {
          return Scaffold(
            body: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppThemeData.yellow,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: Responsive.height(30, context)),
                  Image.asset(
                    'assets/images/sucess_account.png',
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'Account Created Successfully!'.tr,
                    style: TextStyle(
                      color: AppThemeData.grey50,
                      fontSize: 22,
                      fontFamily: AppThemeData.semiBold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Welcome to CabME! Your account has been successfully created. Start booking rides now.'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppThemeData.grey50,
                      fontSize: 14,
                      fontFamily: AppThemeData.regular,
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          );
        });
  }
}
