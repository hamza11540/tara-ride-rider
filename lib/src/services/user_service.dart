import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:path/path.dart';

import '../helper/custom_trace.dart';
import '../helper/helper.dart';
import '../models/custom_exception.dart';
import '../models/exceptions_enum.dart';
import '../models/user.dart';

Future<User> login(String email, String password, bool rememberMe) async {
  var response = await http
      .post(Helper.getUri('driver/login', addApiToken: false),
          headers: <String, String>{
            'Accept': 'application/json',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'email': email,
            'password': password,
            'remember': "1"
          }))
      .timeout(const Duration(seconds: 15));

  if (response.statusCode == HttpStatus.accepted) {
    User user = User.fromJSON(jsonDecode(response.body)['data']);
    throw CustomException(ExceptionsEnum.userStatus, user.driver!.status!.name,
        data: {'user': user});
  } else if (response.statusCode == HttpStatus.ok) {
    return User.fromJSON(jsonDecode(response.body)['data']);
  } else {
    print(CustomTrace(StackTrace.current, message: response.body));
    throw Exception(response.statusCode);
  }
}

Future<bool> forgotPassword(String email) async {
  var response = await http
      .post(Helper.getUri('forgot-password', addApiToken: false),
          headers: <String, String>{
            'Accept': 'application/json',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{"email": email}))
      .timeout(const Duration(seconds: 15));

  if (response.statusCode == HttpStatus.ok) {
    return true;
  } else {
    print(CustomTrace(StackTrace.current, message: response.body));
    throw Exception(jsonDecode(response.body)['message'] ?? '');
  }
}

Future<User> verifyLogin(String apiToken) async {
  var response = await http
      .get(Helper.getUri('driver/login/verify'), headers: <String, String>{
    'Accept': 'application/json',
    'Content-Type': 'application/json; charset=UTF-8',
  }).timeout(const Duration(seconds: 15));
  if (response.statusCode == HttpStatus.accepted) {
    User user = User.fromJSON(jsonDecode(response.body)['data']);
    throw CustomException(ExceptionsEnum.userStatus, user.driver!.status!.name,
        data: {'user': user});
  } else if (response.statusCode == HttpStatus.ok) {
    return User.fromJSON(jsonDecode(response.body)['data']);
  } else {
    print(CustomTrace(StackTrace.current, message: response.body));
    throw Exception(response.statusCode);
  }
}

Future<User> updateRegister(
  User user,
  File? driverLicense,
) async {
  print(user.toRegisterJSON());
  var requestJson = <String, String>{};
  requestJson.addAll(user.toRegisterJSON());
  var request =
      http.MultipartRequest('POST', Helper.getUri('driver/updateRegister'));
  if (driverLicense != null) {
    request.files.add(http.MultipartFile('driver_license',
        driverLicense.readAsBytes().asStream(), driverLicense.lengthSync(),
        filename: basename(driverLicense.path)));
  }
  request.headers.addAll(
      {"Content-Type": "application/json", "Accept": "application/json"});
  request.fields.addAll(requestJson);
  var response = await http.Response.fromStream(
      await request.send().timeout(const Duration(seconds: 15)));
  if (response.statusCode == HttpStatus.ok) {
    return User.fromJSON(jsonDecode(response.body)['data']);
  } else {
    print(CustomTrace(StackTrace.current, message: response.body));
    throw Exception(jsonDecode(response.body)['errors'] ?? '');
  }
}

Future<User> register(
  User user,
  File? driverLicense,
) async {
  var requestJson = <String, String>{};

  requestJson.addAll(user.toRegisterJSON());
  var request = http.MultipartRequest(
      'POST', Helper.getUri('driver/register', addApiToken: false));
  if (driverLicense != null) {
    request.files.add(http.MultipartFile('driver_license',
        driverLicense.readAsBytes().asStream(), driverLicense.lengthSync(),
        filename: basename(driverLicense.path)));
  }
  request.headers.addAll(
      {"Content-Type": "application/json", "Accept": "application/json"});
  request.fields.addAll(requestJson);

  var response = await http.Response.fromStream(
      await request.send().timeout(const Duration(seconds: 15)));
  log(response.body);
  if (response.statusCode == HttpStatus.ok) {
    return User.fromJSON(jsonDecode(response.body)['data']);
  } else {
    print(CustomTrace(StackTrace.current, message: response.body));
    throw Exception(jsonDecode(response.body)['errors'] ?? '');
  }
}

