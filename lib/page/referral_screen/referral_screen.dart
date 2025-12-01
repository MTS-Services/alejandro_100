import 'package:cabme/constant/constant.dart';
import 'package:cabme/constant/show_toast_dialog.dart';
import 'package:cabme/controller/referral_controller.dart';
import 'package:cabme/themes/appbar_cust.dart';
import 'package:cabme/themes/button_them.dart';
import 'package:cabme/themes/constant_colors.dart';
import 'package:cabme/themes/responsive.dart';
import 'package:clipboard/clipboard.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class ReferralScreen extends StatefulWidget {
  const ReferralScreen({super.key});

  @override
  State<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF35044B),
      appBar: CustomAppbar(
        textColor: AppThemeData.grey900Dark,
        title: 'Refer and Earn'.tr,
        bgColor: Color(0XFF110219),
      ),
      body: GetX<ReferralController>(
          init: ReferralController(),
          builder: (referralController) {
            return referralController.isLoading.value == true
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      Container(
                          color: const Color(0XFF100018),
                          child: SafeArea(
                              child: Column(children: [
                            const SizedBox(height: 50),
                            Image.asset(
                              'assets/icons/refer.gif',
                              width: Responsive.width(100, context),
                              height: 260,
                              fit: BoxFit.cover,
                            )
                          ]))),
                      Expanded(
                        child: Container(
                          color: AppThemeData.referBgtwo,
                          child: Column(
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  Text(
                                    "Refer & Earn".tr,
                                    style: TextStyle(color: AppThemeData.surface50, fontFamily: AppThemeData.semiBold, fontSize: 24),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Earn rewards by inviting your friends to CabME".tr,
                                    style: TextStyle(color: AppThemeData.grey300Dark, fontFamily: AppThemeData.regular, fontSize: 16),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    "${"Earn".tr}${Constant().amountShow(amount: referralController.referralAmount.toString())} ${"for each friend who signs up and completes their first ride.".tr}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppThemeData.primary200,
                                      fontFamily: AppThemeData.light,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 38,
                                  ),
                                  Text(
                                    "Your Referral Code:".tr,
                                    style: TextStyle(color: AppThemeData.grey300Dark, fontFamily: AppThemeData.regular, fontSize: 16),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    width: Responsive.width(40, context),
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
                                      AppThemeData.referBgtwo,
                                      AppThemeData.referBgone,
                                    ])),
                                    child: GestureDetector(
                                      onTap: () {
                                        FlutterClipboard.copy(
                                          referralController.referralCode.toString(),
                                        ).then((value) {
                                          SnackBar snackBar = SnackBar(
                                            content: Text(
                                              "Coupon code copied".tr,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(color: AppThemeData.grey900Dark),
                                            ),
                                            backgroundColor: AppThemeData.success300,
                                          );
                                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                        });
                                      },
                                      child: DottedBorder(
                                        borderType: BorderType.RRect,
                                        radius: const Radius.circular(2),
                                        padding: const EdgeInsets.all(15),
                                        color: AppThemeData.primary200,
                                        strokeWidth: 2,
                                        dashPattern: const [5],
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                referralController.referralCode.toString(),
                                                textAlign: TextAlign.center,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontFamily: AppThemeData.semiBold,
                                                  color: AppThemeData.warning200,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              const SizedBox(width: 5),
                                              SvgPicture.asset(
                                                'assets/icons/ic_past.svg',
                                                width: 22,
                                                height: 22,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Expanded(
                                  child: SizedBox(
                                height: 5,
                              )),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: ButtonThem.buildButton(
                                  context,
                                  title: "Refer a Friend".tr,
                                  txtColor: AppThemeData.grey900Dark,
                                  onPress: () async {
                                    await ShowToastDialog.showLoader("Please wait");
                                    share(referralController);
                                  },
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
          }),
    );
  }

  Future<void> share(ReferralController referralController) async {
    ShowToastDialog.closeLoader();
    await Share.share(
      "${"Hey there, thanks for choosing Cabme. Hope you love our product. If you do, share it with your friends using code".tr} ${referralController.referralCode.toString()} ${"and get".tr} ${Constant().amountShow(amount: referralController.referralAmount.toString())} ${"when ride completed".tr}",
    );
    // await FlutterShare.share(
    //   title: 'Cabme',
    //   text:
    //       'Hey there, thanks for choosing Cabme. Hope you love our product. If you do, share it with your friends using code ${referralController.referralCode.toString()} and get ${Constant().amountShow(amount: referralController.referralAmount.toString())} when ride completed',
    // );
  }
}
