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
          'value TEXT,'
          'directionId INTEGER'
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

  // retorna el numero de filas en la tabla Scans
  getCount() async {
    final db = await database;
    final res = await db.execute('SELECT COUNT(*) FROM Scans;');
    return res;
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



}
