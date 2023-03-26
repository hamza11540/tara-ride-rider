import 'driver_status_enum.dart';
import 'vehicle_type.dart';

class Driver {
  bool active;
  String? id;
  String? link;
  String? driverLicense;
  String? brand;
  String? plate;
  String? model;
  String? vehicleDocument;
  VehicleType? vehicleType;
  String? statusObservation;
  DriverStatusEnum? status;

  Driver({
    this.active = false,
    this.id = "",
    this.link = "",
  });

  Driver.fromJSON(Map<String, dynamic> jsonMap)
      : active = jsonMap['active'] == true || jsonMap['active'] == '1',
        id = jsonMap['id']?.toString(),
        link = jsonMap['link'],
        driverLicense = jsonMap['driver_license_url'],
        brand = jsonMap['brand'],
        plate = jsonMap['plate'],
        model = jsonMap['model'],
        vehicleDocument = jsonMap['vehicle_document'],
        vehicleType = jsonMap['vehicle_type'] != null
            ? VehicleType.fromJSON(jsonMap['vehicle_type'])
            : null,
        statusObservation = jsonMap['status_observation'] ?? null,
        status = jsonMap['status'] != null
            ? DriverStatusEnumHelper.enumFromString(jsonMap['status'])
            : null;

  Map<String, String> toJSON() {
    Map<String, String> json = {
      'active': active ? '1' : '0',
    };
    if (id != null) {
      json.addAll({'id': id!});
    }
    if (brand != null) {
      json.addAll({'brand': brand!});
    }
    if (plate != null) {
      json.addAll({'plate': plate!});
    }
    if (model != null) {
      json.addAll({'model': model!});
    }
    if (vehicleDocument != null) {
      json.addAll({'vehicle_document': vehicleDocument!});
    }
    if (vehicleType != null) {
      json.addAll({'vehicle_type_id': vehicleType!.id});
    }
    return json;
  }
}
