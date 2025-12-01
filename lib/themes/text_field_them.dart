import 'package:cabme/themes/constant_colors.dart';
import 'package:cabme/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:provider/provider.dart';

class TextFieldThem {
  const TextFieldThem(Key? key);

  static buildTextField(
      {required String title,
      required TextEditingController controller,
      IconData? icon,
      String? Function(String?)? validators,
      TextInputType textInputType = TextInputType.text,
      bool obscureText = true,
      EdgeInsets contentPadding = EdgeInsets.zero,
      maxLine = 1,
      bool enabled = true,
      maxLength = 300,
      String? labelText}) {
    return TextFormField(
      obscureText: !obscureText,
      validator: validators,
      keyboardType: textInputType,
      textCapitalization: TextCapitalization.sentences,
      controller: controller,
      maxLines: maxLine,
      maxLength: maxLength,
      enabled: enabled,
      textInputAction: TextInputAction.done,
      decoration:
          InputDecoration(counterText: "", labelText: labelText, hintText: title, contentPadding: contentPadding, suffixIcon: Icon(icon), border: const UnderlineInputBorder()),
    );
  }

  static boxBuildTextField({
    required BuildContext conext,
    required String hintText,
    required TextEditingController controller,
    String? Function(String?)? validators,
    TextInputType textInputType = TextInputType.text,
    bool obscureText = true,
    EdgeInsets contentPadding = EdgeInsets.zero,
    maxLine = 1,
    bool enabled = true,
    Widget? prefix,
    Widget? suffix,
    maxLength = 300,
  }) {
    final themeChange = Provider.of<DarkThemeProvider>(conext);
    return TextFormField(
        obscureText: !obscureText,
        validator: validators,
        keyboardType: textInputType,
        textCapitalization: TextCapitalization.sentences,
        controller: controller,
        maxLines: maxLine,
        maxLength: maxLength,
        enabled: enabled,
        style: TextStyle(
          fontSize: 16,
          color: themeChange.getThem() ? AppThemeData.grey900Dark : AppThemeData.grey900,
          fontFamily: AppThemeData.regular,
        ),
        textInputAction: TextInputAction.done,
        cursorColor: AppThemeData.primary200,
        decoration: InputDecoration(
            prefixIcon: prefix,
            suffixIcon: suffix,
            counterText: "",
            contentPadding: const EdgeInsets.all(14),
            fillColor: themeChange.getThem() ? AppThemeData.surface50Dark : AppThemeData.surface50,
            filled: true,
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(0)),
              borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.grey300Dark : AppThemeData.grey300, width: 0.8),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(0)),
              borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.grey300Dark : AppThemeData.grey300, width: 0.8),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(0)),
              borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.grey300Dark : AppThemeData.grey300, width: 0.8),
            ),
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(0)),
              borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.grey300Dark : AppThemeData.grey300, width: 0.8),
            ),
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 16,
              color: themeChange.getThem() ? AppThemeData.grey400Dark : AppThemeData.grey400,
              fontFamily: AppThemeData.regular,
            )));
  }
}

class TextFieldWidget extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validators;
  final String? Function(String?)? onChanged;
  final VoidCallback? onTap;
  final TextInputType textInputType;
  final bool obscureText;
  final int maxLine;
  final double? fontSize;
  final bool enabled;
  final bool isReadOnly;
  final Widget? prefix;
  final Widget? suffix;
  final int maxLength;
  final Color? hintColor;
  final Color? textColor;
  final Color? borderColor;
  final double width;
  final EdgeInsetsGeometry? contentPadding;
  final String? fontFamily;
  final List<TextInputFormatter>? inputFormatters;

  const TextFieldWidget(
      {super.key,
      required this.hintText,
      required this.controller,
      this.onChanged,
      this.onTap,
      this.validators,
      this.textInputType = TextInputType.text,
      this.obscureText = true,
      this.maxLine = 1,
      this.fontSize = 16,
      this.enabled = true,
      this.prefix,
      this.suffix,
      this.maxLength = 300,
      this.isReadOnly = false,
      this.hintColor,
      this.textColor,
      this.contentPadding,
      this.borderColor,
      this.width = 0.8,
      this.inputFormatters,
      this.fontFamily});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
        color: borderColor ?? (themeChange.getThem() ? AppThemeData.grey200Dark : AppThemeData.grey200),
        width: width,
      )),
      child: TextFormField(
        validator: validators ??
            (String? value) {
              if (value!.isNotEmpty) {
                return null;
              } else {
                return 'required';
              }
            },
        readOnly: isReadOnly,
        onTap: onTap,
        onChanged: onChanged,
        cursorColor: AppThemeData.primary200,
        obscureText: !obscureText,
        keyboardType: textInputType,
        textCapitalization: TextCapitalization.sentences,
        controller: controller,
        maxLines: maxLine,
        maxLength: maxLength,
        enabled: enabled,
        textInputAction: TextInputAction.done,
        inputFormatters: inputFormatters,
        style: TextStyle(
          fontSize: 16,
          color: textColor ?? (themeChange.getThem() ? AppThemeData.grey900Dark : AppThemeData.grey900),
          fontFamily: fontFamily ?? AppThemeData.medium,
        ),
        decoration: InputDecoration(
          prefixIcon: prefix,
          suffixIcon: suffix,
          counterText: "",
          contentPadding: contentPadding ?? const EdgeInsets.all(14),
          fillColor: themeChange.getThem() ? AppThemeData.surface50Dark : AppThemeData.surface50,
          filled: true,
          focusedBorder: UnderlineInputBorder(
            borderRadius: const BorderRadius.only(),
            borderSide: BorderSide(
              color: AppThemeData.primary200,
              width: 0.8,
            ),
          ),
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 16,
            color: themeChange.getThem() ? AppThemeData.grey500Dark : AppThemeData.grey500,
            fontFamily: AppThemeData.regular,
          ),
        ),
      ),
    );
  }
}

