import 'package:flutter/material.dart';
import 'package:pm2/screen/menu.dart';

void main() {
  runApp(Myapps());
}

//clase statelesswidget

class Myapps extends StatelessWidget {
  const Myapps({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: menu(),
    );
  }
}
