import 'dart:async';
import 'package:geolocator/geolocator.dart' as Geolocator;
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scanner_direccions/src/bloc/my_position/my_position_bloc.dart';
import 'package:scanner_direccions/src/models/DirectionModel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MapPage extends StatefulWidget {
  // Set<Marker> markers = new Set<Marker>();
  Future<List<DirectionModel>> directions;
  // MapPage(this.markers);
  MapPage(this.directions);
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _controller = Completer();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Set<Marker> markers = new Set<Marker>();
  _MapPageState();

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

  reCalculateLatLong() async {
    var res = await widget.directions;
    res.asMap().forEach((key, value) async {
      var response = await Geocoder.local.findAddressesFromQuery(value.value);
      setState(() {
        markers.add(new Marker(
            infoWindow:
                InfoWindow(title: value.id.toString(), snippet: value.value),
            markerId: MarkerId(value.id.toString()),
            position: LatLng(response.first.coordinates.latitude,
                response.first.coordinates.longitude)));
      });
    });

    // Geolocator.ge

    // var currentLocation = await Geolocator.
    setState(() {
      markers.add(new Marker(
          infoWindow: InfoWindow(title: "My current position"),
          markerId: MarkerId("current_user_position"),
          position: LatLng(
              51.495924, -0.063451) // todo: aqui cambiar mi current position
          ));
    });

    // widget.direc.asMap().forEach((key, value) async {
    //   var response = await Geocoder.local.findAddressesFromQuery(value);
    //   setState(() {
    //     markers.add(new Marker(
    //         markerId: MarkerId(key.toString()),
    //         position: LatLng(response.first.coordinates.latitude,
    //             response.first.coordinates.longitude)));
    //   });
    // });
  }

  @override
  void initState() {
    reCalculateLatLong();
    context.read<MyPositionBloc>().iniciarSeguimiento();
    super.initState();
  }

  @override
  void dispose() {
    context?.read<MyPositionBloc>()?.cancelarSeguimiento();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Mapa Direccion"),
      ),
      body: GoogleMap(
        mapToolbarEnabled:
            true, // todo: testear con mas direciones para ver si se habren todas en gogole maps
        zoomControlsEnabled: false,
        myLocationButtonEnabled: true,
        mapType: MapType.normal,
        markers: markers,
        initialCameraPosition: initialPoint,
        myLocationEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.gps_fixed_outlined),
      //   onPressed: () {},
      // ),
    );
  }
}
