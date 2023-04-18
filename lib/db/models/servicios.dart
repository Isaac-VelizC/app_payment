class Servicio {
  int? id;
  late String tipo;
  late bool estado;

  Servicio({
    this.id,
    required this.tipo,
    this.estado = false,
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