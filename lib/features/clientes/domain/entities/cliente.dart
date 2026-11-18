class Cliente {
  final int? id;
  final String nombre;
  final String telefono;
  final String email;

  const Cliente({
    this.id,
    required this.nombre,
    required this.telefono,
    required this.email,
  });
}