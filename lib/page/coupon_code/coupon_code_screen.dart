// ignore_for_file: prefer_const_constructors

import 'package:cabme/constant/constant.dart';
import 'package:cabme/controller/coupon_code_controller.dart';
import 'package:cabme/model/CoupanCodeModel.dart';
import 'package:cabme/themes/constant_colors.dart';
import 'package:clipboard/clipboard.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CouponCodeScreen extends StatelessWidget {
  const CouponCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<CouponCodeController>(
        init: CouponCodeController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: ConstantColors.background,
            body: RefreshIndicator(
              onRefresh: () => controller.getCoupanCodeData(),
              child: controller.isLoading.value
                  ? SizedBox()
                  : controller.coupanCodeList.isEmpty
                      ? Center(
                          child: Constant.emptyView(context, "No coupons available", false),
                        )
                      : ListView.builder(
                          itemCount: controller.coupanCodeList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return buildPromoCodeItem(context, controller.coupanCodeList[index]);
                          }),
            ),
          );
        });
  }

  Widget buildPromoCodeItem(BuildContext context, CoupanCodeData data) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: EdgeInsets.only(top: 10),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/promo_bg.png'),
          fit: BoxFit.fitWidth,
        ),
      ),
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 35),
              child: Container(
                decoration: const BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.all(Radius.circular(30))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'assets/icons/promocode.png',
                    width: 40,
                    height: 40,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 35),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.discription.toString(),
                      style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            FlutterClipboard.copy(data.code.toString()).then((value) {
                              final SnackBar snackBar = SnackBar(
                                content: Text(
                                  "Coupon Code Copied".tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.black38,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              // return Navigator.pop(context);
                            });
                          },
                          child: Container(
                            color: Colors.black.withOpacity(0.05),
                            child: DottedBorder(
                              color: Colors.grey,
                              strokeWidth: 1,
                              dashPattern: const [3, 3],
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                child: Text(
                                  data.code.toString(),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: Text(
                            "Valid till".tr + data.expireAt.toString(),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
