import 'package:flutter/material.dart';
import 'package:pm2/services/database_service.dart';
import 'package:pm2/models/task.dart';

class productos extends StatefulWidget {
  const productos({super.key});

  @override
  State<productos> createState() => _ProductosState();
}

class _ProductosState extends State<productos> {
  final DatabaseService _databaseService = DatabaseService.instance;
  // ignore: unused_field
  int? _task;
  String? _nombreProducto;
  String? _descripcion;
  String? _categoria;
  dynamic _cantidad;
  // ignore: unused_field
  String _searchQuery = '';
  List<Task> _productos = [];
  List<Task> _filteredProductos = [];

  @override
  void initState() {
    super.initState();
    _loadProducto();
  }

  void _loadProducto() async {
    final productos = await _databaseService.getTask();
    setState(() {
      _productos = productos ?? [];
      _filteredProductos = _productos;
    });
  }

  void _filterProductos(String query) {
    final filteredProductos = _productos.where((producto) {
      final nombre = producto.nombreproducto.toLowerCase();
      final descripcion = producto.descripcion.toLowerCase();
      final categoria = producto.categoria.toLowerCase();
      final cantidad = producto.cantidad.toString().toLowerCase();
      final searchQuery = query.toLowerCase();

      return nombre.contains(searchQuery) ||
          descripcion.contains(searchQuery) ||
          categoria.contains(searchQuery) ||
          cantidad.contains(searchQuery);
    }).toList();

    setState(() {
      _filteredProductos = filteredProductos;
    });
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Buscar por nombre, descripción, categoría o cantidad',
          prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
          filled: true,
          fillColor: Colors.white.withOpacity(0.9),
        ),
        onChanged: (query) {
          _searchQuery = query;
          _filterProductos(query);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
        titleTextStyle: TextStyle(color: Colors.white,
        fontSize: 20,
      ),
        backgroundColor: Colors.blueAccent,
      ),
      floatingActionButton: _addTaskButton(),
      body: Column(
        children: [
          _searchBar(),
          Expanded(child: _taskList()),
        ],
      ),
    );
  }

  Widget _addTaskButton() {
    return FloatingActionButton(
      onPressed: () {
        _showTaskDialog();
      },
      backgroundColor: Colors.blueAccent,
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }

  void _showTaskDialog({Task? task}) {
    if (task != null) {
      _task = task.id;
      _nombreProducto = task.nombreproducto;
      _descripcion = task.descripcion;
      _categoria = task.categoria;
      _cantidad = task.cantidad;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(task == null ? 'Agregar Producto' : 'Actualizar Producto'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  _nombreProducto = value;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Ingrese nombre del producto',
                ),
                controller: TextEditingController(text: _nombreProducto),
              ),
              SizedBox(height: 8.0),
              TextField(
                onChanged: (value) {
                  _descripcion = value;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Ingrese la descripción',
                ),
                controller: TextEditingController(text: _descripcion),
              ),
              SizedBox(height: 8.0),
              TextField(
                onChanged: (value) {
                  _categoria = value;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Ingrese la categoría',
                ),
                controller: TextEditingController(text: _categoria),
              ),
              SizedBox(height: 8.0),
              TextField(
                onChanged: (value) {
                  _cantidad = value;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Ingrese la cantidad',
                ),
                controller: TextEditingController(text: _cantidad?.toString()),
              ),
              SizedBox(height: 16.0),
              MaterialButton(
                color: Colors.blueAccent,
                onPressed: () {
                  if (_nombreProducto == null || _nombreProducto!.isEmpty) return;
                  if (_descripcion == null || _descripcion!.isEmpty) return;
                  if (_categoria == null || _categoria!.isEmpty) return;
                  if (_cantidad == null) return;

                  if (task == null) {
                    _databaseService.addTask(
                        _nombreProducto!, _descripcion!, _categoria!, _cantidad!);
                  } else {
                    _databaseService.updateTask(task.id, _nombreProducto!,
                        _descripcion!, _categoria!, _cantidad!);
                  }

                  _loadProducto();

                  setState(() {
                    _task = null;
                    _nombreProducto = null;
                    _descripcion = null;
                    _categoria = null;
                    _cantidad = null;
                  });

                  Navigator.pop(context);
                },
                child: const Text(
                  "Hecho",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).then((_) {
      setState(() {
        _task = null;
        _nombreProducto = null;
        _descripcion = null;
        _categoria = null;
        _cantidad = null;
      });
    });
  }

  Widget _taskList() {
    return ListView.builder(
      itemCount: _filteredProductos.length,
      itemBuilder: (context, index) {
        Task task = _filteredProductos[index];
        return GestureDetector(
          onLongPress: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Eliminar producto'),
                  content: Text('¿Estás seguro de que deseas eliminar este producto?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () {
                        _databaseService.deleteTask(task.id);
                        _loadProducto();
                        Navigator.of(context).pop();
                      },
                      child: Text('Eliminar'),
                    ),
                  ],
                );
              },
            );
          },
          onTap: () {
            _showTaskDialog(task: task);
          },
          child: Card(
            margin: EdgeInsets.all(10),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 50.0,
                    height: 50.0,
                    color: Colors.blueAccent,
                    margin: EdgeInsets.only(right: 16.0),
                    child: Center(
                      child: Icon(
                        Icons.production_quantity_limits,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              task.nombreproducto,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.0),
                        Text(task.descripcion),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text('Categoría: ${task.categoria}'),
                      SizedBox(height: 8.0),
                      Text('Cantidad: ${task.cantidad}'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
