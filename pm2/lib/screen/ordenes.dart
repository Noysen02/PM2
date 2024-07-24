import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ordenes extends StatefulWidget {
  const ordenes({Key? key}) : super(key: key);

  @override
  _OrdenesState createState() => _OrdenesState();
}

class _OrdenesState extends State<ordenes> {
  List<Map<String, String>> ordenes = [
    {"nombre": "Nombre 1", "direccion": "Direccion 1", "codigo": "Código 1", "fecha": "01-01-2024"},
    {"nombre": "Nombre 2", "direccion": "Direccion 2", "codigo": "Código 2", "fecha": "02-01-2024"},
    {"nombre": "Nombre 3", "direccion": "Direccion 3", "codigo": "Código 3", "fecha": "03-01-2024"},
  ];

  List<Map<String, String>> _ordenesFiltradas = [];
  TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'nombre';

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
      resultados = ordenes.where((orden) {
        return orden[_selectedFilter]!
            .toLowerCase()
            .contains(_searchController.text.toLowerCase());
      }).toList();
    }

    setState(() {
      _ordenesFiltradas = resultados;
    });
  }

  void _addOrden(Map<String, String> nuevaOrden) {
    setState(() {
      ordenes.add(nuevaOrden);
      _ordenesFiltradas = ordenes;
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
            Navigator.pop(context);
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddOrdenDialog(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Color.fromARGB(255, 202, 142, 1),
      ),
    );
  }

  void showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Buscar'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                value: _selectedFilter,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedFilter = newValue!;
                  });
                  Navigator.of(context).pop();
                  showSearchDialog(context);
                },
                items: <String>['nombre', 'direccion', 'codigo']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value.capitalize()),
                  );
                }).toList(),
              ),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(hintText: "Ingrese ${_selectedFilter} a buscar"),
              ),
            ],
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

  void showAddOrdenDialog(BuildContext context) {
    final TextEditingController nombreController = TextEditingController();
    final TextEditingController direccionController = TextEditingController();
    final TextEditingController codigoController = TextEditingController();
    final TextEditingController diaController = TextEditingController();
    final TextEditingController mesController = TextEditingController();
    final TextEditingController anioController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Agregar Orden'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreController,
                decoration: InputDecoration(hintText: "Nombre"),
              ),
              TextField(
                controller: direccionController,
                decoration: InputDecoration(hintText: "Dirección"),
              ),
              TextField(
                controller: codigoController,
                decoration: InputDecoration(hintText: "Código"),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: diaController,
                      decoration: InputDecoration(hintText: "DD"),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(2),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: mesController,
                      decoration: InputDecoration(hintText: "MM"),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(2),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: anioController,
                      decoration: InputDecoration(hintText: "AAAA"),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Agregar'),
              onPressed: () {
                String fecha = "${diaController.text}-${mesController.text}-${anioController.text}";
                Map<String, String> nuevaOrden = {
                  "nombre": nombreController.text,
                  "direccion": direccionController.text,
                  "codigo": codigoController.text,
                  "fecha": fecha,
                };
                _addOrden(nuevaOrden);
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
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(orden['codigo']!),
                Text(orden['fecha']!),
              ],
            ),
          ),
        );
      },
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return this[0].toUpperCase() + this.substring(1);
  }
}

void main() {
  runApp(MaterialApp(
    home: ordenes(),
  ));
}