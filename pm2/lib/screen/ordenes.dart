import 'package:flutter/material.dart';

class ordenes extends StatefulWidget {
  const ordenes({Key? key}) : super(key: key);

  @override
  _OrdenesState createState() => _OrdenesState();
}

class _OrdenesState extends State<ordenes> {
  List<Map<String, String>> ordenes = [
    {"nombre": "Nombre 1", "direccion": "Direccion 1", "codigo": "Código 1"},
    {"nombre": "Nombre 2", "direccion": "Direccion 2", "codigo": "Código 2"},
    {"nombre": "Nombre 3", "direccion": "Direccion 3", "codigo": "Código 3"},
    {"nombre": "Nombre 4", "direccion": "Direccion 4", "codigo": "Código 4"},
    {"nombre": "Nombre 5", "direccion": "Direccion 5", "codigo": "Código 5"},
    {"nombre": "Nombre 6", "direccion": "Direccion 6", "codigo": "Código 6"},
    {"nombre": "Nombre 7", "direccion": "Direccion 7", "codigo": "Código 7"},
    {"nombre": "Nombre 8", "direccion": "Direccion 8", "codigo": "Código 8"},
    {"nombre": "Nombre 9", "direccion": "Direccion 9", "codigo": "Código 9"},
    {"nombre": "Nombre 10", "direccion": "Direccion 10", "codigo": "Código 10"},
  ];

  List<Map<String, String>> _ordenesFiltradas = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _ordenesFiltradas = ordenes;
    _searchController.addListener(() {
      _filterOrdenes();
    });
  }

  void _filterOrdenes() {
    List<Map<String, String>> resultados = [];
    if (_searchController.text.isEmpty) {
      resultados = ordenes;
    } else {
      resultados = ordenes
          .where((orden) => orden['nombre']!
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
    }

    setState(() {
      _ordenesFiltradas = resultados;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 202, 142, 1),
        title: const Text("Ordenes"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearchDialog(context);
            },
          ),
        ],
      ),
      body: ListaOrdenes(ordenes: _ordenesFiltradas),
    );
  }

  void showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Buscar'),
          content: TextField(
            controller: _searchController,
            decoration: InputDecoration(hintText: "Ingrese el nombre a buscar"),
          ),
          actions: [
            TextButton(
              child: Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class ListaOrdenes extends StatelessWidget {
  final List<Map<String, String>> ordenes;

  ListaOrdenes({required this.ordenes});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: ordenes.length,
      itemBuilder: (context, index) {
        final orden = ordenes[index];
        return Card(
          margin: EdgeInsets.all(10),
          child: ListTile(
            title: Text(orden['nombre']!),
            subtitle: Text(orden['direccion']!),
            trailing: Text(orden['codigo']!),
          ),
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ordenes(),
  ));
}
