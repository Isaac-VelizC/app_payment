class Perfil {
  int? id;
  late String nombre;
  String? imagen;

  Perfil({this.id, required this.nombre, this.imagen});

  Perfil.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    nombre = json['nombre'];
    imagen = json['imagen'];
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'imagen': imagen,
    };
  }
}
