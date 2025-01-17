import 'package:flutter/material.dart';
import 'package:pm2/services/database_service.dart';
import 'package:pm2/models/task.dart';

class empleados extends StatefulWidget {
  const empleados({super.key});

  @override
  State<empleados> createState() => _empleadosPageState();
}

class _empleadosPageState extends State<empleados> {
  final DatabaseService _databaseService = DatabaseService.instance;

  // ignore: unused_field
  int? _empleadoId;
  String? _nombreEmpleado;
  DateTime? _fechaNacimiento;
  String? _telefono;
  final TextEditingController _fechaNacimientoController = TextEditingController();
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

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _fechaNacimiento) {
      setState(() {
        _fechaNacimiento = pickedDate;
        _fechaNacimientoController.text = '${_fechaNacimiento!.toLocal()}'.split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Empleados'),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        backgroundColor: Colors.purple,
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
          prefixIcon: Icon(Icons.search, color: Colors.purple),
          filled: true,
          fillColor: Colors.white.withOpacity(0.9),
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
      backgroundColor: Colors.purple,
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }

  void _showEmpleadoDialog({Empleado? empleado}) {
    if (empleado != null) {
      _empleadoId = empleado.id;
      _nombreEmpleado = empleado.nombreEmpleado;
      _fechaNacimiento = DateTime.tryParse(empleado.fechaNacempleado);
      _fechaNacimientoController.text = _fechaNacimiento == null ? '' : '${_fechaNacimiento!.toLocal()}'.split(' ')[0];
      _telefono = empleado.telefonoempleado;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(empleado == null ? 'Agregar Empleado' : 'Actualizar Empleado'),
        content: SingleChildScrollView(
          child: Column(
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
              SizedBox(height: 8.0),
              GestureDetector(
                onTap: _selectDate,
                child: AbsorbPointer(
                  child: TextField(
                    controller: _fechaNacimientoController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Seleccione la fecha de nacimiento',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8.0),
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
              SizedBox(height: 16.0),
              MaterialButton(
                color: Colors.purple,
                onPressed: () {
                  if (_nombreEmpleado == null || _nombreEmpleado!.isEmpty) return;
                  if (_fechaNacimiento == null) return;
                  if (_telefono == null || _telefono!.isEmpty) return;

                  if (empleado == null) {
                    _databaseService.addEmpleado(
                      _nombreEmpleado!,
                      _fechaNacimiento!.toIso8601String(),
                      _telefono!,
                    );
                  } else {
                    _databaseService.updateEmpleado(
                      empleado.id,
                      _nombreEmpleado!,
                      _fechaNacimiento!.toIso8601String(),
                      _telefono!,
                    );
                  }

                  _loadEmpleados();

                  setState(() {
                    _empleadoId = null;
                    _nombreEmpleado = null;
                    _fechaNacimiento = null;
                    _telefono = null;
                    _fechaNacimientoController.clear();
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
        _empleadoId = null;
        _nombreEmpleado = null;
        _fechaNacimiento = null;
        _telefono = null;
        _fechaNacimientoController.clear();
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
                  content: Text('¿Estás seguro de que deseas eliminar este empleado?'),
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
                        _loadEmpleados();
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
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.purple,
                    child: Icon(Icons.person, color: Colors.white),
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
                                color: Colors.purple,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.0),
                        Text('Fecha de Nacimiento: ${empleado.fechaNacempleado}'),
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