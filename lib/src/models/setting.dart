import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:driver_app/src/models/distance_unit_enum.dart';
import 'package:driver_app/src/models/vehicle_type.dart';
import 'package:flutter/material.dart';

class Setting {
  String appName;
  Color? mainColor;
  Color? secondaryColor;
  Color? highlightColor;
  Color? backgroundColor;
  Color? mainColorDark;
  Color? secondaryColorDark;
  Color? highlightColorDark;
  Color? backgroundColorDark;
  DistanceUnitEnum distanceUnit;
  AdaptiveThemeMode theme;
  bool enableTermsOfService;
  String termsOfService;
  bool enablePrivacyPolicy;
  String privacyPolicy;
  Locale locale;
  List<VehicleType> vehicleTypes;

  String currency;
  bool currencyRight;
  String currencySymbol;

  Setting({
    this.appName = '',
    this.distanceUnit = DistanceUnitEnum.kilometer,
    this.theme = AdaptiveThemeMode.light,
    this.enableTermsOfService = false,
    this.termsOfService = '',
    this.enablePrivacyPolicy = false,
    this.privacyPolicy = '',
    this.currency = "",
    this.currencyRight = false,
    this.currencySymbol = "",
    this.locale = const Locale('en'),
    this.vehicleTypes = const [],
  });

  Setting.fromJSON(Map<String, dynamic> jsonMap)
      : appName = jsonMap['app_name'] ?? '',
        mainColor = jsonMap['main_color'] != null && jsonMap['main_color'] != ''
            ? Color(int.parse(jsonMap['main_color'].replaceAll('#', '0xff')))
            : null,
        secondaryColor = jsonMap['secondary_color'] != null &&
                jsonMap['secondary_color'] != ''
            ? Color(
                int.parse(jsonMap['secondary_color'].replaceAll('#', '0xff')))
            : null,
        highlightColor = jsonMap['highlight_color'] != null &&
                jsonMap['highlight_color'] != ''
            ? Color(
                int.parse(jsonMap['highlight_color'].replaceAll('#', '0xff')))
            : null,
        backgroundColor = jsonMap['background_color'] != null &&
                jsonMap['background_color'] != ''
            ? Color(
                int.parse(jsonMap['background_color'].replaceAll('#', '0xff')))
            : null,
        mainColorDark = jsonMap['main_color_dark_theme'] != null &&
                jsonMap['main_color_dark_theme'] != ''
            ? Color(int.parse(
                jsonMap['main_color_dark_theme'].replaceAll('#', '0xff')))
            : null,
        secondaryColorDark = jsonMap['secondary_color_dark_theme'] != null &&
                jsonMap['secondary_color_dark_theme'] != ''
            ? Color(int.parse(
                jsonMap['secondary_color_dark_theme'].replaceAll('#', '0xff')))
            : null,
        highlightColorDark = jsonMap['highlight_color_dark_theme'] != null &&
                jsonMap['highlight_color_dark_theme'] != ''
            ? Color(int.parse(
                jsonMap['highlight_color_dark_theme'].replaceAll('#', '0xff')))
            : null,
        backgroundColorDark = jsonMap['background_color_dark_theme'] != null &&
                jsonMap['background_color_dark_theme'] != ''
            ? Color(int.parse(
                jsonMap['background_color_dark_theme'].replaceAll('#', '0xff')))
            : null,
        distanceUnit =
            DistanceUnitEnumHelper.enumFromString(jsonMap['distance_unit']),
        theme = AdaptiveThemeMode.light,
        locale = Locale(
          jsonMap['locale'] ?? 'en',
          jsonMap['locale_region'],
        ),
        enableTermsOfService = jsonMap['enable_terms_of_service'] == true ||
            jsonMap['enable_terms_of_service'] == "1",
        termsOfService = jsonMap['terms_of_service'] ?? '',
        enablePrivacyPolicy = jsonMap['enable_privacy_policy'] == true ||
            jsonMap['enable_privacy_policy'] == "1",
        privacyPolicy = jsonMap['privacy_policy'] ?? '',
        currency = jsonMap['currency'] ?? 'USD',
        currencyRight = jsonMap['currency_right'] == true ||
            jsonMap['currency_right'] == "1",
        currencySymbol = jsonMap['currency_symbol'] ?? '\$',
        vehicleTypes = jsonMap['vehicle_types'] != null
            ? jsonMap['vehicle_types']
                    .map((address) => VehicleType.fromJSON(address))
                    .toList()
                    .cast<VehicleType>() ??
                []
            : [];

  Map<String, dynamic> toJSON() {
    return {
      'termos_entregador': termsOfService,
    };
  }
}
