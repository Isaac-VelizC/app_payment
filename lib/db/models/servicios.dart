class Servicio {
  int? id;
  late String tipo;
  late String estado;

  Servicio({
    this.id,
    required this.tipo,
    required this.estado,
  });

  Servicio.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    tipo = json['tipo'];
    estado = json['estado'];
  }

  Map<String, dynamic> toMap() {
    return {
      'tipo': tipo,
      'estado': estado,
    };
  }

  @override
  String toString() {
    return 'Servicio: $id, tipo $tipo, estado $estado ';
  }
}