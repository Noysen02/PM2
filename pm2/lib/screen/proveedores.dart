import 'package:flutter/material.dart';
import 'package:pm2/services/database_service.dart';
import 'package:pm2/models/task.dart';

class proveedores extends StatefulWidget {
  const proveedores({super.key});

  @override
  State<proveedores> createState() => _ProveedoresPageState();
}

class _ProveedoresPageState extends State<proveedores> {
  final DatabaseService _databaseService = DatabaseService.instance;
  // ignore: unused_field
  int? _proveedorId;
  String? _nombreProveedor;
  String? _direccionProveedor;
  String? _telefonoProveedor;
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
          prefixIcon: Icon(Icons.search, color: Colors.red),
          filled: true,
          fillColor: Colors.white.withOpacity(0.9),
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
         titleTextStyle: TextStyle(color: Colors.white,
        fontSize: 20,
      ),
        backgroundColor: Colors.red,
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
      backgroundColor: Colors.red,
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
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
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(proveedor == null ? 'Agregar Proveedor' : 'Actualizar Proveedor'),
        content: SingleChildScrollView(
          child: Column(
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
              SizedBox(height: 8.0),
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
              SizedBox(height: 8.0),
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
              SizedBox(height: 16.0),
              MaterialButton(
                color: Colors.red,
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

                  _loadProveedores();

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
      ),
    ).then((_) {
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
                        _loadProveedores();
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
                    color: Colors.red,
                    margin: EdgeInsets.only(right: 16.0),
                    child: Center(
                      child: Icon(Icons.local_shipping, color: Colors.white),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          proveedor.nombreprov,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Dirección: ${proveedor.direccionprov}',
                          style: TextStyle(
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Teléfono: ${proveedor.telefonoprov}',
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