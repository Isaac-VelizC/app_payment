class Pago {
  int? id;
  int? idinquilino;
  late double monto;
  late String fecha;
  late String servicio;
  late String estado;
  late String descripcion;

  Pago({
    this.id,
    required this.idinquilino,
    required this.monto,
    required this.fecha,
    required this.servicio,
    required this.estado,
    required this.descripcion
  });

  Pago.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    idinquilino = json['idinquilino'];
    monto = json['monto'];
    fecha = json['fecha'];
    servicio = json['servicio'];
    estado = json['estado'];
    descripcion = json['descripcion'];
  }

  Map<String, dynamic> toMap() {
    return {
      'idinquilino': idinquilino,
      'monto': monto,
      'fecha': fecha,
      'servicio': servicio,
      'estado': estado,
      'descripcion': descripcion
    };
  }

  @override
  String toString() {
    return 'Pago: $id, idinquilino $idinquilino, monto $monto, fecha $fecha, servicio $servicio, estado $estado, descripcion $descripcion ';
  }
}