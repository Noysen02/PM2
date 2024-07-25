import 'package:flutter/material.dart';
import 'package:pm2/empleado/empleado.dart'; // Asegúrate de importar tu modelo de datos de Empleado

class Empleados extends StatefulWidget {
  const Empleados({Key? key}) : super(key: key);

  @override
  _EmpleadosState createState() => _EmpleadosState();
}

class _EmpleadosState extends State<Empleados> {
  TextEditingController searchController = TextEditingController();
  List<Empleado> empleados = [];

  List<Empleado> filteredEmpleados = []; // Lista filtrada para la búsqueda

  @override
  void initState() {
    filteredEmpleados = empleados; // Inicialmente muestra todos los empleados
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 237, 191, 83),
        title: const Text("Empleados"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _agregar(context),
                _buildSearchBar(),
              ],
            ),
          ),
          Expanded(
            child: _buildListaEmpleados(),
          ),
        ],
      ),
    );
  }

  Widget _agregar(BuildContext context) {
    // Botón de Agregar Empleado
    return TextButton(
      onPressed: () {
        // Navega a la pantalla para agregar un empleado
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AgregarEmpleado(addEmpleado: _addEmpleado)),
        );
      },
      child: const Text(
        'Agregar',
        style: TextStyle(
          color: Color.fromARGB(255, 2, 27, 188),
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: TextField(
          controller: searchController,
          decoration: InputDecoration(
            labelText: 'Buscar por nombre',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) {
            _filterEmpleados(value);
          },
        ),
      ),
    );
  }

  Widget _buildListaEmpleados() {
    return ListView.builder(
      itemCount: filteredEmpleados.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(filteredEmpleados[index].nombre),
          subtitle: Text(
            'Código: ${filteredEmpleados[index].codigo}, Teléfono: ${filteredEmpleados[index].telefono}',
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  _mostrarDialogoActualizarEmpleado(
                      context, filteredEmpleados[index]);
                },
                icon: const Icon(
                  Icons.update,
                  color: Color.fromARGB(255, 2, 27, 188),
                  size: 20,
                ),
              ),
              IconButton(
                onPressed: () {
                  _deleteEmpleado(index);
                },
                icon: const Icon(
                  Icons.delete,
                  color: Color.fromARGB(255, 2, 27, 188),
                  size: 20,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _filterEmpleados(String query) {
    List<Empleado> filteredList = empleados
        .where((empleado) =>
            empleado.nombre.toLowerCase().contains(query.toLowerCase()))
        .toList();

    setState(() {
      filteredEmpleados = filteredList;
    });
  }

  void _addEmpleado(String codigo, String nombre, String telefono) {
    // Generar un nuevo código de empleado
    int newCodigo = empleados.length + 1;

    // Crear un nuevo objeto Empleado
    Empleado nuevoEmpleado = Empleado(
      codigo: newCodigo,
      nombre: nombre,
      telefono: telefono,
    );

    // Agregar el nuevo empleado a la lista
    setState(() {
      empleados.add(nuevoEmpleado);
      filteredEmpleados = empleados; // Actualizar la lista filtrada
    });

    // Navegar de regreso a la pantalla anterior
    Navigator.pop(context);
  }

  void _deleteEmpleado(int index) {
    setState(() {
      empleados.removeAt(index);
      filteredEmpleados = empleados; // Actualizar la lista filtrada
    });
  }

  Future<void> _mostrarDialogoActualizarEmpleado(
      BuildContext context, Empleado empleado) async {
    TextEditingController nombreController =
        TextEditingController(text: empleado.nombre);
    TextEditingController telefonoController =
        TextEditingController(text: empleado.telefono);

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Actualizar Empleado'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: nombreController,
                  decoration: InputDecoration(labelText: 'Nombre'),
                ),
                TextFormField(
                  controller: telefonoController,
                  decoration: InputDecoration(labelText: 'Teléfono'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Actualizar'),
              onPressed: () {
                _actualizarEmpleado(
                    empleado, nombreController.text, telefonoController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _actualizarEmpleado(
      Empleado empleado, String nuevoNombre, String nuevoTelefono) {
    setState(() {
      // Buscar el empleado por su código y actualizar sus datos
      int index = empleados.indexWhere((emp) => emp.codigo == empleado.codigo);
      if (index != -1) {
        // Actualizar en la lista original
        empleados[index].nombre = nuevoNombre;
        empleados[index].telefono = nuevoTelefono;

        // Actualizar en la lista filtrada
        filteredEmpleados = List.from(empleados);
      }
    });
  }
}

class AgregarEmpleado extends StatelessWidget {
  final Function(String, String, String) addEmpleado;

  const AgregarEmpleado({Key? key, required this.addEmpleado})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController codigoController = TextEditingController();
    TextEditingController nombreController = TextEditingController();
    TextEditingController telefonoController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Empleado'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: codigoController,
                decoration: InputDecoration(labelText: 'Código'),
              ),
              TextFormField(
                controller: nombreController,
                decoration: InputDecoration(labelText: 'Nombre'),
              ),
              TextFormField(
                controller: telefonoController,
                decoration: InputDecoration(labelText: 'Teléfono'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Llama a la función addEmpleado con los valores ingresados
                    addEmpleado(
                      codigoController.text,
                      nombreController.text,
                      telefonoController.text,
                    );
                  },
                  child: Text('Guardar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
