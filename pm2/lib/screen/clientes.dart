import 'package:flutter/material.dart';

class clientes extends StatelessWidget {
  const clientes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 202, 142, 1),
          title: const Text("Clientes")),
    );
  }
}