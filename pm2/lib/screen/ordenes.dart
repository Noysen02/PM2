import 'package:flutter/material.dart';

class ordenes extends StatelessWidget {
  const ordenes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 202, 142, 1),
          title: const Text("Ordenes")),
    );
  }
}
