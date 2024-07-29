import 'package:pm2/models/task.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();

  //Tabla de productos
  final String _tasksTableName = "tasks";
  final String _tasksIdColumnName = "idproducto";
  final String _nombreproducto = "nombreproducto";
  final String _decripcion = "descripcion";
  final String _categoria = "categoria";
  final String _cantidad = "cantidad";

  //Tabla de usuarios
  final String _loginTable = "login";
  final String _idLogin = "idlogin";
  final String _nombreusuario = "nombreusuario";
  final String _password = "password";

  //Tabla proveedores
  final String _proveedoresTable = "proveedores";
  final String _idProveedores = "idproveedores";
  final String _nombreprove = "nombreproveedores";
  final String _direccion = "direccion";
  final String _telefono = "telefono";

  //Tabla ordenes

  final String _ordenesTable = "ordenes";
  final String _idOrdenes = "idordenes";
  final String _nombreorden = "nombreorden";
  final String _direccionorden = "direccionorden";
  final String _fechaorden = "fechaorden";

  //Tabla Clientes
  final String _clientesTable = "clientes";
  final String _idclientes = "idclientes";
  final String _nombrecliente = "nombrecliente";
  final String _direccioncliente = "direccioncliente";
  final String _emailcliente = "emailcliente";
  final String _telefonocliente = "telefonocliente";

  //Tabla Empleados
  final String _empleadoTable = "empleados";
  final String _idempleado = "idempleado";
  final String _nombreempleado = "nombreempleado";
  final String _fechaenacmpleado = "fechaempleado";
  final String _telefonoempleado = "telefonoempleado";

  /*
  //insert en la tabla usuario
  final String _usuario = "prueba";
  final String _usuariopassword = "123";
  */

  DatabaseService._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "master_db.db");
    /*
    await deleteDatabase(databasePath);
*/
    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) async {
        db.execute('''
        CREATE TABLE $_tasksTableName (
          $_tasksIdColumnName INTEGER PRIMARY KEY AUTOINCREMENT,
          $_nombreproducto TEXT NOT NULL,
          $_decripcion TEXT NOT NULL,
          $_categoria TEXT NOT NULL,
          $_cantidad INTEGER NOT NULL
        )
        ''');
        db.execute('''
        CREATE TABLE $_loginTable (
          $_idLogin INTEGER PRIMARY KEY AUTOINCREMENT,
          $_nombreusuario TEXT NOT NULL,
          $_password TEXT NOT NULL
        )
        ''');
        // Inserción de datos de prueba
        await db.insert(_loginTable, {
          _nombreusuario: 'admin',
          _password: 'admin123',
        });
        db.execute('''
        CREATE TABLE $_proveedoresTable (
          $_idProveedores INTEGER PRIMARY KEY AUTOINCREMENT,
          $_nombreprove TEXT NOT NULL,
          $_direccion TEXT NOT NULL,
          $_telefono TEXT NOT NULL
        )
        ''');
        db.execute('''
        CREATE TABLE $_ordenesTable (
          $_idOrdenes INTEGER PRIMARY KEY AUTOINCREMENT,
          $_nombreorden TEXT NOT NULL,
          $_direccionorden TEXT NOT NULL,
          $_fechaorden TEXT NOT NULL
        )
        ''');
        db.execute('''
        CREATE TABLE $_clientesTable (
          $_idclientes INTEGER PRIMARY KEY AUTOINCREMENT,
          $_nombrecliente TEXT NOT NULL,
          $_direccioncliente TEXT NOT NULL,
          $_emailcliente TEXT NOT NULL,
          $_telefonocliente TEXT NOT NULL
        )
        ''');
        db.execute('''
        CREATE TABLE $_empleadoTable (
          $_idempleado INTEGER PRIMARY KEY AUTOINCREMENT,
          $_nombreempleado TEXT NOT NULL,
          $_fechaenacmpleado TEXT NOT NULL,
          $_telefonoempleado TEXT NOT NULL
        )
        ''');
      },
    );
    return database;
  }

  //autentificar usuario

  Future<bool> authenticateUser(String username, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _loginTable,
      where: '$_nombreusuario = ? AND $_password = ?',
      whereArgs: [username, password],
    );

    return maps.isNotEmpty;
  }

  //fin autentificar usuario

  //metodos produtco

  void addTask(
    String nombreproducto,
    String descripcion,
    String categoria,
    dynamic cantidad,
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
            id: e[_tasksIdColumnName] as int,
            nombreproducto: e["nombreproducto"] as String,
            descripcion: e["descripcion"] as String,
            categoria: e["categoria"] as String,
            cantidad: e["cantidad"] as int))
        .toList();
    return tasks;
  }

  Future<void> updateTask(
      int id, String nombrep, descripcion, categoria, cantidad) async {
    final db = await database;
    await db.update(
      _tasksTableName,
      {
        _nombreproducto: nombrep,
        _decripcion: descripcion,
        _categoria: categoria,
        _cantidad: cantidad
      },
      where: '$_tasksIdColumnName = ?',
      whereArgs: [
        id,
      ],
    );
  }

  void deleteTask(int id) async {
    final db = await database;
    await db
        .delete(_tasksTableName, where: '$_tasksIdColumnName = ?', whereArgs: [
      id,
    ]);
  }

  //fin metodos producto

  //Inicio metodo proveedor
  void addProveedor(
    String nombreProveedor,
    String direccionProveedor,
    String telefonoProveedor,
  ) async {
    final db = await database;
    await db.insert(
      _proveedoresTable,
      {
        _nombreprove: nombreProveedor,
        _direccion: direccionProveedor,
        _telefono: telefonoProveedor,
      },
    );
  }

  Future<List<Proveedores>?> getProveedores() async {
    final db = await database;
    final proveedores = await db.query(_proveedoresTable);
    List<Proveedores> proveedorList = proveedores
        .map((e) => Proveedores(
              idproveedores: e[_idProveedores] as int,
              nombreprov: e[_nombreprove] as String,
              direccionprov: e[_direccion] as String,
              telefonoprov: e[_telefono] as String,
            ))
        .toList();
    return proveedorList;
  }

  Future<void> updateProveedor(int id, String nombreProveedor,
      String direccionProveedor, String telefonoProveedor) async {
    final db = await database;
    await db.update(
      _proveedoresTable,
      {
        _nombreprove: nombreProveedor,
        _direccion: direccionProveedor,
        _telefono: telefonoProveedor,
      },
      where: '$_idProveedores = ?',
      whereArgs: [id],
    );
  }

  void deleteProveedor(int id) async {
    final db = await database;
    await db.delete(
      _proveedoresTable,
      where: '$_idProveedores = ?',
      whereArgs: [id],
    );
  }
  //Fin metodo proveedor

  //Metodo Ordenes
  Future<void> addOrden(
    String nombre,
    String direccion,
    String fecha,
  ) async {
    final db = await database;
    await db.insert(
      _ordenesTable,
      {
        _nombreorden: nombre,
        _direccionorden: direccion,
        _fechaorden: fecha,
      },
    );
  }

  // Método para obtener la lista de órdenes
  Future<List<Ordenes>?> getOrdenes() async {
    final db = await database;
    final data = await db.query(_ordenesTable);
    List<Ordenes> ordenes = data
        .map((e) => Ordenes(
              id: e[_idOrdenes] as dynamic,
              nombre: e[_nombreorden] as String,
              direccion: e[_direccionorden] as String,
              fecha: e[_fechaorden] as String,
            ))
        .toList();
    return ordenes;
  }

  // Método para actualizar una orden
  Future<void> updateOrden(
    int id,
    String nombre,
    String direccion,
    String fecha,
  ) async {
    final db = await database;
    await db.update(
      _ordenesTable,
      {
        _nombreorden: nombre,
        _direccionorden: direccion,
        _fechaorden: fecha,
      },
      where: '$_idOrdenes = ?',
      whereArgs: [id],
    );
  }

  // Método para eliminar una orden
  Future<void> deleteOrden(int id) async {
    final db = await database;
    await db.delete(
      _ordenesTable,
      where: '$_idOrdenes = ?',
      whereArgs: [id],
    );
  }
  //Fin metodo ordnes

  //Metodo Cliente
  // Método para agregar un cliente
  Future<void> addCliente(
    String nombreCliente,
    String direccion,
    String email,
    String telefono,
  ) async {
    final db = await database;
    await db.insert(
      _clientesTable,
      {
        _nombrecliente: nombreCliente,
        _direccioncliente: direccion,
        _emailcliente: email,
        _telefonocliente: telefono,
      },
    );
  }

  // Método para obtener la lista de clientes
  Future<List<Cliente>?> getClientes() async {
    final db = await database;
    final data = await db.query(_clientesTable);
    List<Cliente> clientes = data
        .map((e) => Cliente(
              id: e[_idclientes] as int,
              nombreCliente: e[_nombrecliente] as String,
              direccionCliente: e[_direccioncliente] as String,
              emailCliente: e[_emailcliente] as String,
              telefonoCliente: e[_telefonocliente] as String,
            ))
        .toList();
    return clientes;
  }

  // Método para actualizar un cliente
  Future<void> updateCliente(
    int id,
    String nombreCliente,
    String direccion,
    String email,
    String telefono,
  ) async {
    final db = await database;
    await db.update(
      _clientesTable,
      {
        _nombrecliente: nombreCliente,
        _direccioncliente: direccion,
        _emailcliente: email,
        _telefonocliente: telefono,
      },
      where: '$_idclientes = ?',
      whereArgs: [id],
    );
  }

  // Método para eliminar un cliente
  Future<void> deleteCliente(int id) async {
    final db = await database;
    await db.delete(
      _clientesTable,
      where: '$_idclientes = ?',
      whereArgs: [id],
    );
  }
  //Fin metodo Cliente

  //Metodo empleado
  Future<void> addEmpleado(
    String nombreEmpleado,
    String fechaNacimiento,
    String telefono,
  ) async {
    final db = await database;
    await db.insert(
      _empleadoTable,
      {
        _nombreempleado: nombreEmpleado,
        _fechaenacmpleado: fechaNacimiento,
        _telefonoempleado: telefono,
      },
    );
  }

  // Método para obtener la lista de empleados
  Future<List<Empleado>?> getEmpleados() async {
    final db = await database;
    final data = await db.query(_empleadoTable);
    List<Empleado> empleados = data
        .map((e) => Empleado(
              id: e[_idempleado] as int,
              nombreEmpleado: e[_nombreempleado] as String,
              fechaNacempleado: e[_fechaenacmpleado] as String,
              telefonoempleado: e[_telefonoempleado] as String,
            ))
        .toList();
    return empleados;
  }

  // Método para actualizar un empleado
  Future<void> updateEmpleado(
    int id,
    String nombreEmpleado,
    String fechaNacimiento,
    String telefono,
  ) async {
    final db = await database;
    await db.update(
      _empleadoTable,
      {
        _nombreempleado: nombreEmpleado,
        _fechaenacmpleado: fechaNacimiento,
        _telefonoempleado: telefono,
      },
      where: '$_idempleado = ?',
      whereArgs: [
        id,
      ],
    );
  }

  // Método para eliminar un empleado
  Future<void> deleteEmpleado(int id) async {
    final db = await database;
    await db.delete(
      _empleadoTable,
      where: '$_idempleado = ?',
      whereArgs: [
        id,
      ],
    );
  }

  //Fin metodo empleado
}
