import 'package:flutter/material.dart';
import 'package:pm2/services/database_service.dart';
import 'package:pm2/models/task.dart';

class clientes extends StatefulWidget {
  const clientes({super.key});

  @override
  State<clientes> createState() => _ClientesPageState();
}

class _ClientesPageState extends State<clientes> {
  final DatabaseService _databaseService = DatabaseService.instance;
  // ignore: unused_field
  int? _clienteId;
  String? _nombreCliente;
  String? _direccion;
  String? _email;
  String? _telefono;
  // ignore: unused_field
  String _searchQuery = '';
  List<Cliente> _clientes = [];
  List<Cliente> _filteredClientes = [];

  @override
  void initState() {
    super.initState();
    _loadClientes();
  }

  void _loadClientes() async {
    final clientes = await _databaseService.getClientes();
    setState(() {
      _clientes = clientes ?? [];
      _filteredClientes = _clientes;
    });
  }

  void _filterClientes(String query) {
    final filteredClientes = _clientes.where((cliente) {
      final nombre = cliente.nombreCliente.toLowerCase();
      final direccion = cliente.direccionCliente.toLowerCase();
      final email = cliente.emailCliente.toLowerCase();
      final telefono = cliente.telefonoCliente.toLowerCase();
      final searchQuery = query.toLowerCase();

      return nombre.contains(searchQuery) ||
          email.contains(searchQuery) ||
          direccion.contains(searchQuery) ||
          telefono.contains(searchQuery);
    }).toList();

    setState(() {
      _filteredClientes = filteredClientes;
    });
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Buscar por nombre, email, dirección o teléfono',
          prefixIcon: Icon(Icons.search, color: Colors.orange),
          filled: true,
          fillColor: Colors.white.withOpacity(0.9),
        ),
        onChanged: (query) {
          _searchQuery = query;
          _filterClientes(query);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clientes'),
        titleTextStyle: TextStyle(color: Colors.white,
        fontSize: 20,
      ),
        backgroundColor: Colors.orange,
      ),
      floatingActionButton: _addClienteButton(),
      body: Column(
        children: [
          _searchBar(),
          Expanded(child: _clienteList()),
        ],
      ),
    );
  }

  Widget _addClienteButton() {
    return FloatingActionButton(
      onPressed: () {
        _showClienteDialog();
      },
      backgroundColor: Colors.orange,
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }

  void _showClienteDialog({Cliente? cliente}) {
    if (cliente != null) {
      _clienteId = cliente.id;
      _nombreCliente = cliente.nombreCliente;
      _direccion = cliente.direccionCliente;
      _email = cliente.emailCliente;
      _telefono = cliente.telefonoCliente;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(cliente == null ? 'Agregar Cliente' : 'Actualizar Cliente'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  _nombreCliente = value;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Ingrese nombre del cliente',
                ),
                controller: TextEditingController(text: _nombreCliente),
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
              TextField(
                onChanged: (value) {
                  _email = value;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Ingrese el email',
                ),
                controller: TextEditingController(text: _email),
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
                color: Colors.orange,
                onPressed: () {
                  if (_nombreCliente == null || _nombreCliente!.isEmpty) return;
                  if (_direccion == null || _direccion!.isEmpty) return;
                  if (_email == null || _email!.isEmpty) return;
                  if (_telefono == null || _telefono!.isEmpty) return;

                  if (cliente == null) {
                    _databaseService.addCliente(
                      _nombreCliente!,
                      _direccion!,
                      _email!,
                      _telefono!,
                    );
                  } else {
                    _databaseService.updateCliente(
                      cliente.id,
                      _nombreCliente!,
                      _direccion!,
                      _email!,
                      _telefono!,
                    );
                  }

                  _loadClientes();

                  setState(() {
                    _clienteId = null;
                    _nombreCliente = null;
                    _direccion = null;
                    _email = null;
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
      ),
    ).then((_) {
      setState(() {
        _clienteId = null;
        _nombreCliente = null;
        _direccion = null;
        _email = null;
        _telefono = null;
      });
    });
  }

  Widget _clienteList() {
    return ListView.builder(
      itemCount: _filteredClientes.length,
      itemBuilder: (context, index) {
        Cliente cliente = _filteredClientes[index];
        return GestureDetector(
          onLongPress: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Eliminar cliente'),
                  content: Text('¿Estás seguro de que deseas eliminar este cliente?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () {
                        _databaseService.deleteCliente(cliente.id);
                        _loadClientes();
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
            _showClienteDialog(cliente: cliente);
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
                    color: Colors.orange,
                    margin: EdgeInsets.only(right: 16.0),
                    child: Center(
                      child: Icon(Icons.people, color: Colors.white),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          cliente.nombreCliente,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Dirección: ${cliente.direccionCliente}',
                          style: TextStyle(
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Email: ${cliente.emailCliente}',
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Teléfono: ${cliente.telefonoCliente}',
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

void main() {
  runApp(MaterialApp(
    home: clientes(),
  ));
}