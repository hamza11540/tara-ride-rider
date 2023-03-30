import 'package:driver_app/src/models/rating_model.dart';
import 'package:driver_app/src/models/ride.dart';
import 'package:driver_app/src/models/status_enum.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../helper/custom_trace.dart';
import '../services/ride_service.dart';

class RideController extends ControllerMVC {
  bool updatingStatus = false;
  bool loading = false;
  bool hasMoreRides = false;
  List<Ride> rides = [];
  Ride? ride;


  Future<List<Ride>> doGetRides(
      {int? pageSize,
      DateTime? dateTimeStart,
      DateTime? dateTimeEnd,
      List<StatusEnum>? status}) async {
    setState(() => loading = true);
    Map<String, dynamic> response = await getRides(
            pageSize: pageSize,
            currentItem: rides.length,
            dateTimeStart: dateTimeStart,
            dateTimeEnd: dateTimeEnd,
            status: status)
        .catchError((error) {
      print(CustomTrace(StackTrace.current, message: error.toString()));
      throw 'Erro ao buscar pedidos';
    }).whenComplete(() => setState(() => loading = false));
    List<Ride> _rides = response['rides'];
    setState(() {
      hasMoreRides = response['hasMoreRides'];
      if (pageSize == null) {
        rides = _rides;
      } else {
        rides.addAll(_rides);
      }
      loading = false;
    });
    return _rides;
  }

  Future<Ride> doGetRide(String rideId) async {
    setState(() {
      loading = true;
      ride = null;
    });
    Ride _ride = await getRide(rideId).catchError((error) {
      print(CustomTrace(StackTrace.current, message: error.toString()));
      throw 'Erro ao buscar pedido, tente novamente';
    }).whenComplete(() => setState(() => loading = false));
    setState(() {
      ride = _ride;
      loading = false;
    });
    return _ride;
  }



  Future<List<Ride>> doCheckNewRide() async {
    setState(() => loading = true);
    List<Ride> _rides = await checkNewRide(
            lastRide: rides.isEmpty
                ? "0"
                : rides
                    .reduce((value, element) =>
                        double.parse(value.id) > double.parse(element.id)
                            ? value
                            : element)
                    .id)
        .catchError((error) {
      print(CustomTrace(StackTrace.current, message: error.toString()));
      throw 'Erro ao buscar pedidos';
    }).whenComplete(() => setState(() => loading = false));
    if (_rides.isNotEmpty) {
      setState(() {
        rides.insertAll(0, _rides);
      });
    }
    setState(() => loading = false);
    return _rides;
  }

  Future<Ride> doUpdateRideStatus(
      String rideId, StatusEnum status, String? addressId) async {
    setState(() {
      loading = true;
    });
    Ride _ride =
        await updateRideStatus(rideId, status, addressId).catchError((error) {
      print(CustomTrace(StackTrace.current, message: error.toString()));
      throw 'Erro ao atualizar pedido, tente novamente';
    }).whenComplete(() => setState(() => loading = false));
    setState(() {
      ride = _ride;
      loading = false;
    });
    return _ride;
  }
}
