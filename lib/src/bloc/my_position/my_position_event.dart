part of 'my_position_bloc.dart';

@immutable
abstract class MyPositionEvent{}


class OnUbicacionCambio extends MyPositionEvent {
  final LatLng ubicacion;
  OnUbicacionCambio(this.ubicacion);
}