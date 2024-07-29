import 'package:flutter/material.dart';
import 'package:pm2/services/database_service.dart';
import 'package:pm2/models/task.dart';

class ordenes extends StatefulWidget {
  const ordenes({super.key});

  @override
  State<ordenes> createState() => _OrdenesPageState();
}

class _OrdenesPageState extends State<ordenes> {
  final DatabaseService _databaseService = DatabaseService.instance;

  // Variables para el diálogo
  // ignore: unused_field
  int? _ordenId;
  String? _nombre;
  String? _direccion;
  String? _fecha;

  // Variables para la búsqueda
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

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Buscar por nombre, dirección o fecha',
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
        ),
        floatingActionButton: _addOrdenButton(),
        body: Column(
          children: [
            _searchBar(),
            Expanded(child: _ordenList()),
          ],
        ));
  }

  Widget _addOrdenButton() {
    return FloatingActionButton(
      onPressed: () {
        _showOrdenDialog();
      },
      child: const Icon(
        Icons.add,
      ),
    );
  }

  void _showOrdenDialog({Ordenes? orden}) {
    if (orden != null) {
      _ordenId = orden.id;
      _nombre = orden.nombre;
      _direccion = orden.direccion;
      _fecha = orden.fecha;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(orden == null ? 'Agregar Orden' : 'Actualizar Orden'),
        content: Column(
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
            TextField(
              onChanged: (value) {
                _fecha = value;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Ingrese la fecha',
              ),
              controller: TextEditingController(text: _fecha),
            ),
            MaterialButton(
              color: Theme.of(context).colorScheme.primary,
              onPressed: () {
                if (_nombre == null || _nombre!.isEmpty) return;
                if (_direccion == null || _direccion!.isEmpty) return;
                if (_fecha == null || _fecha!.isEmpty) return;

                if (orden == null) {
                  _databaseService.addOrden(
                    _nombre!,
                    _direccion!,
                    _fecha!,
                  );
                } else {
                  _databaseService.updateOrden(
                    orden.id,
                    _nombre!,
                    _direccion!,
                    _fecha!,
                  );
                }
                _loadOrdenes();

                setState(() {
                  _ordenId = null;
                  _nombre = null;
                  _direccion = null;
                  _fecha = null;
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
      // Reset form values after closing dialog
      setState(() {
        _ordenId = null;
        _nombre = null;
        _direccion = null;
        _fecha = null;
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
                        _databaseService.deleteOrden(ordenes.id);
                        _loadOrdenes(); // Refresh the employee list
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
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 50.0,
                    height: 50.0,
                    color: Colors.grey[300],
                    margin: EdgeInsets.only(right: 16.0),
                    child: Center(
                      child: Text('Imagen'),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              ordenes.nombre,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.0),
                        Text('Dirección: ${ordenes.direccion}'),
                        SizedBox(height: 8.0),
                        Text('Fecha: ${ordenes.fecha}'),
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
