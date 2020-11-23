import 'dart:async';

import 'package:scanner_direccions/src/models/DirectionModel.dart';
import 'package:scanner_direccions/src/providers/db_provider.dart';

class DirectionsBloc {
  static final DirectionsBloc _singleton = new DirectionsBloc._internal();

  factory DirectionsBloc() {
    return _singleton;
  }

  DirectionsBloc._internal() {
    // get Directions of Database
    getAllDirections();
  }

  final _directionController =
      StreamController<List<DirectionModel>>.broadcast();

  Stream<List<DirectionModel>> get directionStream =>
      _directionController.stream;

  dispose() {
    _directionController?.close();
  }

  getAllDirections() async {
    _directionController.sink.add(await DBProvider.db.getAllDirections());
  }

  createDirection(DirectionModel model) async {
    await DBProvider.db.createDirection(model);
    getAllDirections();
  }

  updateDirection(DirectionModel model) async {
    await DBProvider.db.updateScan(model);
    getAllDirections();
  }

  deleteDirection(int id) async {
    await DBProvider.db.deleteScan(id);
    getAllDirections();
  }

  deleteAllDirections() async {
    await DBProvider.db.deleteAllScan();
    getAllDirections();
  }
}
