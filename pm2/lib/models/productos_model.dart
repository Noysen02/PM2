class ProductosModel {
  final int id;
  final String nameproducto;
  final String descripcion;
  final String categoria;
  final dynamic cantidad;

  ProductosModel(
      {this.id = -1,
      required this.nameproducto,
      required this.descripcion,
      required this.categoria,
      required this.cantidad});

  ProductosModel copyWith(
      {int? id,
      String? nameproducto,
      String? descripcion,
      String? categoria,
      int? cantidad}) {
    return ProductosModel(
        nameproducto: nameproducto ?? this.nameproducto,
        descripcion: descripcion ?? this.descripcion,
        categoria: categoria ?? this.categoria,
        cantidad: cantidad ?? this.cantidad,
        id: id ?? this.id);
  }

  factory ProductosModel.fromMap(Map<String, dynamic> map) {
    return ProductosModel(
        nameproducto: map['nameproducto'],
        descripcion: map['descripcion'],
        categoria: map['categoria'],
        cantidad: map['cantidad'],
        id: map['id']);
  }
  Map<String, dynamic> toMap() => {
        'id': id,
        'nameproducto': nameproducto,
        'descripcion': descripcion,
        'categoria': categoria,
        'cantidad': cantidad
      };
}
