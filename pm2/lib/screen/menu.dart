import 'package:flutter/material.dart';
import 'package:pm2/screen/clientes.dart';
import 'package:pm2/screen/compras.dart';
import 'package:pm2/screen/empleados.dart';
import 'package:pm2/screen/ordenes.dart';
import 'package:pm2/screen/productos.dart';
import 'package:pm2/screen/proveedores.dart';


class menu extends StatelessWidget {
  const menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 7, 255, 234),
          title: const Text(
            "MENU",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(""),
              ElevatedButton(
                  child:
                      Text("Productos", style: TextStyle(color: Colors.black)),
                  onPressed: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => productos()))
                      }),
              Text(""),
              ElevatedButton(
                  child: Text("Ordenes", style: TextStyle(color: Colors.black)),
                  onPressed: () => {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => ordenes()))
                      }),
              Text(""),
              ElevatedButton(
                  child:
                      Text("Clientes", style: TextStyle(color: Colors.black)),
                  onPressed: () => {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => clientes()))
                      }),
              Text(""),
              ElevatedButton(
                  child: Text("Proveedores",
                      style: TextStyle(color: Colors.black)),
                  onPressed: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => proveedores()))
                      }),
              Text(""),
              ElevatedButton(
                  child:
                      Text("Empleados", style: TextStyle(color: Colors.black)),
                  onPressed: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => empleados()))
                      }),
              Text(""),
              ElevatedButton(
                  child:
                      Text("Compras", style: TextStyle(color: Colors.black)),
                  onPressed: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => compras()))
                      }),
            ],
          ),
        ));
  }
}
