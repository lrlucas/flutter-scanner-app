import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  final List<String> direccions;
  MapPage(this.direccions);
  @override
  _MapPageState createState() => _MapPageState(direccions);
}

class _MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _controller = Completer();
  final List<String> address;
  Set<Marker> markers = new Set<Marker>();

  _MapPageState(this.address);

  final CameraPosition initialPoint = CameraPosition(
    target: LatLng(51.453461, -0.008410),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(51.4825575, -0.0333935),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  void calculateCoordenade(List<String> direc) async {
    direc.forEach((element) async {
      print(element);
      var response = await Geocoder.local.findAddressesFromQuery(element);
      print(
          "${response.first.coordinates.latitude} - ${response.first.coordinates.longitude}");

      markers.add(new Marker(
          markerId: MarkerId("geo-location"),
          position: LatLng(response.first.coordinates.latitude,
              response.first.coordinates.longitude)));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    calculateCoordenade(widget.direccions);
  }

  @override
  Widget build(BuildContext context) {
    //TODO: recibir una lista de markers para mostrarlos en el mapa
    //      no procesar los marcadores en la pagina de mapa
    // markers.add(new Marker(
    //     markerId: MarkerId("geo-location"),
    //     position: LatLng(51.4825575, -0.0333935)));
    // markers.add(new Marker(
    //     markerId: MarkerId("geo-location"),
    //     position: LatLng(51.4536096, -0.0082463)));

    return Scaffold(
      appBar: AppBar(
        title: Text("Mapa Direccion"),
      ),
      body: GoogleMap(
        zoomControlsEnabled: false,
        myLocationButtonEnabled: true,
        mapType: MapType.normal,
        markers: markers,
        initialCameraPosition: initialPoint,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.gps_fixed_outlined),
        onPressed: () {},
      ),
    );
  }
}
