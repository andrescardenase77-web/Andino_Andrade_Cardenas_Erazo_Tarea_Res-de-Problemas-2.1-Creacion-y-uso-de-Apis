class Producto {
  final int? id;
  final String nombre;
  final String descripcion;
  final double precio;
  final int stock;
  final String categoria;

  const Producto({
    this.id,
    required this.nombre,
    this.descripcion = '',
    required this.precio,
    required this.stock,
    this.categoria = 'Cafetería',
  });

  bool get tieneStock => stock > 0;

  bool puedeSolicitar(int cantidad) =>
      cantidad > 0 && tieneStock && cantidad <= stock;

  Producto copyWith({
    int? id,
    String? nombre,
    String? descripcion,
    double? precio,
    int? stock,
    String? categoria,
  }) {
    return Producto(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      precio: precio ?? this.precio,
      stock: stock ?? this.stock,
      categoria: categoria ?? this.categoria,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Producto &&
        other.id == id &&
        other.nombre == nombre &&
        other.descripcion == descripcion &&
        other.precio == precio &&
        other.stock == stock &&
        other.categoria == categoria;
  }

  @override
  int get hashCode => Object.hash(
        id,
        nombre,
        descripcion,
        precio,
        stock,
        categoria,
      );
}
