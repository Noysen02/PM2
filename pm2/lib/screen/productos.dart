import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pm2/services/database_service.dart';
import 'package:pm2/models/task.dart';

class productos extends StatefulWidget {
  const productos({super.key});

  @override
  State<productos> createState() => _productosState();
}

class _productosState extends State<productos> {
  final DatabaseService _databaseService = DatabaseService.instance;

  String? _task = null;
  String? _nombreproducto = null;
  String? _descripcion = null;
  String? _categoria = null;
  String? _cantidad = null;

  @override
  Widget build(Object context) {
    return Scaffold(
      floatingActionButton: _addTaskButton(),
      body: _taskList(),
    );
  }

  Widget _addTaskButton() {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Add Task'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _task = value;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Ingrese nombre del producto',
                  ),
                ),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _descripcion = value;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Ingrese la descripcion',
                  ),
                ),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _categoria = value;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Ingrese la categoria',
                  ),
                ),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _cantidad = value;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Ingrese cantida',
                  ),
                ),
                MaterialButton(
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () {
                    if (_task == null || _task == "") return;
                    if (_descripcion == null || _descripcion == "") return;
                    if (_categoria == null || _categoria == "") return;
                    if (_cantidad == null || _cantidad == "") return;
                    _databaseService.addTask(
                        _task!, _descripcion!, _categoria!, _cantidad!);
                    setState(() {
                      _task = null;
                      _descripcion = null;
                      _categoria = null;
                      _cantidad = null;
                    });
                    Navigator.pop(
                      context,
                    );
                  },
                  child: const Text(
                    "Done",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      child: const Icon(
        Icons.add,
      ),
    );
  }

  Widget _taskList() {
    return FutureBuilder(
        future: _databaseService.getTask(),
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (context, index) {
              Task task = snapshot.data![index];
              return ListTile(
                title: Text(task.nombreproducto),
                subtitle: Text(task.descripcion),
              );
            },
          );
        });
  }
}
