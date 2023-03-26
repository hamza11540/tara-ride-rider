import 'package:driver_app/src/models/media.dart';

class VehicleType {
  String id;
  String name;
  double basePrice;
  Media? picture;

  VehicleType({
    this.id = "",
    this.name = "",
    this.basePrice = 0.00,
  });

  VehicleType.fromJSON(Map<String, dynamic> jsonMap)
      : id = jsonMap['id']?.toString() ?? '',
        name = jsonMap['name'] ?? '',
        basePrice = jsonMap['base_price'] != null
            ? double.parse(jsonMap['base_price'].toString())
            : 0.00,
        picture = (jsonMap['has_media'] ?? false)
            ? Media.fromJSON(jsonMap['media'][0])
            : null;
}
