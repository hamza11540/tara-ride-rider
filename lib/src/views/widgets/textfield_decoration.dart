import 'package:flutter/material.dart';

import '../../../app_colors.dart';

InputDecoration customInputDecoration({String? labelText, String? prefixIcon, Widget? suffixIcon, TextStyle? labelTextStyle,String? hintText, TextStyle? hintTextStyle}) {
  return InputDecoration(
    counterText: "",
    suffixIcon: suffixIcon,
    labelText: labelText,
    labelStyle: labelTextStyle,
    hintText: hintText,
    hintStyle: hintTextStyle,
    fillColor: AppColors.lightBlue3,
    filled: true,
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(width: 0.2, color: AppColors.lightBlue3)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(width: 0.6, color: AppColors.lightBlue3)),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(width: 0.2, color: AppColors.lightBlue3)),


  );
}
