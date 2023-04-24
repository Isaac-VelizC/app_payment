class Perfil{
  int? id;
  late String nombre;
  late String apellido;
  late int telefono;
  late String image;

  Perfil({
    this.id,
    required this.nombre,
    required this.apellido,
    required this.telefono,
    required this.image
  });

  Perfil.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    nombre = json['nombre'];
    apellido = json['apellido'];
    telefono = json['telefono'];
    image = json['image'];
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'apellido': apellido,
      'telefono': telefono,
      'image': image
    };
  }

  @override
  String toString() {
    return 'Perfil: $id, nombre $nombre, apellido $apellido, telefono $telefono, image $image ';
  }
}