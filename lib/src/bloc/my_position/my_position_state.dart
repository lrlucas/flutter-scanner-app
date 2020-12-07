



part of 'my_position_bloc.dart';

@immutable
class MyPositionState {
  final bool siguiendo;
  final bool existeUbicacion;
  final LatLng ubicacion;

  MyPositionState({
    this.siguiendo = true,
    this.existeUbicacion = false,
    this.ubicacion
  });

  MyPositionState copyWith({
    bool siguiendo,
    bool existeUbicacion,
    LatLng ubicacion
  }) => new MyPositionState(
      siguiendo: siguiendo ?? this.siguiendo,
      existeUbicacion: existeUbicacion ?? this.existeUbicacion,
      ubicacion: ubicacion ?? this.ubicacion
  );




}