class MobileTextFieldWidget extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType? textInputType;
  final bool? enabled;
  final bool isReadOnly;
  final Color? borderColor;
  final List<TextInputFormatter>? inputFormatters;
  final Color? hintColor;
  final ValueChanged<PhoneNumber>? onChanged;
  const MobileTextFieldWidget({
    super.key,
    required this.hintText,
    required this.controller,
    this.textInputType,
    this.enabled,
    this.isReadOnly = false,
    this.borderColor,
    this.hintColor,
    this.inputFormatters,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
        color: themeChange.getThem() ? AppThemeData.grey300Dark : AppThemeData.grey300,
        width: 0.8,
      )),
      child: IntlPhoneField(
        textAlign: TextAlign.start,
        flagsButtonPadding: const EdgeInsets.symmetric(horizontal: 10),
        readOnly: isReadOnly,
        initialValue: controller?.text,
        onChanged: onChanged,
        invalidNumberMessage: "number invalid".tr,
        showDropdownIcon: false,
        disableLengthCheck: true,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          border: InputBorder.none,
          focusedBorder: UnderlineInputBorder(
            borderRadius: const BorderRadius.only(),
            borderSide: BorderSide(
              color: AppThemeData.primary200,
              width: 0.8,
            ),
          ),
          hintText: hintText?.tr,
          isDense: true,
        ),
      ),
    );
  }
}

class TextFieldWidgetBorder extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validators;
  final String? Function(String?)? onChanged;
  final VoidCallback? onTap;
  final TextInputType textInputType;
  final bool obscureText;
  final EdgeInsets contentPadding;
  final int maxLine;
  final bool enabled;
  final bool isReadOnly;
  final Widget? prefix;
  final Widget? suffix;
  final int maxLength;
  final BorderRadius radius;
  final Color? borderColor;

  const TextFieldWidgetBorder(
      {super.key,
      required this.hintText,
      required this.controller,
      this.onChanged,
      this.onTap,
      this.validators,
      this.textInputType = TextInputType.text,
      this.obscureText = true,
      this.contentPadding = const EdgeInsets.all(8),
      this.maxLine = 1,
      this.enabled = true,
      this.prefix,
      this.suffix,
      this.maxLength = 300,
      this.radius = BorderRadius.zero,
      this.isReadOnly = false,
      this.borderColor});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return TextFormField(
      readOnly: isReadOnly,
      onTap: onTap,
      onChanged: onChanged,
      cursorColor: AppThemeData.primary200,
      obscureText: !obscureText,
      validator: validators,
      keyboardType: textInputType,
      textCapitalization: TextCapitalization.sentences,
      controller: controller,
      maxLines: maxLine,
      maxLength: maxLength,
      enabled: enabled,
      textInputAction: TextInputAction.done,
      style: TextStyle(
        fontSize: 16,
        color: themeChange.getThem() ? AppThemeData.grey900Dark : AppThemeData.grey900,
        fontFamily: AppThemeData.regular,
      ),
      decoration: InputDecoration(
        prefixIcon: prefix,
        suffixIcon: suffix,
        counterText: "",
        contentPadding: contentPadding,
        fillColor: themeChange.getThem() ? AppThemeData.surface50Dark : AppThemeData.surface50,
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(
            color: borderColor ?? (themeChange.getThem() ? AppThemeData.grey200Dark : AppThemeData.grey200),
            width: 0.7,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(
            color: borderColor ?? (themeChange.getThem() ? AppThemeData.grey200Dark : AppThemeData.grey200),
            width: 0.7,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(
            color: borderColor ?? (themeChange.getThem() ? AppThemeData.grey200Dark : AppThemeData.grey200),
            width: 0.7,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(
            color: borderColor ?? (themeChange.getThem() ? AppThemeData.grey200Dark : AppThemeData.grey200),
            width: 0.7,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(
            color: borderColor ?? (themeChange.getThem() ? AppThemeData.grey200Dark : AppThemeData.grey200),
            width: 0.7,
          ),
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 16,
          color: themeChange.getThem() ? AppThemeData.grey500Dark : AppThemeData.grey500,
          fontFamily: AppThemeData.regular,
        ),
      ),
    );
  }
}
