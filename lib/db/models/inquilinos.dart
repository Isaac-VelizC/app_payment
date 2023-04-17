class Inquilino {
  int? id;
  late String nombre;
  late String apellidos;
  String? direccion;
  int? telefono;
  String? unidad;
  late String estado;

  Inquilino({
    this.id,
    required this.nombre,
    required this.apellidos,
    this.direccion,
    this.telefono,
    required this.estado,
    this.unidad
  });

  Inquilino.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    nombre = json['nombre'];
    apellidos = json['apellidos'];
    direccion = json['direccion'];
    telefono = json['telefono'];
    unidad = json['unidad'];
    estado = json['estado'];
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'apellidos': apellidos,
      'direccion': direccion,
      'telefono': telefono,
      'unidad': unidad,
      'estado': estado
    };
  }

  @override
  String toString() {
    return 'Inquilino: $id, nombre $nombre, apellidos $apellidos, direccion $direccion, telefno $telefono, unidad $unidad, estado $estado ';
  }
}