Future<User> profileUpdate(String name, String email, String phone,
    {String? password}) async {
  var response = await http
      .post(Helper.getUri('profile'),
          headers: <String, String>{
            'Accept': 'application/json',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'name': name,
            'email': email,
            'phone': phone,
            'password': password
          }))
      .timeout(const Duration(seconds: 15));

  if (response.statusCode == HttpStatus.ok) {
    return User.fromJSON(jsonDecode(response.body)['data']);
  } else {
    print(CustomTrace(StackTrace.current, message: response.body));
    throw Exception(jsonDecode(response.body)['errors'] ?? '');
  }
}

Future<User> profilePictureUpload(File image) async {
  final fileBytes = base64Encode(await image.readAsBytesSync());
  var response = await http
      .post(Helper.getUri('profile/picture'),
          headers: <String, String>{
            'Accept': 'application/json',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{'image': fileBytes}))
      .timeout(const Duration(seconds: 15));
  if (response.statusCode == HttpStatus.ok) {
    return User.fromJSON(jsonDecode(response.body)['data']);
  } else {
    print(CustomTrace(StackTrace.current, message: response.body));
    throw Exception(jsonDecode(response.body)['errors'] ?? '');
  }
}

Future<Map<String, double>> loadValues() async {
  var response = await http
      .get(Helper.getUri('driver/rides/values'), headers: <String, String>{
    'Accept': 'application/json',
    'Content-Type': 'application/json; charset=UTF-8',
  }).timeout(const Duration(seconds: 15));

  if (response.statusCode == HttpStatus.ok) {
    var values = jsonDecode(response.body)['data'];
    return {
      'today':
          values['today'] != null ? double.tryParse(values['today']) ?? 0 : 0,
      'yesterday': values['yesterday'] != null
          ? double.tryParse(values['yesterday']) ?? 0
          : 0,
      'week': values['week'] != null ? double.tryParse(values['week']) ?? 0 : 0,
      'pending': values['pending'] != null
          ? double.tryParse(values['pending']) ?? 0
          : 0,
    };
  } else {
    print(CustomTrace(StackTrace.current, message: response.body));
    throw Exception(response.statusCode);
  }
}

Future<bool> getRideActive() async {
  var response =
      await http.get(Helper.getUri('active'), headers: <String, String>{
    'Accept': 'application/json',
    'Content-Type': 'application/json; charset=UTF-8',
  }).timeout(const Duration(seconds: 15));

  if (response.statusCode == HttpStatus.ok) {
    return jsonDecode(response.body)['data']['active'] ?? false;
  } else {
    print(CustomTrace(StackTrace.current, message: response.body));
    throw Exception(response.statusCode);
  }
}

Future<bool> updateRideActive(bool active) async {
  var response = await http
      .patch(Helper.getUri('active'),
          headers: <String, String>{
            'Accept': 'application/json',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{'active': active}))
      .timeout(const Duration(seconds: 15));
  if (response.statusCode == HttpStatus.ok) {
    return jsonDecode(response.body)['data']['active'] ?? false;
  } else {
    print(CustomTrace(StackTrace.current, message: response.body));
    throw Exception(response.body);
  }
}

Future<void> updateLocation(LocationData location) async {
  var response = await http
      .patch(
        Helper.getUri('location'),
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'lat': location.latitude,
          'lng': location.longitude,
        }),
      )
      .timeout(
        const Duration(seconds: 15),
      );

  if (response.statusCode != HttpStatus.ok) {
    CustomTrace(StackTrace.current, message: response.body);
    throw Exception(response.statusCode);
  }
}

Future<bool> deleteAccount() async {
  var response = await http.delete(
    Helper.getUri('delete-account'),
    headers: <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json; charset=UTF-8',
    },
  ).timeout(const Duration(seconds: 15));

  if (response.statusCode == HttpStatus.ok) {
    return true;
  } else {
    print(CustomTrace(StackTrace.current, message: response.body));
    throw Exception(jsonDecode(response.body)['message'] ?? '');
  }
}
