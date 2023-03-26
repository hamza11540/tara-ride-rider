import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum DriverStatusEnum {
  pending,
  approved,
  reproved,
}

class DriverStatusEnumHelper {
  static DriverStatusEnum? enumFromString(String enumString) {
    switch (enumString) {
      case 'pending':
        return DriverStatusEnum.pending;
      case 'approved':
        return DriverStatusEnum.approved;
      case 'reproved':
        return DriverStatusEnum.reproved;
      default:
        return null;
    }
  }
}

extension DriverStatusEnumExtension on DriverStatusEnum {
  static String description(
      DriverStatusEnum driverStatusEnum, BuildContext context) {
    switch (driverStatusEnum) {
      case DriverStatusEnum.pending:
        return AppLocalizations.of(context)!.pending;
      case DriverStatusEnum.approved:
        return AppLocalizations.of(context)!.approved;
      case DriverStatusEnum.reproved:
        return AppLocalizations.of(context)!.reproved;
    }
  }
}
