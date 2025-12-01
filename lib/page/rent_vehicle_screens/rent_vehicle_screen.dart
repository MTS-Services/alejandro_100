import 'dart:developer';

import 'package:cabme/constant/constant.dart';
import 'package:cabme/constant/show_toast_dialog.dart';
import 'package:cabme/controller/rent_vehicle_controller.dart';
import 'package:cabme/model/rent_vehicle_model.dart';
import 'package:cabme/themes/appbar_cust.dart';
import 'package:cabme/themes/button_them.dart';
import 'package:cabme/themes/constant_colors.dart';
import 'package:cabme/themes/responsive.dart';
import 'package:cabme/themes/text_field_them.dart';
import 'package:cabme/utils/Preferences.dart';
import 'package:cabme/utils/dark_theme_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RentVehicleScreen extends StatelessWidget {
  RentVehicleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<RentVehicleController>(
      init: RentVehicleController(),
      builder: (controller) {
        return Scaffold(
          appBar: CustomAppbar(
            bgColor: AppThemeData.primary200,
            title: "Rent Vehicle".tr,
          ),
          resizeToAvoidBottomInset: true,
          body: Stack(
            alignment: AlignmentDirectional.topStart,
            children: [
              Container(
                color: AppThemeData.primary200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(flex: 1, child: SizedBox()),
                    Expanded(
                      flex: 9,
                      child: Container(
                        color: themeChange.getThem() ? AppThemeData.surface50Dark : AppThemeData.surface50,
                      ),
                    ),
                  ],
                ),
              ),
              SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      controller.isLoading.value
                          ? SizedBox()
                          : controller.rentVehicleList.isEmpty
                              ? Constant.emptyView(context, "Vehicle not found", false)
                              : ListView.builder(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  primary: false,
                                  itemCount: controller.rentVehicleList.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return buildVehicleCard(context, controller.rentVehicleList[index], controller);
                                  })
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildVehicleCard(BuildContext context, RentVehicleData data, RentVehicleController controller) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
          color: themeChange.getThem() ? AppThemeData.surface50Dark : AppThemeData.surface50,
          border: Border.all(
            color: themeChange.getThem() ? AppThemeData.grey200Dark : AppThemeData.grey200,
            width: 1,
          )),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(14),
                child: CachedNetworkImage(
                  width: Responsive.width(35, context),
                  height: 110,
                  imageUrl: data.image.toString(),
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Constant.loader(context),
                  errorWidget: (context, url, error) => Image.asset(
                    "assets/images/appIcon.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            data.libelle.toString(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontFamily: AppThemeData.medium,
                              fontSize: 18,
                              color: themeChange.getThem() ? AppThemeData.grey900Dark : AppThemeData.grey900,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                Constant().amountShow(amount: data.prix.toString()),
                                style: TextStyle(
                                  fontFamily: AppThemeData.regular,
                                  fontSize: 14,
                                  color: themeChange.getThem() ? AppThemeData.grey900Dark : AppThemeData.grey900,
                                ),
                              ),
                              Text(
                                '/',
                                style: TextStyle(
                                  fontFamily: AppThemeData.regular,
                                  fontSize: 14,
                                  color: themeChange.getThem() ? AppThemeData.grey900Dark : AppThemeData.grey900,
                                ),
                              ),
                              Text("day".tr,
                                  //DateFormat('\$ KK:mm a, dd MMM yyyy').format(date),
                                  style: TextStyle(
                                    fontFamily: AppThemeData.regular,
                                    fontSize: 14,
                                    color: themeChange.getThem() ? AppThemeData.grey900Dark : AppThemeData.grey900,
                                  )),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/ic_group_outline.svg',
                              colorFilter: ColorFilter.mode(
                                AppThemeData.primary200,
                                BlendMode.srcIn,
                              ),
                            ),
                            Text(' ${data.noOfPassenger.toString().padLeft(2, '0')}',
                                //DateFormat('\$ KK:mm a, dd MMM yyyy').format(date),
                                style: TextStyle(
                                  fontFamily: AppThemeData.regular,
                                  fontSize: 18,
                                  color: AppThemeData.primary200,
                                )),
                          ],
                        ),
                      ),
                      ButtonThem.buildButton(context, btnHeight: 45, btnWidthRatio: 0.26, txtSize: 14, title: 'Book Now'.tr, onPress: () {
                        controller.phoneController.value.text = '';
                        buildShowBottomSheet(context, data, controller, themeChange.getThem());
                      })
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  final GlobalKey<FormState> _contactKey = GlobalKey();

  buildShowBottomSheet(BuildContext context, RentVehicleData data, RentVehicleController controller, bool isDarkMode) {
    return showModalBottomSheet(
        barrierColor: isDarkMode ? AppThemeData.surface50.withAlpha(50) : AppThemeData.grey200Dark.withAlpha(80),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15))),
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        backgroundColor: isDarkMode ? AppThemeData.surface50Dark : AppThemeData.surface50,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              child: Obx(
                () => Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Directionality.of(context) == TextDirection.RTL ? Matrix4.rotationY(3.14159) : Matrix4.identity(),
                            child: SvgPicture.asset(
                              'assets/icons/ic_left.svg',
                              colorFilter: ColorFilter.mode(
                                isDarkMode ? AppThemeData.grey50Dark : AppThemeData.grey50,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              "Reservation Information".tr,
                              style: TextStyle(
                                fontFamily: AppThemeData.semiBold,
                                fontSize: 18,
                                color: isDarkMode ? AppThemeData.grey900Dark : AppThemeData.grey900,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border(
                          left: BorderSide(
                            color: isDarkMode ? AppThemeData.grey300Dark : AppThemeData.grey300,
                            width: 0.8,
                          ),
                          right: BorderSide(
                            color: isDarkMode ? AppThemeData.grey300Dark : AppThemeData.grey300,
                            width: 0.8,
                          ),
                          top: BorderSide(
                            color: isDarkMode ? AppThemeData.grey300Dark : AppThemeData.grey300,
                            width: 0.8,
                          ),
                        )),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Number of days".tr,
                                    style: TextStyle(
                                      fontFamily: AppThemeData.regular,
                                      fontSize: 16,
                                      color: isDarkMode ? AppThemeData.grey900Dark : AppThemeData.grey900,
                                    ),
                                  ),
                                  Text(
                                    "${daysBetween(controller.startDate.value, controller.endDate.value)}".padLeft(2, '0'),
                                    style: TextStyle(
                                      fontFamily: AppThemeData.medium,
                                      fontSize: 16,
                                      color: isDarkMode ? AppThemeData.grey900Dark : AppThemeData.grey900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              color: isDarkMode ? AppThemeData.grey300Dark : AppThemeData.grey300,
                              height: 0.8,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Start date".tr,
                                    style: TextStyle(
                                      fontFamily: AppThemeData.regular,
                                      fontSize: 16,
                                      color: isDarkMode ? AppThemeData.grey900Dark : AppThemeData.grey900,
                                    ),
                                  ),
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    onTap: () async {
                                      await selectRenralDate(context, initialDate: DateTime.now(), startDate: DateTime.now(), endDate: DateTime(2040)).then((value) {
                                        controller.startDate.value = DateTime.parse(DateFormat('yyyy-MM-dd 00:00:00').format(value!));
                                      });
                                    },
                                    child: Text(
                                      DateFormat('yyyy-MM-dd').format(controller.startDate.value),
                                      style: TextStyle(
                                        fontFamily: AppThemeData.medium,
                                        fontSize: 16,
                                        color: isDarkMode ? AppThemeData.grey900Dark : AppThemeData.grey900,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              color: isDarkMode ? AppThemeData.grey300Dark : AppThemeData.grey300,
                              height: 0.8,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "End date".tr,
                                    style: TextStyle(
                                      fontFamily: AppThemeData.regular,
                                      fontSize: 16,
                                      color: isDarkMode ? AppThemeData.grey900Dark : AppThemeData.grey900,
                                    ),
                                  ),
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    onTap: () async {
                                      await selectRenralDate(context, initialDate: controller.startDate.value, startDate: controller.startDate.value, endDate: DateTime(2040))
                                          .then((value) {
                                        controller.endDate.value = DateTime.parse(DateFormat('yyyy-MM-dd 00:00:00').format(value!));
                                      });
                                    },
                                    child: Text(
                                      DateFormat('yyyy-MM-dd').format(controller.endDate.value),
                                      style: TextStyle(
                                        fontFamily: AppThemeData.medium,
                                        fontSize: 16,
                                        color: isDarkMode ? AppThemeData.grey900Dark : AppThemeData.grey900,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              color: isDarkMode ? AppThemeData.grey300Dark : AppThemeData.grey300,
                              height: 0.8,
                            ),
                            Container(
                              color: isDarkMode ? AppThemeData.grey300Dark : AppThemeData.grey300,
                              height: 0.8,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Total to Pay".tr,
                                    style: TextStyle(
                                      fontFamily: AppThemeData.regular,
                                      fontSize: 16,
                                      color: isDarkMode ? AppThemeData.grey900Dark : AppThemeData.grey900,
                                    ),
                                  ),
                                  Text(
                                    Constant().amountShow(amount: "${int.parse(data.prix.toString()) * daysBetween(controller.startDate.value, controller.endDate.value)}"),
                                    style: TextStyle(
                                      fontFamily: AppThemeData.semiBold,
                                      fontSize: 16,
                                      color: AppThemeData.secondary200,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              color: isDarkMode ? AppThemeData.grey300Dark : AppThemeData.grey300,
                              height: 0.8,
                            ),
                          ],
                        ),
                      ),
                      Form(
                        key: _contactKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: MobileTextFieldWidget(
                          hintText: 'Enter your contact number'.tr,
                          controller: controller.phoneController.value,
                          onChanged: (phone) {
                            controller.phoneController.value.text = phone.completeNumber;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      ButtonThem.buildButton(context, title: "Send Request".tr, onPress: () {
                        if (controller.phoneController.value.text.isEmpty) {
                          ShowToastDialog.showToast("Please Enter Mobile Number.");
                        } else if (_contactKey.currentState!.validate()) {
                          Map<String, dynamic> bodyParams = {
                            'nb_jour': daysBetween(controller.startDate.value, controller.endDate.value).toString(),
                            'date_debut': DateFormat('yyyy-MM-dd').format(controller.startDate.value),
                            'date_fin': DateFormat('yyyy-MM-dd').format(controller.endDate.value),
                            'contact': controller.phoneController.value.text.trim(),
                            'id_user_app': Preferences.getInt(Preferences.userId).toString(),
                            'id_vehicule': data.id.toString(),
                          };
                          controller.setLocation(bodyParams).then((value) {
                            if (value != null) {
                              Get.back();
                              ShowToastDialog.showToast("Success! Your request has been sent");
                            }
                          });
                        }
                      }),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  int daysBetween(DateTime from, DateTime to) {
    log(from.toString());
    log(to.toString());
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return to.difference(from).inDays + 1;
  }
}

Future<DateTime?> selectRenralDate(BuildContext context, {required DateTime initialDate, required DateTime startDate, required DateTime endDate}) async {
  return await showDatePicker(
    context: context,
    initialDate: initialDate,
    initialDatePickerMode: DatePickerMode.day,
    firstDate: startDate,
    lastDate: endDate,
    builder: (BuildContext context, Widget? child) {
      final themeChange = Provider.of<DarkThemeProvider>(context);
      return Theme(
        data: ThemeData(
          colorScheme: themeChange.getThem()
              ? ColorScheme.dark(
                  primary: AppThemeData.primary200,
                  secondary: AppThemeData.grey300,
                  onPrimary: AppThemeData.surface50Dark,
                  onSurface: AppThemeData.primary200,
                )
              : ColorScheme.light(
                  primary: AppThemeData.primary200,
                  secondary: AppThemeData.grey300,
                  onPrimary: AppThemeData.surface50,
                  onSurface: AppThemeData.primary200,
                ), dialogTheme: DialogThemeData(backgroundColor: themeChange.getThem() ? AppThemeData.surface50Dark : AppThemeData.surface50),
        ),
        child: child!,
      );
    },
  );
}
