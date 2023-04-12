import 'dart:convert';

import 'package:driver_app/src/models/address.dart';
import 'package:driver_app/src/models/offline_payment_method.dart';
import 'package:driver_app/src/models/status_enum.dart';
import 'package:driver_app/src/models/user.dart';

class Ride {
  String id;
  String? cancellationReason;
  User? user;
  Address? boardingLocation;
  Address? destinationLocation;
  StatusEnum? rideStatus;
  StatusEnum? paymentStatus;
  String? paymentGateway;
  OfflinePaymentMethod? offlinePaymentMethod;
  String? observation;
  double distance;
  double amount;
  double driverValue;

  double appValue;
  bool finalized;
  DateTime? createdAt;

  Ride({
    this.id = "",
    this.observation = "",
    this.distance = 0.00,
    this.amount = 0.00,
    this.driverValue = 0.00,
    this.appValue = 0.00,
    this.finalized = false,
  });

  Ride.fromJSON(Map<String, dynamic> jsonMap)
      : id = jsonMap['id']?.toString() ?? '',
        cancellationReason = jsonMap['motivo_cancelamento']?.toString(),
        user = jsonMap['user'] != null ? User.fromJSON(jsonMap['user']) : null,
        boardingLocation = jsonMap['boarding_location_data'] != null
            ? Address.fromJSON(jsonDecode(jsonMap['boarding_location_data']))
            : null,
        destinationLocation = jsonMap['destination_location_data'] != null
            ? Address.fromJSON(jsonDecode(jsonMap['destination_location_data']))
            : null,
        rideStatus = jsonMap['ride_status'] != null
            ? StatusEnumHelper.enumFromString(jsonMap['ride_status'])
            : null,
        paymentStatus = jsonMap['payment_status'] != null
            ? StatusEnumHelper.enumFromString(jsonMap['payment_status']) ??
                StatusEnum.pending
            : StatusEnum.pending,
        paymentGateway = jsonMap['payment_gateway'] != null
            ? jsonMap['payment_gateway']
            : null,
        offlinePaymentMethod = jsonMap['offline_payment_method'] != null
            ? OfflinePaymentMethod.fromJSON(jsonMap['offline_payment_method'])
            : null,
        observation = jsonMap['status_observation'] != null
            ? jsonMap['status_observation']
            : null,
        distance = jsonMap['distance'] != null
            ? double.parse(jsonMap['distance'].toString())
            : 0.00,
        amount = jsonMap['total_value'] != null
            ? double.parse(jsonMap['total_value'].toString())
            : 0.00,
        driverValue = jsonMap['driver_value'] != null
            ? double.parse(jsonMap['driver_value'].toString())
            : 0.00,
        appValue = jsonMap['app_value'] != null
            ? double.parse(jsonMap['app_value'].toString())
            : 0.00,
        finalized = StatusEnumHelper.enumFromString(jsonMap['ride_status']) ==
                StatusEnum.completed ||
            StatusEnumHelper.enumFromString(jsonMap['ride_status']) ==
                StatusEnum.cancelled,
        createdAt = jsonMap['created_at'] != null
            ? DateTime.tryParse(jsonMap['created_at']) ?? null
            : null;

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'user': user?.toJSON(),
      'distance': distance,
      'observacao': observation,
      'valor_total': amount,
      'finalizado': finalized,
    };
  }
}
