import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../helper/custom_trace.dart';
import '../helper/helper.dart';
import '../models/ride.dart';
import '../models/status_enum.dart';

Future<Map<String, dynamic>> getRides(
    {int? pageSize,
    int currentItem = 0,
    DateTime? dateTimeStart,
    DateTime? dateTimeEnd,
    List<StatusEnum>? status}) async {
  Map<String, dynamic> queryParameters = {};
  if (pageSize != null) {
    queryParameters.addAll(
        {'limit': pageSize.toString(), 'current_item': currentItem.toString()});
  }
  if (dateTimeStart != null) {
    queryParameters.addAll({
      'datetime_start': dateTimeStart.toString(),
    });
  }
  if (dateTimeEnd != null) {
    queryParameters.addAll({'datetime_end': dateTimeEnd.toString()});
  }
  if (status != null) {
    queryParameters.addAll(
        {'status[]': status.map((status) => status.originalName).toList()});
  }
  var response = await http.get(
      Helper.getUri('driver/rides', queryParam: queryParameters),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
      }).timeout(const Duration(seconds: 15));
  if (response.statusCode == HttpStatus.ok) {
    List<Ride> rides = jsonDecode(response.body)['data']['rides']
        .map((ride) => Ride.fromJSON(ride))
        .toList()
        .cast<Ride>();
    bool hasMoreRides = jsonDecode(response.body)['data']['has_more_rides'];

    return {'hasMoreRides': hasMoreRides, 'rides': rides};
  } else {
    CustomTrace(StackTrace.current, message: response.body);
    throw Exception(response.statusCode);
  }
}

Future<List<Ride>> checkNewRide({required String lastRide}) async {
  Map<String, String> queryParameters = {};
  queryParameters.addAll({'ride_id': lastRide});
  var response = await http.get(
      Helper.getUri('driver/checkNewRide', queryParam: queryParameters),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
      }).timeout(const Duration(seconds: 15));
  if (response.statusCode == HttpStatus.ok) {
    return jsonDecode(response.body)['data']
        .map((ride) => Ride.fromJSON(ride))
        .toList()
        .cast<Ride>();
  } else {
    CustomTrace(StackTrace.current, message: response.body);
    throw Exception(response.statusCode);
  }
}

Future<Ride> getRide(String rideId) async {
  var response = await http
      .get(Helper.getUri('driver/rides/$rideId'), headers: <String, String>{
    'Accept': 'application/json',
    'Content-Type': 'application/json; charset=UTF-8',
  }).timeout(const Duration(seconds: 15));
  print(response.request!.url.toString());
  if (response.statusCode == HttpStatus.ok) {
    return Ride.fromJSON(json.decode(response.body)['data']);
  } else {
    CustomTrace(StackTrace.current, message: response.body);
    throw Exception(response.statusCode);
  }
}

Future<Ride> updateRideStatus(
    String rideId, StatusEnum status, String? addressId) async {
  var response = await http
      .patch(
        Helper.getUri('driver/updateStatus'),
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'ride_id': rideId,
          'status': status.originalName,
          'ride_address_id': addressId ?? '',
        }),
      )
      .timeout(const Duration(seconds: 15));
  print(response.body);
  if (response.statusCode == HttpStatus.ok) {
    return Ride.fromJSON(json.decode(response.body)['data']);
  } else {
    CustomTrace(StackTrace.current, message: response.body);
    throw Exception(response.statusCode);
  }
}

Future<bool> transferRide(String rideId, String? novoEntregadorId) async {
  var response = await http
      .post(
        Helper.getUri('driver/ride/transferRide'),
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'ride_id': rideId,
          'novo_entregador_id': novoEntregadorId ?? '',
        }),
      )
      .timeout(const Duration(seconds: 15));

  if (response.statusCode == HttpStatus.ok) {
    print(response.body);
    return true;
  } else {
    CustomTrace(StackTrace.current, message: response.body);
    throw Exception(response.statusCode);
  }
}
