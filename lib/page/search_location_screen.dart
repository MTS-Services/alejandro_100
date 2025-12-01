import 'package:cabme/controller/phone_number_controller.dart';
import 'package:cabme/controller/search_address_controller.dart';
import 'package:cabme/themes/appbar_cust.dart';
import 'package:cabme/themes/constant_colors.dart';
import 'package:cabme/themes/responsive.dart';
import 'package:cabme/themes/text_field_them.dart';
import 'package:cabme/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AddressSearchScreen extends StatelessWidget {
  final PhoneNumberController controller = Get.put(PhoneNumberController());

  AddressSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    bool isDarkMode = themeChange.getThem();

    return GetX<SearchAddressController>(
        init: SearchAddressController(),
        builder: (controller) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: AppThemeData.primary200,
            appBar: CustomAppbar(
              bgColor: AppThemeData.primary200,
              title: "Search Adress".tr,
            ),
            body: SafeArea(
              child: Stack(
                alignment: AlignmentDirectional.topStart,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: SizedBox(),
                      ),
                      Expanded(
                        flex: 12,
                        child: Container(
                          color: isDarkMode ? AppThemeData.surface50Dark : AppThemeData.surface50,
                          child: Stack(
                            alignment: AlignmentDirectional.bottomCenter,
                            children: [
                              Image.asset(
                                isDarkMode ? 'assets/images/ic_bg_signup_dark.png' : 'assets/images/ic_bg_signup_light.png',
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 30,
                    left: 20,
                    right: 20,
                    child: SizedBox(
                      height: Responsive.height(80, context),
                      width: Responsive.width(90, context),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFieldWidget(
                                  onChanged: (v) {
                                    controller.debouncer(() => controller.fetchAddress(v));
                                    return null;
                                  },
                                  suffix: IconButton(onPressed: () {}, icon: SvgPicture.asset('assets/icons/ic_direction.svg')),
                                  prefix: IconButton(onPressed: () {}, icon: SvgPicture.asset('assets/icons/ic_location.svg')),
                                  hintText: 'Enter address or location'.tr,
                                  controller: controller.searchTxtController.value,
                                ),
                                const SizedBox(height: 20),
                                if (controller.suggestionsList.isEmpty && controller.isSearch.value == false)
                                  SizedBox(
                                    width: Responsive.width(100, context),
                                    height: Responsive.height(30, context),
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Text(
                                        'Not Found Location'.tr,
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: AppThemeData.regular,
                                          color: themeChange.getThem() ? AppThemeData.grey500Dark : AppThemeData.grey400,
                                        ),
                                      ),
                                    ),
                                  ),
                                if (controller.suggestionsList.isNotEmpty || controller.isSearch.value == true)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        controller.isSearch.value ? 'location Searching....'.tr : "Suggested location".tr,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: AppThemeData.regular,
                                          color: isDarkMode ? AppThemeData.grey900Dark : AppThemeData.grey900,
                                        ),
                                      ),
                                      if (controller.suggestionsList.isNotEmpty) const SizedBox(height: 10),
                                      if (controller.suggestionsList.isNotEmpty)
                                        ListView.builder(
                                          padding: EdgeInsets.zero,
                                          shrinkWrap: true,
                                          primary: true,
                                          itemCount: controller.suggestionsList.length,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: () {
                                                Get.back(result: controller.suggestionsList[index]);
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 12),
                                                child: Row(children: [
                                                  SvgPicture.asset(
                                                    'assets/icons/ic_location.svg',
                                                    colorFilter: ColorFilter.mode(
                                                      themeChange.getThem() ? AppThemeData.grey500Dark : AppThemeData.grey500,
                                                      BlendMode.srcIn,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Expanded(
                                                    child: Text(
                                                      controller.suggestionsList[index].address.toString(),
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontFamily: AppThemeData.regular,
                                                        color: isDarkMode ? AppThemeData.grey300 : AppThemeData.grey300Dark,
                                                      ),
                                                    ),
                                                  ),
                                                  SvgPicture.asset(
                                                    'assets/icons/ic_close.svg',
                                                    colorFilter: ColorFilter.mode(
                                                      themeChange.getThem() ? AppThemeData.grey500Dark : AppThemeData.grey500,
                                                      BlendMode.srcIn,
                                                    ),
                                                  ),
                                                ]),
                                              ),
                                            );
                                          },
                                        ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
