import 'package:flutter/material.dart';
import 'package:pm2/services/database_service.dart';
import 'package:pm2/models/task.dart'; // Asegúrate de que esta importación sea correcta

class proveedores extends StatefulWidget {
  const proveedores({super.key});

  @override
  State<proveedores> createState() => _ProveedoresPageState();
}

class _ProveedoresPageState extends State<proveedores> {
  final DatabaseService _databaseService = DatabaseService.instance;

  // Variables para el diálogo
  // ignore: unused_field
  int? _proveedorId;
  String? _nombreProveedor;
  String? _direccionProveedor;
  String? _telefonoProveedor;

  // Variables para la búsqueda
  // ignore: unused_field
  String _searchQuery = '';
  List<Proveedores> _proveedores = [];
  List<Proveedores> _filteredProveedores = [];

  @override
  void initState() {
    super.initState();
    _loadProveedores();
  }

  void _loadProveedores() async {
    final proveedores = await _databaseService.getProveedores();
    setState(() {
      _proveedores = proveedores ?? [];
      _filteredProveedores = _proveedores;
    });
  }

  void _filterProveedores(String query) {
    final filteredProveedores = _proveedores.where((proveedor) {
      final nombre = proveedor.nombreprov.toLowerCase();
      final direccion = proveedor.direccionprov.toLowerCase();
      final telefono = proveedor.telefonoprov.toLowerCase();
      final searchQuery = query.toLowerCase();

      return nombre.contains(searchQuery) ||
          direccion.contains(searchQuery) ||
          telefono.contains(searchQuery);
    }).toList();

    setState(() {
      _filteredProveedores = filteredProveedores;
    });
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Buscar por nombre, dirección o teléfono',
        ),
        onChanged: (query) {
          _searchQuery = query;
          _filterProveedores(query);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Proveedores'),
      ),
      floatingActionButton: _addProveedorButton(),
      body: Column(
        children: [
          _searchBar(),
          Expanded(child: _proveedorList()),
        ],
      ),
    );
  }

  Widget _addProveedorButton() {
    return FloatingActionButton(
      onPressed: () {
        _showProveedorDialog();
      },
      child: const Icon(Icons.add),
    );
  }

  void _showProveedorDialog({Proveedores? proveedor}) {
    if (proveedor != null) {
      _proveedorId = proveedor.idproveedores;
      _nombreProveedor = proveedor.nombreprov;
      _direccionProveedor = proveedor.direccionprov;
      _telefonoProveedor = proveedor.telefonoprov;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
            proveedor == null ? 'Agregar Proveedor' : 'Actualizar Proveedor'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              onChanged: (value) {
                _nombreProveedor = value;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Ingrese nombre del proveedor',
              ),
              controller: TextEditingController(text: _nombreProveedor),
            ),
            TextField(
              onChanged: (value) {
                _direccionProveedor = value;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Ingrese la dirección',
              ),
              controller: TextEditingController(text: _direccionProveedor),
            ),
            TextField(
              onChanged: (value) {
                _telefonoProveedor = value;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Ingrese el teléfono',
              ),
              controller: TextEditingController(text: _telefonoProveedor),
            ),
            MaterialButton(
              color: Theme.of(context).colorScheme.primary,
              onPressed: () {
                if (_nombreProveedor == null || _nombreProveedor!.isEmpty)
                  return;
                if (_direccionProveedor == null || _direccionProveedor!.isEmpty)
                  return;
                if (_telefonoProveedor == null || _telefonoProveedor!.isEmpty)
                  return;

                if (proveedor == null) {
                  _databaseService.addProveedor(
                    _nombreProveedor!,
                    _direccionProveedor!,
                    _telefonoProveedor!,
                  );
                } else {
                  _databaseService.updateProveedor(
                    proveedor.idproveedores,
                    _nombreProveedor!,
                    _direccionProveedor!,
                    _telefonoProveedor!,
                  );
                }

                _loadProveedores(); // Refresh the provider list

                setState(() {
                  _proveedorId = null;
                  _nombreProveedor = null;
                  _direccionProveedor = null;
                  _telefonoProveedor = null;
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
        _proveedorId = null;
        _nombreProveedor = null;
        _direccionProveedor = null;
        _telefonoProveedor = null;
      });
    });
  }

  Widget _proveedorList() {
    return ListView.builder(
      itemCount: _filteredProveedores.length,
      itemBuilder: (context, index) {
        Proveedores proveedor = _filteredProveedores[index];
        return GestureDetector(
          onLongPress: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Eliminar proveedor'),
                  content: Text(
                      '¿Estás seguro de que deseas eliminar este proveedor?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () {
                        _databaseService
                            .deleteProveedor(proveedor.idproveedores);
                        _loadProveedores(); // Refresh the provider list
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
            _showProveedorDialog(proveedor: proveedor);
          },
          child: Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: Icon(Icons.business),
              title: Text(
                proveedor.nombreprov,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Dirección: ${proveedor.direccionprov}'),
                  Text('Teléfono: ${proveedor.telefonoprov}')
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
