import 'package:flutter/material.dart';

class clientes extends StatefulWidget {
  const clientes ({Key? key}) : super(key: key);


@override
  _ClientesScreenState createState() => _ClientesScreenState ();
}

class _ClientesScreenState extends State<clientes> {
  List<Map<String, String>> clientes = [
    {"nombre": "Nombre 5", "direccion": "Direccion 5", "codigo": "Código 5", "email": "email5@example.com", "numero": "1234567894"},
    {"nombre": "Nombre 6", "direccion": "Direccion 6", "codigo": "Código 6", "email": "email6@example.com", "numero": "1234567895"},
    {"nombre": "Nombre 7", "direccion": "Direccion 7", "codigo": "Código 7", "email": "email7@example.com", "numero": "1234567896"},
    {"nombre": "Nombre 8", "direccion": "Direccion 8", "codigo": "Código 8", "email": "email8@example.com", "numero": "1234567897"},
    {"nombre": "Nombre 9", "direccion": "Direccion 9", "codigo": "Código 9", "email": "email9@example.com", "numero": "1234567898"},
    {"nombre": "Nombre 10", "direccion": "Direccion 10", "codigo": "Código 10", "email": "email10@example.com", "numero": "1234567899"},
  ];

  List<Map<String, String>> _clientesFiltradas = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _clientesFiltradas = clientes;
    _searchController.addListener(() {
      _filterClientes();
    });
  }

  void _filterClientes() {
    List<Map<String, String>> resultados = [];
    if (_searchController.text.isEmpty) {
      resultados = clientes;
    } else {
      resultados = clientes
          .where((cliente) => cliente['nombre']!
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
    }

    setState(() {
      _clientesFiltradas = resultados;
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
        backgroundColor: Color.fromARGB(255, 70, 169, 226),
        title: const Text("Registro de clientes"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
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
      body: ListaClientes(clientes: _clientesFiltradas),
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

class ListaClientes extends StatelessWidget {
  final List<Map<String, String>> clientes;

  ListaClientes({required this.clientes});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: clientes.length,
      itemBuilder: (context, index) {
        final cliente = clientes[index];
        return Card(
          margin: EdgeInsets.all(10),
          child: ListTile(
            title: Text(cliente['nombre']!),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Dirección: ${cliente['direccion']!}"),
                Text("Código: ${cliente['codigo']!}"),
                Text("Email: ${cliente['email']!}"),
                Text("Número: ${cliente['numero']!}"),
              ],
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