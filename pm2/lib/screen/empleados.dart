import 'package:flutter/material.dart';
import 'package:pm2/services/database_service.dart';
import 'package:pm2/models/task.dart';

class empleados extends StatefulWidget {
  const empleados({super.key});

  @override
  State<empleados> createState() => _EmpleadosPageState();
}

class _EmpleadosPageState extends State<empleados> {
  final DatabaseService _databaseService = DatabaseService.instance;

  // Variables para el diálogo
  // ignore: unused_field
  int? _empleadoId;
  String? _nombreEmpleado;
  String? _fechaNacimiento;
  String? _telefono;

  // Variable para la búsqueda
  // ignore: unused_field
  String _searchQuery = '';
  List<Empleado> _empleados = [];
  List<Empleado> _filteredEmpleados = [];

  @override
  void initState() {
    super.initState();
    _loadEmpleados();
  }

  void _loadEmpleados() async {
    final empleados = await _databaseService.getEmpleados();
    setState(() {
      _empleados = empleados ?? [];
      _filteredEmpleados = _empleados;
    });
  }

  void _filterEmpleados(String query) {
    final filteredEmpleados = _empleados.where((empleado) {
      final nombre = empleado.nombreEmpleado.toLowerCase();
      final fecha = empleado.fechaNacempleado.toLowerCase();
      final telefono = empleado.telefonoempleado.toLowerCase();
      final searchQuery = query.toLowerCase();

      return nombre.contains(searchQuery) ||
          fecha.contains(searchQuery) ||
          telefono.contains(searchQuery);
    }).toList();

    setState(() {
      _filteredEmpleados = filteredEmpleados;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Empleados'),
      ),
      floatingActionButton: _addEmpleadoButton(),
      body: Column(
        children: [
          _searchBar(),
          Expanded(child: _empleadoList()),
        ],
      ),
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Buscar por nombre, fecha de nacimiento o teléfono',
        ),
        onChanged: (query) {
          _searchQuery = query;
          _filterEmpleados(query);
        },
      ),
    );
  }

  Widget _addEmpleadoButton() {
    return FloatingActionButton(
      onPressed: () {
        _showEmpleadoDialog();
      },
      child: const Icon(
        Icons.add,
      ),
    );
  }

  void _showEmpleadoDialog({Empleado? empleado}) {
    if (empleado != null) {
      _empleadoId = empleado.id;
      _nombreEmpleado = empleado.nombreEmpleado;
      _fechaNacimiento = empleado.fechaNacempleado;
      _telefono = empleado.telefonoempleado;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title:
            Text(empleado == null ? 'Agregar Empleado' : 'Actualizar Empleado'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              onChanged: (value) {
                _nombreEmpleado = value;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Ingrese nombre del empleado',
              ),
              controller: TextEditingController(text: _nombreEmpleado),
            ),
            TextField(
              onChanged: (value) {
                _fechaNacimiento = value;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Ingrese la fecha de nacimiento',
              ),
              controller: TextEditingController(text: _fechaNacimiento),
            ),
            TextField(
              onChanged: (value) {
                _telefono = value;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Ingrese el teléfono',
              ),
              controller: TextEditingController(text: _telefono),
            ),
            MaterialButton(
              color: Theme.of(context).colorScheme.primary,
              onPressed: () {
                if (_nombreEmpleado == null || _nombreEmpleado!.isEmpty) return;
                if (_fechaNacimiento == null || _fechaNacimiento!.isEmpty)
                  return;
                if (_telefono == null || _telefono!.isEmpty) return;

                if (empleado == null) {
                  _databaseService.addEmpleado(
                    _nombreEmpleado!,
                    _fechaNacimiento!,
                    _telefono!,
                  );
                } else {
                  _databaseService.updateEmpleado(
                    empleado.id,
                    _nombreEmpleado!,
                    _fechaNacimiento!,
                    _telefono!,
                  );
                }

                _loadEmpleados(); // Refresh the employee list

                setState(() {
                  _empleadoId = null;
                  _nombreEmpleado = null;
                  _fechaNacimiento = null;
                  _telefono = null;
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
    ).then((_) {
      setState(() {
        _empleadoId = null;
        _nombreEmpleado = null;
        _fechaNacimiento = null;
        _telefono = null;
      });
    });
  }

  Widget _empleadoList() {
    return ListView.builder(
      itemCount: _filteredEmpleados.length,
      itemBuilder: (context, index) {
        Empleado empleado = _filteredEmpleados[index];
        return GestureDetector(
          onLongPress: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Eliminar empleado'),
                  content: Text(
                      '¿Estás seguro de que deseas eliminar este empleado?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () {
                        _databaseService.deleteEmpleado(empleado.id);
                        _loadEmpleados(); // Refresh the employee list
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
            _showEmpleadoDialog(empleado: empleado);
          },
          child: Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    child: Icon(Icons.person),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              empleado.nombreEmpleado,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.0),
                        Text(
                            'Fecha de Nacimiento: ${empleado.fechaNacempleado}'),
                        SizedBox(height: 8.0),
                        Text('Teléfono: ${empleado.telefonoempleado}'),
                      ],
                    ),
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
