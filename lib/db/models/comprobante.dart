class Comprobante {
  int? id;
  int? idinquilino;
  late double monto;
  late String fecha;
  late String idservicio;
  late String estado;

  Comprobante({
    this.id,
    required this.idinquilino,
    required this.monto,
    required this.fecha,
    required this.idservicio,
    required this.estado
  });

  Comprobante.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    idinquilino = json['idinquilino'];
    monto = json['monto'];
    fecha = json['fecha'];
    idservicio = json['idservicio'];
    estado = json['estado'];
  }

  Map<String, dynamic> toMap() {
    return {
      'idinquilino': idinquilino,
      'monto': monto,
      'fecha': fecha,
      'idservicio': idservicio,
      'estado': estado
    };
  }

  @override
  String toString() {
    return 'Pago: $id, idinquilino $idinquilino, monto $monto, fecha $fecha, idservicio $idservicio, estado $estado ';
  }
}