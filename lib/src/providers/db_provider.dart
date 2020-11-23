import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scanner_direccions/src/models/DirectionModel.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentDirectory.path, 'ScansDB.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Scans ('
          'id INTEGER PRIMARY KEY AUTOINCREMENT,'
          'value TEXT'
          ')');
    });
  }

  // create
  createDirection(DirectionModel model) async {
    final db = await database;
    final res = await db.insert('Scans', model.toJson());
    return res;
  }

  // get By id
  Future<DirectionModel> getDirectionById(int id) async {
    final db = await database;
    final res = await db.query('Scans', where: 'id = ?', whereArgs: [id]);
    return res.isNotEmpty ? DirectionModel.fromJson(res.first) : null;
  }

  // GetAll
  Future<List<DirectionModel>> getAllDirections() async {
    final db = await database;
    final res = await db.query('Scans');
    List<DirectionModel> list = res.isNotEmpty
        ? res.map((d) => DirectionModel.fromJson(d)).toList()
        : [];
    return list;
  }

  // actualizar registro
  Future<int> updateScan(DirectionModel newDirection) async {
    final db = await database;
    final res = await db.update('Scans', newDirection.toJson(),
        where: 'id = ?', whereArgs: [newDirection.id]);
    return res;
  }

  // eliminar scan
  Future<int> deleteScan(int id) async {
    final db = await database;
    final res = await db.delete('Scans', where: 'id = ?', whereArgs: [id]);
    return res;
  }

  // delete All Scans
  Future<int> deleteAllScan() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM Scans');
    return res;
  }

  /*


    
    TODO: usar Markers de google maps para pasar una lista de direciones lat lon
          usa la api de reverse geoapi para obtener la lat y long en base a una
          direccion y esas lat y long mandarlo a la los markers de google maps

    TODO: al abrir el mapa con todas las direcciones talvez sea necesario un servicio de terceros
      para obtener las coordenadas y luego recien con las coordenads abrir el mapa con
      los marcadores
  *
  * TODO: desde Home tengo que mandar a mostrar en el mapa todas las direcciones scaneadas
  *
  *
  * TODO: revisar una UI mas intuitiva
  *
    TODO: revisar integracion con google maps o otro servicio de mapas
  *
  *
  * */

}
