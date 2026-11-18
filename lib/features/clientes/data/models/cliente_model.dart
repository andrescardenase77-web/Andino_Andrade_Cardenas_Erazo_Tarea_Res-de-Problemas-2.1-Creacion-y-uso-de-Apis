import '../../domain/entities/cliente.dart';

class ClienteModel extends Cliente {
  const ClienteModel({
    super.id,
    required super.nombre,
    required super.telefono,
    required super.email,
  });

  factory ClienteModel.fromJson(Map<String, dynamic> json) => ClienteModel(
        id: json['id'] as int?,
        nombre: json['nombre'] as String,
        telefono: json['telefono'] as String,
        email: json['email'] as String,
      );

  factory ClienteModel.fromEntity(Cliente c) => ClienteModel(
        id: c.id,
        nombre: c.nombre,
        telefono: c.telefono,
        email: c.email,
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'nombre': nombre,
        'telefono': telefono,
        'email': email,
      };
}