class PreviousRideResponse {
  List<PreviousRideModel>? previousRide;
  PreviousRideResponse.fromJson(Iterable json) {
    previousRide = [];
    print("this is the length");
    print(json.length);

    json.forEach((element) {
      previousRide!.add(PreviousRideModel.fromJson(element));
    });
  }
}

class PreviousRideModel {
  int? id;
  int? userId;
  int? vehicleTypeId;
  int? driverId;
  String? boardingLocation;
  BoardingLocationData? boardingLocationData;
  int? saveBoardingLocationForNextRide;
  DestinationLocationData? destinationLocationData;
  String? distance;
  String? driverValue;
  String? appValue;
  String? totalValue;
  String? customerObservation;
  int? offlinePaymentMethodId;
  String? paymentGateway;
  String? gatewayOrderId;
  String? gatewayId;
  String? paymentStatus;
  String? paymentStatusDate;
  String? rideStatus;
  String? rideStatusDate;
  String? statusObservation;
  String? driverAssignedDate;
  List<int>? assignedDrivers;
  String? createdAt;
  String? updatedAt;
  int? rating;
  String? comment;

  PreviousRideModel(
      {this.id,
      this.userId,
      this.vehicleTypeId,
      this.driverId,
      this.boardingLocation,
      this.boardingLocationData,
      this.saveBoardingLocationForNextRide,
      this.destinationLocationData,
      this.distance,
      this.driverValue,
      this.appValue,
      this.totalValue,
      this.customerObservation,
      this.offlinePaymentMethodId,
      this.paymentGateway,
      this.gatewayOrderId,
      this.gatewayId,
      this.paymentStatus,
      this.paymentStatusDate,
      this.rideStatus,
      this.rideStatusDate,
      this.statusObservation,
      this.driverAssignedDate,
      this.assignedDrivers,
      this.createdAt,
        this.rating,
        this.comment,
      this.updatedAt});

  PreviousRideModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    vehicleTypeId = json['vehicle_type_id'];
    driverId = json['driver_id'];
    boardingLocation = json['boarding_location'];
    boardingLocationData = json['boarding_location_data'] != null
        ? new BoardingLocationData.fromJson(json['boarding_location_data'])
        : null;
    saveBoardingLocationForNextRide =
        json['save_boarding_location_for_next_ride'];
    destinationLocationData = json['destination_location_data'] != null
        ? new DestinationLocationData.fromJson(
            json['destination_location_data'])
        : null;
    distance = json['distance'];
    driverValue = json['driver_value'];
    appValue = json['app_value'];
    totalValue = json['total_value'];
    customerObservation = json['customer_observation'];
    offlinePaymentMethodId = json['offline_payment_method_id'];
    paymentGateway = json['payment_gateway'];
    gatewayOrderId = json['gateway_order_id'];
    gatewayId = json['gateway_id'];
    paymentStatus = json['payment_status'];
    paymentStatusDate = json['payment_status_date'];
    rideStatus = json['ride_status'];
    rideStatusDate = json['ride_status_date'];
    statusObservation = json['status_observation'];
    driverAssignedDate = json['driver_assigned_date'];
    assignedDrivers = json['assigned_drivers'].cast<int>();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    rating = json['rating'];
    comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['vehicle_type_id'] = this.vehicleTypeId;
    data['driver_id'] = this.driverId;
    data['boarding_location'] = this.boardingLocation;
    if (this.boardingLocationData != null) {
      data['boarding_location_data'] = this.boardingLocationData!.toJson();
    }
    data['save_boarding_location_for_next_ride'] =
        this.saveBoardingLocationForNextRide;
    if (this.destinationLocationData != null) {
      data['destination_location_data'] =
          this.destinationLocationData!.toJson();
    }
    data['distance'] = this.distance;
    data['driver_value'] = this.driverValue;
    data['app_value'] = this.appValue;
    data['total_value'] = this.totalValue;
    data['customer_observation'] = this.customerObservation;
    data['offline_payment_method_id'] = this.offlinePaymentMethodId;
    data['payment_gateway'] = this.paymentGateway;
    data['gateway_order_id'] = this.gatewayOrderId;
    data['gateway_id'] = this.gatewayId;
    data['payment_status'] = this.paymentStatus;
    data['payment_status_date'] = this.paymentStatusDate;
    data['ride_status'] = this.rideStatus;
    data['ride_status_date'] = this.rideStatusDate;
    data['status_observation'] = this.statusObservation;
    data['driver_assigned_date'] = this.driverAssignedDate;
    data['assigned_drivers'] = this.assignedDrivers;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['rating'] = this.rating;
    data['comment'] = this.comment;
    return data;
  }
}

class BoardingLocationData {
  List<AddressComponents>? addressComponents;
  String? formattedAddress;
  Geometry? geometry;
  String? placeId;
  PlusCode? plusCode;
  List<String>? types;

  BoardingLocationData(
      {this.addressComponents,
      this.formattedAddress,
      this.geometry,
      this.placeId,
      this.plusCode,
      this.types});

