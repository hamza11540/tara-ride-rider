import 'dart:convert';

import 'package:driver_app/src/models/driver.dart';
import 'package:driver_app/src/models/media.dart';

class User {
  late bool auth;
  String id;
  String name;
  String email;
  String phone;
  String token;
  String firebaseToken;
  String? password;
  num? wallet;
  Driver? driver;
  Media? picture;

  User({
    this.auth = false,
    this.id = "",
    this.name = "",
    this.email = "",
    this.token = "",
    this.firebaseToken = "",
    this.phone = "",
    this.wallet = 0,
    this.driver,
  });

  User.fromJSON(Map<String, dynamic> jsonMap)
      : id = jsonMap['id']?.toString() ?? '',
        name = jsonMap['name'] ?? '',
        email = jsonMap['email'] ?? '',
        phone = jsonMap['phone'] ?? '',
        token = jsonMap['api_token'] ?? '',
        wallet = jsonMap['wallet'] ?? 0,
        firebaseToken = jsonMap['firebase_token'] ?? '',
        driver = jsonMap['driver'] != null
            ? Driver.fromJSON(jsonMap['driver'].runtimeType == String
                ? jsonDecode(jsonMap['driver'])
                : jsonMap['driver'])
            : null,
        picture =
            jsonMap['media'] != null && (jsonMap['media'] as List).length > 0
                ? Media.fromJSON(jsonMap['media'][0])
                : null;

  Map<String, String> toJSON() {
    Map<String, String> json = {};
    json = {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'api_token': token,
    };
    if (password != null) {
      json.addAll({'password': password!});
    }
    if (driver != null) {
      json.addAll({'driver': jsonEncode(driver!.toJSON())});
    }
    return json;
  }

  Map<String, String> toRegisterJSON() {
    Map<String, String> json = {};
    json = {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
    };
    if (password != null) {
      json.addAll({'password': password!});
    }
    if (driver != null) {
      json.addAll({'driver': jsonEncode(driver!.toJSON())});
    }
    return json;
  }
}
