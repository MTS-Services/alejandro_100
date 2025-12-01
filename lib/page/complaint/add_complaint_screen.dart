import 'package:cabme/constant/show_toast_dialog.dart';
import 'package:cabme/controller/add_complaint_controller.dart';
import 'package:cabme/themes/appbar_cust.dart';
import 'package:cabme/themes/button_them.dart';
import 'package:cabme/themes/constant_colors.dart';
import 'package:cabme/themes/responsive.dart';
import 'package:cabme/themes/text_field_them.dart';
import 'package:cabme/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AddComplaintScreen extends StatelessWidget {
  AddComplaintScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetX<AddComplaintController>(
      init: AddComplaintController(),
      builder: (controller) {
        final themeChange = Provider.of<DarkThemeProvider>(context);
        return Scaffold(
          appBar: CustomAppbar(
            title: 'Complaint'.tr,
            bgColor: AppThemeData.primary200,
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: AppThemeData.primary200,
                    ),
                  ),
                  Expanded(
                      flex: 8,
                      child: Container(
                        color: themeChange.getThem() ? AppThemeData.surface50Dark : AppThemeData.surface50,
                      )),
                ],
              ),
              SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 16),
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: themeChange.getThem() ? AppThemeData.grey200Dark : AppThemeData.grey200,
                                      ),
                                      color: themeChange.getThem() ? AppThemeData.surface50Dark : AppThemeData.surface50,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(0),
                                      ),
                                    ),
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      SizedBox(
                                        width: Responsive.width(100, context),
                                      ),
                                      Text(
                                        'How is your trip?'.tr,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: AppThemeData.medium,
                                          color: themeChange.getThem() ? AppThemeData.grey900Dark : AppThemeData.grey900,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text('Your complaint  will help us improve \n driving experience better'.tr,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: AppThemeData.regular,
                                              color: themeChange.getThem() ? AppThemeData.grey400 : AppThemeData.grey300Dark,
                                            )),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Row(
                                          children: [
                                            Text(
                                              'Complaint for '.tr,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: AppThemeData.regular,
                                                color: themeChange.getThem() ? AppThemeData.grey400 : AppThemeData.grey300Dark,
                                              ),
                                            ),
                                            Text(
                                              controller.rideType.value.toString() == "ride"
                                                  ? "${controller.rideData.value.prenomConducteur.toString()} ${controller.rideData.value.nomConducteur.toString()}"
                                                  : "${controller.parcelData.value.driverName}",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: AppThemeData.regular,
                                                color: themeChange.getThem() ? AppThemeData.grey400 : AppThemeData.grey300Dark,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Visibility(
                                        visible: controller.complaintStatus.value != '',
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 4),
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(right: 4),
                                                child: Text(
                                                  'Status :'.tr,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: AppThemeData.regular,
                                                    color: themeChange.getThem() ? AppThemeData.grey400 : AppThemeData.grey300Dark,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                controller.complaintStatus.value,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: AppThemeData.regular,
                                                  color: themeChange.getThem() ? AppThemeData.grey900Dark : AppThemeData.grey900,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ]),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Form(
                                    key: _formKey,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      child: Column(
                                        children: [
                                          TextFieldThem.boxBuildTextField(
                                            conext: context,
                                            hintText: 'Type title....'.tr,
                                            controller: controller.complaintTitleController,
                                            textInputType: TextInputType.emailAddress,
                                            contentPadding: EdgeInsets.zero,
                                            validators: (String? value) {
                                              if (value!.isNotEmpty) {
                                                return null;
                                              } else {
                                                return 'Title is required'.tr;
                                              }
                                            },
                                          ),
                                          TextFieldThem.boxBuildTextField(
                                            conext: context,
                                            hintText: 'Type discription....'.tr,
                                            controller: controller.complaintDiscriptionController,
                                            textInputType: TextInputType.emailAddress,
                                            maxLine: 5,
                                            contentPadding: EdgeInsets.zero,
                                            validators: (String? value) {
                                              if (value!.isNotEmpty) {
                                                return null;
                                              } else {
                                                return 'Discription is required'.tr;
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 20),
                            child: ButtonThem.buildButton(context, title: "Submit Complaint".tr, onPress: () async {
                              if (_formKey.currentState!.validate()) {
                                Map<String, String> bodyParams = {};
                                if (controller.rideType.value.toString() == "ride") {
                                  bodyParams = {
                                    'id_user_app': controller.rideData.value.idUserApp.toString(),
                                    'id_conducteur': controller.rideData.value.idConducteur.toString(),
                                    'user_type': 'customer',
                                    'description': controller.complaintDiscriptionController.text.toString(),
                                    'title': controller.complaintTitleController.text.toString(),
                                    'order_id': controller.rideData.value.id.toString(),
                                  };
                                } else {
                                  bodyParams = {
                                    'id_user_app': controller.parcelData.value.idUserApp.toString(),
                                    'id_conducteur': controller.parcelData.value.idConducteur.toString(),
                                    'user_type': 'customer',
                                    'description': controller.complaintDiscriptionController.text.toString(),
                                    'title': controller.complaintTitleController.text.toString(),
                                    'order_id': controller.parcelData.value.id.toString(),
                                    'ride_type': 'parcel'
                                  };
                                }

                                await controller.addComplaint(bodyParams).then((value) {
                                  if (value != null) {
                                    if (value == true) {
                                      ShowToastDialog.showToast("Complaint added successfully!".tr);
                                      Get.back();
                                    } else {
                                      ShowToastDialog.showToast("Something went wrong".tr);
                                    }
                                  }
                                });
                              }
                            }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
