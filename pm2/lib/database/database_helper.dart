// ignore: depend_on_referenced_packages
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  DatabaseHelper._internal();

  static DatabaseHelper get instance =>
      _databaseHelper ??= DatabaseHelper._internal();

  Database? _db;
  Database get db => _db!;

  Future<void> init() async {
    _db =
        await openDatabase('database.db', version: 1, onCreate: (db, version) {
      db.execute(
          'CREATE TABLE productos (id INTEGER PRIMARY KEY AUTOINCREMENT, nameproducto varchar(255), descripcion varchar(255), categoria varchar(255), cantidad int )');
    });
  }
}
