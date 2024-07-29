class Task {
  final dynamic id, cantidad;
  final String nombreproducto, descripcion, categoria;

  Task({
    required this.id,
    required this.nombreproducto,
    required this.descripcion,
    required this.categoria,
    required this.cantidad,
  });
}

class Proveedores {
  final dynamic idproveedores;
  final String nombreprov, direccionprov, telefonoprov;

  Proveedores(
      {required this.idproveedores,
      required this.nombreprov,
      required this.direccionprov,
      required this.telefonoprov});
}

class Ordenes {
  final dynamic id;
  final String nombre;
  final String direccion;
  final String fecha;

  Ordenes({
    required this.id,
    required this.nombre,
    required this.direccion,
    required this.fecha,
  });
}

class Cliente {
  final int id;
  final String nombreCliente;
  final String direccionCliente;
  final String emailCliente;
  final String telefonoCliente;

  Cliente({
    required this.id,
    required this.nombreCliente,
    required this.direccionCliente,
    required this.emailCliente,
    required this.telefonoCliente,
  });
}

class Empleado {
  final int id;
  final String nombreEmpleado;
  final String fechaNacempleado;
  final String telefonoempleado;

  Empleado({
    required this.id,
    required this.nombreEmpleado,
    required this.fechaNacempleado,
    required this.telefonoempleado,
  });
}
