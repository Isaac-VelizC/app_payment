class Comprobante {
  int? id;
  String? nombre;
  String? apellido;
  String? direccion;
  String? estado;
  double? monto;
  String? fecha;
  String? servicio;
  String? estadoPago;
  String? descripcion;

  Comprobante(
      {this.id,
      this.nombre,
      this.apellido,
      this.direccion,
      this.estado,
      this.monto,
      this.fecha,
      this.servicio,
      this.estadoPago,
      this.descripcion});

  Comprobante.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    nombre = json['nombre'];
    apellido = json['apellido'];
    direccion = json['direccion'];
    estado = json['estado'];
    monto = json['monto'];
    fecha = json['fecha'];
    servicio = json['servicio'];
    estadoPago = json['estadoPago'];
    descripcion = json['descripcion'];
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'apellido': apellido,
      'direccion': direccion,
      'estado': estado,
      'monto': monto,
      'fecha': fecha,
      'servicio': servicio,
      'estadoPago': estadoPago,
      'descripcion': descripcion,
    };
  }

  /*@override
  String toString() {
    return 'Perfil: $id, nombre $nombre, apellido $apellido, telefono $telefono, image $image ';
  }*/
}
