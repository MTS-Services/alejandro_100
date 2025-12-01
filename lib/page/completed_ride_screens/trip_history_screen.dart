import 'package:cabme/constant/constant.dart';
import 'package:cabme/constant/show_toast_dialog.dart';
import 'package:cabme/controller/payment_controller.dart';
import 'package:cabme/model/tax_model.dart';
import 'package:cabme/page/review_screens/add_review_screen.dart';
import 'package:cabme/page/route_view_screen/route_osm_view_screen.dart';
import 'package:cabme/page/route_view_screen/route_view_screen.dart';
import 'package:cabme/themes/appbar_cust.dart';
import 'package:cabme/themes/button_them.dart';
import 'package:cabme/themes/constant_colors.dart';
import 'package:cabme/themes/custom_alert_dialog.dart';
import 'package:cabme/themes/custom_dialog_box.dart';
import 'package:cabme/themes/text_field_them.dart';
import 'package:cabme/utils/Preferences.dart';
import 'package:cabme/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'payment_selection_screen.dart';

class TripHistoryScreen extends StatelessWidget {
  TripHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    bool isDarkMode = themeChange.getThem();
    return GetX<PaymentController>(
      init: PaymentController(),
      builder: (controller) {
        return Scaffold(
          appBar: CustomAppbar(
            bgColor: AppThemeData.primary200,
            title: 'Ride Details'.tr,
          ),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: themeChange.getThem() ? AppThemeData.grey200Dark : AppThemeData.grey200,
                                ),
                                color: themeChange.getThem() ? AppThemeData.surface50Dark : AppThemeData.surface50,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(0),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          children: [
                                            SvgPicture.asset(
                                              'assets/icons/ic_location.svg',
                                              colorFilter: ColorFilter.mode(
                                                AppThemeData.success300,
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                            Container(
                                              width: 2,
                                              height: 40,
                                              color: themeChange.getThem() ? AppThemeData.grey200Dark : AppThemeData.grey200,
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                controller.data.value.departName.toString(),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: AppThemeData.regular,
                                                  color: themeChange.getThem() ? AppThemeData.grey400 : AppThemeData.grey300Dark,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Divider(),
                                        Align(
                                            alignment: Alignment.topRight,
                                            child: controller.data.value.statut == "new"
                                                ? statusTile(title: 'New', bgColor: AppThemeData.primary50, txtColor: AppThemeData.primary200)
                                                : controller.data.value.statut == "on ride"
                                                    ? statusTile(title: 'Active', bgColor: AppThemeData.primary50, txtColor: AppThemeData.primary200)
                                                    : controller.data.value.statut == "confirmed"
                                                        ? statusTile(title: 'Confirmed', bgColor: AppThemeData.primary50, txtColor: AppThemeData.primary200)
                                                        : controller.data.value.statut == "completed"
                                                            ? statusTile(title: 'Completed', bgColor: AppThemeData.success50, txtColor: AppThemeData.success300)
                                                            : statusTile(title: 'Rejected', bgColor: AppThemeData.error50, txtColor: AppThemeData.error200)),
                                      ],
                                    ),
                                    ListView.builder(
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: controller.data.value.stops!.length,
                                        itemBuilder: (context, int index) {
                                          return Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 7),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      String.fromCharCode(index + 65),
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 2,
                                                      height: 40,
                                                      color: themeChange.getThem() ? AppThemeData.grey200Dark : AppThemeData.grey200,
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      controller.data.value.stops![index].location.toString(),
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontFamily: AppThemeData.regular,
                                                        color: themeChange.getThem() ? AppThemeData.grey400 : AppThemeData.grey300Dark,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        }),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/ic_location.svg',
                                          colorFilter: ColorFilter.mode(
                                            AppThemeData.warning200,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                          child: Text(
                                            controller.data.value.destinationName.toString(),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: AppThemeData.regular,
                                              color: themeChange.getThem() ? AppThemeData.grey400 : AppThemeData.grey300Dark,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Row(
                            //   children: [
                            //     SvgPicture.asset(
                            //       'assets/icons/ic_right.svg',
                            //       colorFilter: ColorFilter.mode(
                            //         AppThemeData.success300,
                            //         BlendMode.srcIn,
                            //       ),
                            //     ),
                            // const SizedBox(width: 10),
                            // Expanded(
                            //   child: Text("Your ride is completed on ${controller.data.value.dateRetour} by Esther Howard",
                            //       maxLines: 2,
                            //       style: TextStyle(
                            //         fontSize: 14,
                            //         fontFamily: AppThemeData.regular,
                            //         color: themeChange.getThem() ? AppThemeData.grey900Dark : AppThemeData.grey900,
                            //       )),
                            // ),
                            //   ],
                            // ),
                            Text('Driver and Cab Details'.tr,
                                maxLines: 1,
                                style: TextStyle(
                                  fontFamily: AppThemeData.semiBold,
                                  color: themeChange.getThem() ? AppThemeData.grey900Dark : AppThemeData.grey900,
                                  fontSize: 18,
                                )),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                                decoration: BoxDecoration(
                                    color: isDarkMode ? AppThemeData.surface50Dark : AppThemeData.surface50,
                                    border: Border.all(
                                      color: isDarkMode ? AppThemeData.grey300Dark : AppThemeData.grey300,
                                      width: 1,
                                    )),
                                child: Column(children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text('Driver Name'.tr,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontFamily: AppThemeData.regular,
                                                color: themeChange.getThem() ? AppThemeData.grey900Dark : AppThemeData.grey900,
                                                fontSize: 16,
                                              )),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text("${controller.data.value.prenomConducteur.toString()} ${controller.data.value.nomConducteur.toString()}",
                                              textAlign: TextAlign.end,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontFamily: AppThemeData.medium,
                                                color: themeChange.getThem() ? AppThemeData.grey500Dark : AppThemeData.grey500,
                                                fontSize: 16,
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    color: isDarkMode ? AppThemeData.grey300Dark : AppThemeData.grey300,
                                    height: 1,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text('Cab Details'.tr,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontFamily: AppThemeData.regular,
                                                color: themeChange.getThem() ? AppThemeData.grey900Dark : AppThemeData.grey900,
                                                fontSize: 16,
                                              )),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(controller.data.value.numberplate.toString(),
                                              textAlign: TextAlign.end,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontFamily: AppThemeData.medium,
                                                color: themeChange.getThem() ? AppThemeData.grey500Dark : AppThemeData.grey500,
                                                fontSize: 16,
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    color: isDarkMode ? AppThemeData.grey300Dark : AppThemeData.grey300,
                                    height: 1,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text('Contact Details'.tr,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontFamily: AppThemeData.regular,
                                                color: themeChange.getThem() ? AppThemeData.grey900Dark : AppThemeData.grey900,
                                                fontSize: 16,
                                              )),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Text('${controller.data.value.driverPhone}',
                                                  textAlign: TextAlign.end,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    fontFamily: AppThemeData.medium,
                                                    color: themeChange.getThem() ? AppThemeData.grey500Dark : AppThemeData.grey500,
                                                    fontSize: 16,
                                                  )),
                                              const SizedBox(width: 5),
                                              InkWell(
                                                splashColor: Colors.transparent,
                                                onTap: () {
                                                  Constant.makePhoneCall(controller.data.value.driverPhone.toString());
                                                },
                                                child: SvgPicture.asset(
                                                  'assets/icons/ic_phone.svg',
                                                  colorFilter: ColorFilter.mode(
                                                    AppThemeData.secondary200,
                                                    BlendMode.srcIn,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    color: isDarkMode ? AppThemeData.grey300Dark : AppThemeData.grey300,
                                    height: 1,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text('Date and Time'.tr,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontFamily: AppThemeData.regular,
                                                color: themeChange.getThem() ? AppThemeData.grey900Dark : AppThemeData.grey900,
                                                fontSize: 16,
                                              )),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text('${controller.data.value.dateRetour}',
                                              textAlign: TextAlign.end,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontFamily: AppThemeData.medium,
                                                color: themeChange.getThem() ? AppThemeData.grey500Dark : AppThemeData.grey500,
                                                fontSize: 16,
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ])),
                            const SizedBox(
                              height: 20,
                            ),
                            Text('Bill Details'.tr,
                                maxLines: 1,
                                style: TextStyle(
                                  fontFamily: AppThemeData.semiBold,
                                  color: themeChange.getThem() ? AppThemeData.grey900Dark : AppThemeData.grey900,
                                  fontSize: 18,
                                )),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                                decoration: BoxDecoration(
                                    color: isDarkMode ? AppThemeData.surface50Dark : AppThemeData.surface50,
                                    border: Border.all(
                                      color: isDarkMode ? AppThemeData.grey300Dark : AppThemeData.grey300,
                                      width: 1,
                                    )),
                                child: Column(children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text('Ride Cost'.tr,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontFamily: AppThemeData.regular,
                                                color: themeChange.getThem() ? AppThemeData.grey900Dark : AppThemeData.grey900,
                                                fontSize: 16,
                                              )),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(Constant().amountShow(amount: controller.data.value.montant),
                                              textAlign: TextAlign.end,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontFamily: AppThemeData.medium,
                                                color: themeChange.getThem() ? AppThemeData.grey500Dark : AppThemeData.grey500,
                                                fontSize: 16,
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    color: isDarkMode ? AppThemeData.grey300Dark : AppThemeData.grey300,
                                    height: 1,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text('Discount'.tr,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontFamily: AppThemeData.regular,
                                                color: themeChange.getThem() ? AppThemeData.grey900Dark : AppThemeData.grey900,
                                                fontSize: 16,
                                              )),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text("(-${Constant().amountShow(amount: controller.discountAmount.value.toString())})",
                                              textAlign: TextAlign.end,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontFamily: AppThemeData.medium,
                                                color: themeChange.getThem() ? AppThemeData.grey500Dark : AppThemeData.grey500,
                                                fontSize: 16,
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    color: isDarkMode ? AppThemeData.grey300Dark : AppThemeData.grey300,
                                    height: 1,
                                  ),
                                  ListView.builder(
                                    itemCount: controller.data.value.statutPaiement == "yes" ? controller.data.value.taxModel!.length : Constant.taxList.length,
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      TaxModel taxModel = controller.data.value.statutPaiement == "yes" ? controller.data.value.taxModel![index] : Constant.taxList[index];
                                      return Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                    '${taxModel.libelle.toString()} (${taxModel.type == "Fixed" ? Constant().amountShow(amount: taxModel.value) : "${taxModel.value}%"})',
                                                    style: TextStyle(
                                                      fontFamily: AppThemeData.regular,
                                                      color: themeChange.getThem() ? AppThemeData.grey900Dark : AppThemeData.grey900,
                                                      fontSize: 16,
                                                    )),
                                                Text(Constant().amountShow(amount: controller.calculateTax(taxModel: taxModel).toString()),
                                                    style: TextStyle(
                                                      fontFamily: AppThemeData.medium,
                                                      color: themeChange.getThem() ? AppThemeData.grey500Dark : AppThemeData.grey500,
                                                      fontSize: 16,
                                                    ))
                                              ],
                                            ),
                                          ),
                                          Container(
                                            color: themeChange.getThem() ? AppThemeData.grey300Dark : AppThemeData.grey300,
                                            height: 1,
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  Visibility(
                                    visible: controller.tipAmount.value == 0 ? false : true,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  child: Text("Driver Tip".tr,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        fontFamily: AppThemeData.regular,
                                                        color: themeChange.getThem() ? AppThemeData.grey900Dark : AppThemeData.grey900,
                                                        fontSize: 16,
                                                      ))),
                                              Text(Constant().amountShow(amount: controller.tipAmount.value.toString()),
                                                  textAlign: TextAlign.end,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    fontFamily: AppThemeData.medium,
                                                    color: themeChange.getThem() ? AppThemeData.grey500Dark : AppThemeData.grey500,
                                                    fontSize: 16,
                                                  )),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          color: isDarkMode ? AppThemeData.grey300Dark : AppThemeData.grey300,
                                          height: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text('Total Payable Amount'.tr,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontFamily: AppThemeData.regular,
                                                color: themeChange.getThem() ? AppThemeData.grey900Dark : AppThemeData.grey900,
                                                fontSize: 16,
                                              )),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(Constant().amountShow(amount: controller.getTotalAmount().toString()),
                                              textAlign: TextAlign.end,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontFamily: AppThemeData.medium,
                                                color: AppThemeData.primary200,
                                                fontSize: 16,
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ])),
                            const SizedBox(
                              height: 20,
                            ),
                            Text('Order Details'.tr,
                                maxLines: 1,
                                style: TextStyle(
                                  fontFamily: AppThemeData.semiBold,
                                  color: themeChange.getThem() ? AppThemeData.grey900Dark : AppThemeData.grey900,
                                  fontSize: 18,
                                )),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                                decoration: BoxDecoration(
                                    color: isDarkMode ? AppThemeData.surface50Dark : AppThemeData.surface50,
                                    border: Border.all(
                                      color: isDarkMode ? AppThemeData.grey300Dark : AppThemeData.grey300,
                                      width: 1,
                                    )),
                                child: Column(children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text('Order ID'.tr,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontFamily: AppThemeData.regular,
                                                color: themeChange.getThem() ? AppThemeData.grey900Dark : AppThemeData.grey900,
                                                fontSize: 16,
                                              )),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text("#${controller.data.value.id ?? ''}",
                                              textAlign: TextAlign.end,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontFamily: AppThemeData.medium,
                                                color: themeChange.getThem() ? AppThemeData.grey500Dark : AppThemeData.grey500,
                                                fontSize: 16,
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        color: isDarkMode ? AppThemeData.grey300Dark : AppThemeData.grey300,
                                        height: 1,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Text('Payment Via'.tr,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    fontFamily: AppThemeData.regular,
                                                    color: themeChange.getThem() ? AppThemeData.grey900Dark : AppThemeData.grey900,
                                                    fontSize: 16,
                                                  )),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                  controller.data.value.statutPaiement == "yes"
                                                      ? "${"Paid using".tr} ${controller.data.value.payment}"
                                                      : "${"Pay using".tr} ${controller.data.value.payment}",
                                                  textAlign: TextAlign.end,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    fontFamily: AppThemeData.medium,
                                                    color: AppThemeData.primary200,
                                                    fontSize: 16,
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ])),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 10),
                      child: Column(
                        children: [
                          if (controller.data.value.statut == 'new' || controller.data.value.statut == 'on ride' || controller.data.value.statut == 'confirmed')
                            Row(
                              children: [
                                controller.data.value.statut == 'new' || controller.data.value.statut == 'confirmed'
                                    ? Expanded(
                                        child: ButtonThem.buildButton(
                                          context,
                                          btnColor: AppThemeData.error200,
                                          title: 'Cancel Ride'.tr,
                                          btnWidthRatio: 1,
                                          onPress: () async {
                                            buildShowBottomSheet(context, themeChange.getThem(), controller);
                                          },
                                        ),
                                      )
                                    : Visibility(
                                        visible: controller.data.value.statut == "on ride" ? true : false,
                                        child: Expanded(
                                          child: ButtonThem.buildButton(
                                            context,
                                            title: 'I do not feel safe'.tr,
                                            btnWidthRatio: 1,
                                            onPress: () async {
                                              ShowToastDialog.showLoader("Please wait");
                                              LocationData location = await Location().getLocation();
                                              Map<String, dynamic> bodyParams = {
                                                'lat': location.latitude,
                                                'lng': location.longitude,
                                                'user_id': Preferences.getInt(Preferences.userId).toString(),
                                                'user_name': "${controller.userModel.value.data!.prenom} ${controller.userModel.value.data!.nom}",
                                                'user_cat': controller.userModel.value.data!.userCat,
                                                'id_driver': controller.data.value.idConducteur,
                                                'feel_safe': 0,
                                                'trip_id': controller.data.value.id,
                                              };
                                              controller.feelNotSafe(bodyParams).then((value) {
                                                ShowToastDialog.closeLoader();
                                                if (value != null) {
                                                  if (value['success'] == "success") {
                                                    ShowToastDialog.showToast("Report submitted".tr);
                                                  }
                                                }
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                Expanded(
                                    child: Padding(
                                        padding: const EdgeInsets.only(left: 10),
                                        child: ButtonThem.buildButton(
                                          context,
                                          title: 'Track Ride'.tr,
                                          onPress: () async {
                                            var argumentData = {'type': controller.data.value.statut.toString(), 'data': controller.data.value};

                                            if (Constant.liveTrackingMapType == "inappmap") {
                                              if (Constant.selectedMapType == 'osm') {
                                                Get.to(const RouteOsmViewScreen(), arguments: argumentData);
                                              } else {
                                                Get.to(const RouteViewScreen(), arguments: argumentData);
                                              }
                                            } else {
                                              Constant.redirectMap(
                                                latitude: double.parse(controller.data.value.latitudeArrivee!), //orderModel.destinationLocationLAtLng!.latitude!,
                                                longLatitude: double.parse(controller.data.value.longitudeArrivee!), //orderModel.destinationLocationLAtLng!.longitude!,
                                                name: controller.data.value.destinationName!,
                                              ); //orderModel.destinationLocationName.toString());
                                            }
                                          },
                                        ))),
                              ],
                            ),
                          if (controller.data.value.statut == "completed" || controller.data.value.statut == "rejected")
                            Row(
                              children: [
                                Visibility(
                                  visible:
                                      controller.data.value.statut == "completed" && controller.data.value.statutPaiement != "yes" && controller.data.value.statut != "rejected",
                                  child: Expanded(
                                      child: ButtonThem.buildButton(context, title: "Pay Now".tr, onPress: () {
                                    // if (controller.data.value.statutPaiement == "yes") {
                                    // controller.feelAsSafe(data.id.toString()).then((value) {
                                    //   if (value != null) {
                                    // controller.getCompletedRide();
                                    //   }
                                    // });
                                    // } else {
                                    Get.to(PaymentSelectionScreen(), arguments: {
                                      "rideData": controller.data.value,
                                    });
                                    // }
                                  })),
                                ),
                                Visibility(
                                  visible: (controller.data.value.statutPaiement == "yes") || (controller.data.value.statut == "rejected"),
                                  child: Expanded(
                                    child: ButtonThem.buildButton(
                                      context,
                                      title: 'Add Review'.tr,
                                      onPress: () async {
                                        Get.to(const AddReviewScreen(), arguments: {
                                          "data": controller.data.value,
                                          "ride_type": "ride",
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
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

  final resonController = TextEditingController();

  buildShowBottomSheet(BuildContext context, bool isDarkMode, PaymentController controller) {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15))),
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        backgroundColor: isDarkMode ? AppThemeData.surface50Dark : AppThemeData.surface50,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              child: Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "Cancel Trip".tr,
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: AppThemeData.semiBold,
                          color: isDarkMode ? AppThemeData.grey900Dark : AppThemeData.grey900,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        "Write a reason for trip cancellation".tr,
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: AppThemeData.regular,
                          color: isDarkMode ? AppThemeData.grey400 : AppThemeData.grey300Dark,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: TextFieldWidget(
                        maxLine: 3,
                        controller: resonController,
                        hintText: '',
                        fontSize: 14,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: ButtonThem.buildButton(
                                context,
                                title: 'Cancel Trip'.tr,
                                btnWidthRatio: 0.8,
                                onPress: () async {
                                  if (resonController.text.isNotEmpty) {
                                    Get.back();
                                    showDialog(
                                      barrierColor: Colors.black26,
                                      context: context,
                                      builder: (context) {
                                        return CustomAlertDialog(
                                          title: "Do you want to cancel this booking?".tr,
                                          onPressNegative: () {
                                            Get.back();
                                          },
                                          onPressPositive: () {
                                            Map<String, String> bodyParams = {
                                              'id_ride': controller.data.value.id.toString(),
                                              'id_user': controller.data.value.idConducteur.toString(),
                                              'name': "${controller.data.value.prenom} ${controller.data.value.nom}",
                                              'from_id': Preferences.getInt(Preferences.userId).toString(),
                                              'user_cat': controller.userModel.value.data!.userCat.toString(),
                                              'reason': resonController.text.toString(),
                                            };
                                            controller.canceledRide(bodyParams).then((value) {
                                              Get.back();
                                              if (value != null) {
                                                showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return CustomDialogBox(
                                                        title: "Cancel Successfully".tr,
                                                        descriptions: "Ride Successfully cancel.".tr,
                                                        onPress: () {
                                                          Get.back();
                                                          Get.back();
                                                        },
                                                        img: Image.asset('assets/images/green_checked.png'),
                                                      );
                                                    });
                                              }
                                            });
                                          },
                                        );
                                      },
                                    );
                                  } else {
                                    ShowToastDialog.showToast("Please enter a reason");
                                  }
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 5, left: 10),
                              child: ButtonThem.buildBorderButton(
                                context,
                                title: 'Close'.tr,
                                btnWidthRatio: 0.8,
                                btnColor: isDarkMode ? AppThemeData.surface50Dark : AppThemeData.surface50,
                                txtColor: AppThemeData.primary200,
                                btnBorderColor: AppThemeData.primary200,
                                onPress: () async {
                                  Get.back();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          });
        });
  }

  Widget statusTile({required String title, Color? bgColor, Color? txtColor}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: bgColor,
      ),
      alignment: Alignment.center,
      height: 32,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          title.tr,
          style: TextStyle(fontSize: 14, color: txtColor, fontFamily: AppThemeData.medium),
        ),
      ),
    );
  }
}
