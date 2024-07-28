import 'dart:ffi';

import 'package:pm2/models/task.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();

  final String _tasksTableName = "tasks";
  final String _tasksIdColumnName = "id";
  final String _nombreproducto = "nombreproducto";
  final String _decripcion = "descripcion";
  final String _categoria = "categoria";
  final String _cantidad = "cantidad";

  DatabaseService._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "master_db.db");

    await deleteDatabase(databasePath);

    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
        CREATE TABLE $_tasksTableName (
          $_tasksIdColumnName INTEGER PRIMARY KEY AUTOINCREMENT,
          $_nombreproducto TEXT NOT NULL,
          $_decripcion TEXT NOT NULL,
          $_categoria TEXT NOT NULL,
          $_cantidad INTEGER NOT NULL
        )
        ''');
      },
    );
    return database;
  }

  void addTask(
    String nombreproducto,
    String descripcion,
    String categoria,
    String cantidad,
  ) async {
    final db = await database;
    await db.insert(
      _tasksTableName,
      {
        _nombreproducto: nombreproducto,
        _decripcion: descripcion,
        _categoria: categoria,
        _cantidad: cantidad
      },
    );
  }

  Future<List<Task>?> getTask() async {
    final db = await database;
    final data = await db.query(_tasksTableName);
    List<Task> tasks = data
        .map((e) => Task(
            id: e["id"] as int,
            nombreproducto: e["nombreproducto"] as String,
            descripcion: e["descripcion"] as String,
            categoria: e["categoria"] as String,
            cantidad: e["cantidad"] as int))
        .toList();
    return tasks;
  }
}
