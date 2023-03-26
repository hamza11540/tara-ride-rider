import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class HomeMapScreen extends StatefulWidget {
  const HomeMapScreen({Key? key}) : super(key: key);

  @override
  State<HomeMapScreen> createState() => _HomeMapScreenState();
}

class _HomeMapScreenState extends State<HomeMapScreen> {
  LatLng _initialcameraposition = LatLng(
    -14.6825207,
    -49.7332467,
  );
  late GoogleMapController _controller;
  Location _location = Location();

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    _location.getLocation().then((_locationData) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(_locationData.latitude!, _locationData.longitude!),
              zoom: 16),
        ),
      );
    });
    _location.onLocationChanged.listen((l) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude!, l.longitude!), zoom: 16),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      zoomControlsEnabled: false,
      myLocationEnabled: true,
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: _initialcameraposition,
        zoom: 4.82,
      ),
    );
  }
}