  BoardingLocationData.fromJson(Map<String, dynamic> json) {
    if (json['address_components'] != null) {
      addressComponents = <AddressComponents>[];
      json['address_components'].forEach((v) {
        addressComponents!.add(new AddressComponents.fromJson(v));
      });
    }
    formattedAddress = json['formatted_address'];
    geometry = json['geometry'] != null
        ? new Geometry.fromJson(json['geometry'])
        : null;
    placeId = json['place_id'];
    plusCode = json['plus_code'] != null
        ? new PlusCode.fromJson(json['plus_code'])
        : null;
    //types = json['types'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.addressComponents != null) {
      data['address_components'] =
          this.addressComponents!.map((v) => v.toJson()).toList();
    }
    data['formatted_address'] = this.formattedAddress;
    if (this.geometry != null) {
      data['geometry'] = this.geometry!.toJson();
    }
    data['place_id'] = this.placeId;
    if (this.plusCode != null) {
      data['plus_code'] = this.plusCode!.toJson();
    }
    data['types'] = this.types;
    return data;
  }
}

class AddressComponents {
  String? longName;
  String? shortName;
  List<String>? types;

  AddressComponents({this.longName, this.shortName, this.types});

  AddressComponents.fromJson(Map<String, dynamic> json) {
    longName = json['long_name'];
    shortName = json['short_name'];
    types = json['types'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['long_name'] = this.longName;
    data['short_name'] = this.shortName;
    data['types'] = this.types;
    return data;
  }
}

class Geometry {
  Location? location;
  String? locationType;
  Viewport? viewport;

  Geometry({this.location, this.locationType, this.viewport});

  Geometry.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    locationType = json['location_type'];
    viewport = json['viewport'] != null
        ? new Viewport.fromJson(json['viewport'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    data['location_type'] = this.locationType;
    if (this.viewport != null) {
      data['viewport'] = this.viewport!.toJson();
    }
    return data;
  }
}

class Location {
  double? lat;
  double? lng;

  Location({this.lat, this.lng});

  Location.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}

class Viewport {
  double? south;
  double? west;
  double? north;
  double? east;

  Viewport({this.south, this.west, this.north, this.east});

  Viewport.fromJson(Map<String, dynamic> json) {
    south = json['south'];
    west = json['west'];
    north = json['north'];
    east = json['east'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['south'] = this.south;
    data['west'] = this.west;
    data['north'] = this.north;
    data['east'] = this.east;
    return data;
  }
}

class PlusCode {
  String? compoundCode;
  String? globalCode;

  PlusCode({this.compoundCode, this.globalCode});

  PlusCode.fromJson(Map<String, dynamic> json) {
    compoundCode = json['compound_code'];
    globalCode = json['global_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['compound_code'] = this.compoundCode;
    data['global_code'] = this.globalCode;
    return data;
  }
}

class DestinationLocationData {
  List<AddressComponents>? addressComponents;
  String? formattedAddress;
  Geometry? geometry;
  String? placeId;
  List<String>? types;

  DestinationLocationData(
      {this.addressComponents,
      this.formattedAddress,
      this.geometry,
      this.placeId,
      this.types});

  DestinationLocationData.fromJson(Map<String, dynamic> json) {
    if (json['address_components'] != null) {
      addressComponents = <AddressComponents>[];
      json['address_components'].forEach((v) {
        addressComponents!.add(new AddressComponents.fromJson(v));
      });
    }
    formattedAddress = json['formatted_address'];
    geometry = json['geometry'] != null
        ? new Geometry.fromJson(json['geometry'])
        : null;
    placeId = json['place_id'];
    //types = json['types'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.addressComponents != null) {
      data['address_components'] =
          this.addressComponents!.map((v) => v.toJson()).toList();
    }
    data['formatted_address'] = this.formattedAddress;
    if (this.geometry != null) {
      data['geometry'] = this.geometry!.toJson();
    }
    data['place_id'] = this.placeId;
    data['types'] = this.types;
    return data;
  }
}

// class Geometry {
//   Viewport? bounds;
//   Location? location;
//   String? locationType;
//   Viewport? viewport;
//
//   Geometry({this.bounds, this.location, this.locationType, this.viewport});
//
//   Geometry.fromJson(Map<String, dynamic> json) {
//     bounds =
//     json['bounds'] != null ? new Viewport.fromJson(json['bounds']) : null;
//     location = json['location'] != null
//         ? new Location.fromJson(json['location'])
//         : null;
//     locationType = json['location_type'];
//     viewport = json['viewport'] != null
//         ? new Viewport.fromJson(json['viewport'])
//         : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.bounds != null) {
//       data['bounds'] = this.bounds!.toJson();
//     }
//     if (this.location != null) {
//       data['location'] = this.location!.toJson();
//     }
//     data['location_type'] = this.locationType;
//     if (this.viewport != null) {
//       data['viewport'] = this.viewport!.toJson();
//     }
//     return data;
//   }
// }
