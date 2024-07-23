//importar libreria material
import 'package:flutter/material.dart';

class productos extends StatelessWidget {
  const productos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 202, 142, 1),
          title: const Text("Productos")),
    );
  }
}