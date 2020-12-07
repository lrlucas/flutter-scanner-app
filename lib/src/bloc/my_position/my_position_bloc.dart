

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart' as Geolocator;
// import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:meta/meta.dart';

part 'my_position_event.dart';
part 'my_position_state.dart';


class MyPositionBloc extends Bloc<MyPositionEvent, MyPositionState> {

  MyPositionBloc() : super (MyPositionState());

  // final _geoLocator = new Geolocator();
  StreamSubscription<Geolocator.Position> _positionSubcription;

  @override
  Stream<MyPositionState> mapEventToState(MyPositionEvent event) async* {

    if (event is OnUbicacionCambio) {
      print(event);
      yield state.copyWith(
        existeUbicacion: true,
        ubicacion: event.ubicacion
      );
    }

  }


  void iniciarSeguimiento() {

    _positionSubcription = Geolocator.Geolocator.getPositionStream(
      desiredAccuracy: Geolocator.LocationAccuracy.best,
      distanceFilter: 10
    ).listen((Geolocator.Position position) {

      final nuevaLocation = new LatLng(position.latitude, position.longitude);
      add(OnUbicacionCambio(nuevaLocation));

    });

  }

  void cancelarSeguimiento() {
    print("se cancelo");
    _positionSubcription?.cancel();
  }


}