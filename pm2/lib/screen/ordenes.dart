import 'package:flutter/material.dart';
import 'package:pm2/services/database_service.dart';
import 'package:pm2/models/task.dart';

class ordenes extends StatefulWidget {
  const ordenes({super.key});

  @override
  State<ordenes> createState() => _ordenesPageState();
}

class _ordenesPageState extends State<ordenes> {
  final DatabaseService _databaseService = DatabaseService.instance;
  // ignore: unused_field
  int? _ordenId;
  String? _nombre;
  String? _direccion;
  DateTime? _fecha;
  final TextEditingController _fechaController = TextEditingController();
  // ignore: unused_field
  String _searchQuery = '';
  List<Ordenes> _ordenes = [];
  List<Ordenes> _filteredOrdenes = [];

  @override
  void initState() {
    super.initState();
    _loadOrdenes();
  }

  void _loadOrdenes() async {
    final ordenes = await _databaseService.getOrdenes();
    setState(() {
      _ordenes = ordenes ?? [];
      _filteredOrdenes = _ordenes;
    });
  }

  void _filterOrdenes(String query) {
    final filteredOrdenes = _ordenes.where((ordenes) {
      final nombre = ordenes.nombre.toLowerCase();
      final direccion = ordenes.direccion.toLowerCase();
      final fecha = ordenes.fecha.toLowerCase();
      final searchQuery = query.toLowerCase();

      return nombre.contains(searchQuery) ||
          direccion.contains(searchQuery) ||
          fecha.contains(searchQuery);
    }).toList();

    setState(() {
      _filteredOrdenes = filteredOrdenes;
    });
  }

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _fecha) {
      setState(() {
        _fecha = pickedDate;
        _fechaController.text = '${_fecha!.toLocal()}'.split(' ')[0];
      });
    }
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Buscar por nombre, dirección o fecha',
          prefixIcon: Icon(Icons.search, color: Colors.green),
          filled: true,
          fillColor: Colors.white.withOpacity(0.9),
        ),
        onChanged: (query) {
          _searchQuery = query;
          _filterOrdenes(query);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Órdenes'),
        backgroundColor: Colors.green,
      ),
      floatingActionButton: _addOrdenButton(),
      body: Column(
        children: [
          _searchBar(),
          Expanded(child: _ordenList()),
        ],
      ),
    );
  }

  Widget _addOrdenButton() {
    return FloatingActionButton(
      onPressed: () {
        _showOrdenDialog();
      },
      backgroundColor: Colors.green,
      child: const Icon(Icons.add),
    );
  }

  void _showOrdenDialog({Ordenes? orden}) {
    if (orden != null) {
      _ordenId = orden.id;
      _nombre = orden.nombre;
      _direccion = orden.direccion;
      _fecha = DateTime.tryParse(orden.fecha);
      _fechaController.text = _fecha == null ? '' : '${_fecha!.toLocal()}'.split(' ')[0];
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(orden == null ? 'Agregar Orden' : 'Actualizar Orden'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  _nombre = value;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Ingrese nombre de la orden',
                ),
                controller: TextEditingController(text: _nombre),
              ),
              SizedBox(height: 8.0),
              TextField(
                onChanged: (value) {
                  _direccion = value;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Ingrese la dirección',
                ),
                controller: TextEditingController(text: _direccion),
              ),
              SizedBox(height: 8.0),
              GestureDetector(
                onTap: _selectDate,
                child: AbsorbPointer(
                  child: TextField(
                    controller: _fechaController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Seleccione la fecha',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              MaterialButton(
                color: Colors.green,
                onPressed: () {
                  if (_nombre == null || _nombre!.isEmpty) return;
                  if (_direccion == null || _direccion!.isEmpty) return;
                  if (_fecha == null) return;

                  if (orden == null) {
                    _databaseService.addOrden(
                      _nombre!,
                      _direccion!,
                      _fecha!.toIso8601String(),
                    );
                  } else {
                    _databaseService.updateOrden(
                      orden.id,
                      _nombre!,
                      _direccion!,
                      _fecha!.toIso8601String(),
                    );
                  }
                  _loadOrdenes();

                  setState(() {
                    _ordenId = null;
                    _nombre = null;
                    _direccion = null;
                    _fecha = null;
                    _fechaController.clear();
                  });

                  Navigator.pop(context);
                },
                child: const Text(
                  "Hecho",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).then((_) {
      setState(() {
        _ordenId = null;
        _nombre = null;
        _direccion = null;
        _fecha = null;
        _fechaController.clear();
      });
    });
  }

  Widget _ordenList() {
    return ListView.builder(
      itemCount: _filteredOrdenes.length,
      itemBuilder: (context, index) {
        Ordenes ordenes = _filteredOrdenes[index];
        return GestureDetector(
          onLongPress: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Eliminar orden'),
                  content: Text(
                      '¿Estás seguro de que deseas eliminar esta orden?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () {
                        _databaseService.deleteOrden(ordenes.id);
                        _loadOrdenes(); // Refresh the order list
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
            _showOrdenDialog(orden: ordenes);
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
                    color: Colors.green,
                    margin: EdgeInsets.only(right: 16.0),
                    child: Center(
                      child: Icon(Icons.shopping_cart, color: Colors.white),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          ordenes.nombre,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Dirección: ${ordenes.direccion}',
                          style: TextStyle(
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Fecha: ${ordenes.fecha}',
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                        ),
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
