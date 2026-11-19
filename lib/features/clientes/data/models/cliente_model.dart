import '../../domain/entities/cliente.dart';

class ClienteModel extends Cliente {
  const ClienteModel({
    super.id,
    required super.nombre,
    required super.telefono,
    required super.email,
  });

  factory ClienteModel.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    return ClienteModel(
      id: rawId is int ? rawId : int.tryParse(rawId?.toString() ?? ''),
      nombre: (json['nombre'] ?? '').toString(),
      telefono: (json['telefono'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
    );
  }

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