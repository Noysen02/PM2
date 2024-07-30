import 'dart:ui';
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
        backgroundColor: Colors.teal,
        title: const Text(
          "MENU",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton.icon(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            icon: Icon(Icons.logout, color: Colors.white),
            label: Text(
              "Cerrar sesión",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              _logout(context);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('imagenes/fondo.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                color: Colors.black.withOpacity(0.1),
              ),
            ),
          ),

          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildMenuButton(
                          context,
                          "Productos",
                          Icons.production_quantity_limits,
                          productos(),
                          Colors.blue,
                        ),
                        _buildMenuButton(
                          context,
                          "Ordenes",
                          Icons.list_alt,
                          ordenes(),
                          Colors.green,
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildMenuButton(
                          context,
                          "Clientes",
                          Icons.people,
                          clientes(),
                          Colors.orange,
                        ),
                        _buildMenuButton(
                          context,
                          "Proveedores",
                          Icons.local_shipping,
                          proveedores(),
                          Colors.red,
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildMenuButton(
                          context,
                          "Empleados",
                          Icons.person,
                          empleados(),
                          Colors.purple,
                        ),
                        _buildMenuButton(
                          context,
                          "Compras",
                          Icons.shopping_cart,
                          compras(),
                          Colors.pink,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String title, IconData icon, Widget destination, Color color) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        minimumSize: Size(150, 150),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
        shadowColor: Colors.white,
      ),
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => destination),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40),
          SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }
}