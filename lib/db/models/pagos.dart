class Pago {
  int? id;
  String nombre;
  String apellidos;
  double monto;
  String fecha;

  Pago({
    this.id,
    required this.nombre,
    required this.apellidos,
    required this.monto,
    required this.fecha,
  });

  /*Pago.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    nombre = json['nombre'];
    apellidos = json['apellidos'];
    monto = json['monto'];
    fecha = json['fecha'];
  }*/

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'apellidos': apellidos,
      'monto': monto,
      'fecha': fecha,
    };
  }

  @override
  String toString() {
    return 'Pago: $id, nombre $nombre, apellidos $apellidos, monto $monto, fecha $fecha ';
  }
}