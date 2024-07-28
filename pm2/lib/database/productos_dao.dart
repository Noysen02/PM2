import 'package:pm2/database/database_helper.dart';
import 'package:pm2/models/productos_model.dart';

class ProductDao {
  final database = DatabaseHelper.instance.db;

  Future<List<ProductosModel>> readAll() async {
    final data = await database.query('productos');
    return data.map((e) => ProductosModel.fromMap(e)).toList();
  }

  Future<int> insert(ProductosModel productos) async {
    return await database.insert('productos', {
      'nameproducto': productos.nameproducto,
      'descripcion': productos.descripcion,
      'categoria': productos.categoria,
      'cantidad': productos.cantidad
    });
  }

  Future<void> update(ProductosModel productos) async {
    await database.update('productos', productos.toMap(),
        where: 'id = ?', whereArgs: [productos.id]);
  }

  Future<void> delete(ProductosModel productos) async {
    await database
        .delete('productos', where: 'id = ?', whereArgs: [productos.id]);
  }
}
