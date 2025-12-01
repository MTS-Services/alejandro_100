import 'package:cabme/constant/show_toast_dialog.dart';
import 'package:cabme/controller/add_review_controller.dart';
import 'package:cabme/page/review_screens/review_sucess_screen.dart';
import 'package:cabme/themes/appbar_cust.dart';
import 'package:cabme/themes/button_them.dart';
import 'package:cabme/themes/constant_colors.dart';
import 'package:cabme/themes/text_field_them.dart';
import 'package:cabme/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AddReviewScreen extends StatelessWidget {
  const AddReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<AddReviewController>(
      init: AddReviewController(),
      builder: (controller) {
        return Scaffold(
          appBar: CustomAppbar(
            title: 'Review'.tr,
            bgColor: AppThemeData.primary200,
          ),
          body: Stack(children: [
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
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                                    child: Text(
                                      'Your feedback helps us improve and provide a better experience. Rate your driver and leave a comment!'.tr,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: AppThemeData.regular,
                                        color: themeChange.getThem() ? AppThemeData.grey400 : AppThemeData.grey300Dark,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: RatingBar.builder(
                                      itemSize: 26,
                                      initialRating: controller.rating.value,
                                      minRating: 0,
                                      unratedColor: themeChange.getThem() ? AppThemeData.grey300Dark : AppThemeData.grey400,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                      itemBuilder: (context, _) => const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (rating) {
                                        controller.rating(rating);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFieldThem.boxBuildTextField(
                              conext: context,
                              hintText: 'leave a comments'.tr,
                              controller: controller.reviewCommentController.value,
                              textInputType: TextInputType.emailAddress,
                              maxLine: 5,
                              contentPadding: EdgeInsets.zero,
                              validators: (String? value) {
                                if (value!.isNotEmpty) {
                                  return null;
                                } else {
                                  return 'required'.tr;
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
                    child: ButtonThem.buildButton(context, title: "Submit Review".tr, onPress: () async {
                      if (controller.rating.value == 0 || controller.rating.value == 0.0) {
                        ShowToastDialog.showToast("Please add star rating");
                      } else if (controller.reviewCommentController.value.text.isEmpty) {
                        ShowToastDialog.showToast("Please enter the comments");
                      } else {
                        Map<String, String> bodyParams = {};
                        if (controller.rideType.value.toString() == "ride") {
                          bodyParams = {
                            'ride_id': controller.rideData.value.id.toString(),
                            'id_user_app': controller.rideData.value.idUserApp.toString(),
                            'id_conducteur': controller.rideData.value.idConducteur.toString(),
                            'note_value': controller.rating.value.toString(),
                            'comment': controller.reviewCommentController.value.text,
                            'ride_type': controller.rideType.value.toString(),
                          };
                        } else {
                          bodyParams = {
                            'ride_id': controller.parcelData.value.id.toString(),
                            'id_user_app': controller.parcelData.value.idUserApp.toString(),
                            'id_conducteur': controller.parcelData.value.idConducteur.toString(),
                            'note_value': controller.rating.value.toString(),
                            'comment': controller.reviewCommentController.value.text,
                            'ride_type': controller.rideType.value.toString(),
                          };
                        }

                        await controller.addReview(bodyParams).then((value) {
                          if (value != null) {
                            if (value == true) {
                              Get.off(const ReviewSuccessScreen());
                              // ShowToastDialog.showToast("Review added successfully!".tr);
                            } else {
                              ShowToastDialog.showToast("Something went wrong");
                            }
                          }
                        });
                      }
                    }),
                  ),
                ],
              ),
            ),
          ]),
        );
      },
    );
  }
}
