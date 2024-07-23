import 'package:flutter/material.dart';

class Proveedores extends StatefulWidget {
  @override
  _ProveedoresState createState() => _ProveedoresState();
}

class _ProveedoresState extends State<Proveedores> {
  // Lista de proveedores con detalles adicionales
  List<Map<String, String>> listaProveedores = [
    {'nombre': 'Proveedor 1', 'direccion': 'Calle 1, Ciudad 1', 'telefono': '111-111-1111'},
    {'nombre': 'Proveedor 2', 'direccion': 'Calle 2, Ciudad 2', 'telefono': '222-222-2222'},
    {'nombre': 'Proveedor 3', 'direccion': 'Calle 3, Ciudad 3', 'telefono': '333-333-3333'},
    {'nombre': 'Proveedor 4', 'direccion': 'Calle 4, Ciudad 4', 'telefono': '444-444-4444'},
    {'nombre': 'Proveedor 5', 'direccion': 'Calle 5, Ciudad 5', 'telefono': '555-555-5555'},
  ];

  void _addProvider(String nombre, String direccion, String telefono) {
    setState(() {
      listaProveedores.add({
        'nombre': nombre,
        'direccion': direccion,
        'telefono': telefono,
      });
    });
  }

  void _showAddProviderDialog() {
    final nombreController = TextEditingController();
    final direccionController = TextEditingController();
    final telefonoController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Añadir Proveedor"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreController,
                decoration: InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: direccionController,
                decoration: InputDecoration(labelText: 'Dirección'),
              ),
              TextField(
                controller: telefonoController,
                decoration: InputDecoration(labelText: 'Teléfono'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Añadir"),
              onPressed: () {
                _addProvider(
                  nombreController.text,
                  direccionController.text,
                  telefonoController.text,
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(216, 18, 136, 180),
        title: const Text("Proveedores"),
      ),
      body: ListView.builder(
        itemCount: listaProveedores.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: Icon(Icons.business),
              title: Text(listaProveedores[index]['nombre']!),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Dirección: ${listaProveedores[index]['direccion']}'),
                  Text('Teléfono: ${listaProveedores[index]['telefono']}'),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddProviderDialog,
        child: Icon(Icons.add),
        backgroundColor: Color.fromARGB(255, 202, 142, 1),
      ),
    );
  }
}
