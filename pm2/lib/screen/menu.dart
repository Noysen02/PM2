import 'package:flutter/material.dart';
import 'package:pm2/screen/clientes.dart';
import 'package:pm2/screen/compras.dart';
import 'package:pm2/screen/empleados.dart';
import 'package:pm2/screen/ordenes.dart';
import 'package:pm2/screen/productos.dart';
import 'package:pm2/screen/proveedores.dart';
import 'package:pm2/screen/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 7, 255, 234),
        title: const Text(
          "MENU",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _logout(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(""),
            ElevatedButton(
              child: Text("Productos", style: TextStyle(color: Colors.black)),
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => productos()),
                )
              },
            ),
            Text(""),
            ElevatedButton(
              child: Text("Ordenes", style: TextStyle(color: Colors.black)),
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ordenes()),
                )
              },
            ),
            Text(""),
            ElevatedButton(
              child: Text("Clientes", style: TextStyle(color: Colors.black)),
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => clientes()),
                )
              },
            ),
            Text(""),
            ElevatedButton(
              child: Text("Proveedores", style: TextStyle(color: Colors.black)),
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => proveedores()),
                )
              },
            ),
            Text(""),
            ElevatedButton(
              child: Text("Empleados", style: TextStyle(color: Colors.black)),
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => empleados()),
                )
              },
            ),
            Text(""),
            ElevatedButton(
              child: Text("Compras", style: TextStyle(color: Colors.black)),
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => compras()),
                )
              },
            ),
          ],
        ),
      ),
    );
  }

  void _logout(BuildContext context) async {
    // Borrar datos de usuario de SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Navegar de vuelta a la pantalla de inicio de sesión y eliminar la ruta actual
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }
}
