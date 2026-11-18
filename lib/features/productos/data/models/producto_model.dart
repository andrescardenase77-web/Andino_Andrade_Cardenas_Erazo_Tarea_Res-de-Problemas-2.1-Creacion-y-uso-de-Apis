import '../../domain/entities/producto.dart';

/// Modelo de datos para serializar y deserializar productos desde la API REST.
///
/// Nota de integración: cuando se conecte la API definitiva, cualquier ajuste en
/// los nombres o tipos de los campos JSON debe hacerse únicamente aquí.
class ProductoModel extends Producto {
  const ProductoModel({
    super.id,
    required super.nombre,
    super.descripcion = '',
    required super.precio,
    required super.stock,
    super.categoria = 'Cafetería',
  });

  factory ProductoModel.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'] ?? json['productoId'] ?? json['idProducto'];
    final rawPrecio = json['precio'] ?? json['price'] ?? 0;
    final rawStock = json['stock'] ?? json['cantidadDisponible'] ?? 0;

    return ProductoModel(
      id: rawId is int ? rawId : int.tryParse(rawId?.toString() ?? ''),
      nombre: (json['nombre'] ?? json['name'] ?? '').toString(),
      descripcion:
          (json['descripcion'] ?? json['description'] ?? '').toString(),
      precio: rawPrecio is num
          ? rawPrecio.toDouble()
          : double.tryParse(rawPrecio.toString()) ?? 0.0,
      stock: rawStock is int
          ? rawStock
          : (rawStock is num
              ? rawStock.toInt()
              : int.tryParse(rawStock.toString()) ?? 0),
      categoria:
          (json['categoria'] ?? json['category'] ?? 'Cafetería').toString(),
    );
  }

  factory ProductoModel.fromEntity(Producto p) => ProductoModel(
        id: p.id,
        nombre: p.nombre,
        descripcion: p.descripcion,
        precio: p.precio,
        stock: p.stock,
        categoria: p.categoria,
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'nombre': nombre,
        'descripcion': descripcion,
        'precio': precio,
        'stock': stock,
        'categoria': categoria,
      };
}
