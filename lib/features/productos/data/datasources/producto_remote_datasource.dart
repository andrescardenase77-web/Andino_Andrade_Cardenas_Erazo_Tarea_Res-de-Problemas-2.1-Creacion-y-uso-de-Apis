import '../../../../app/network/api_client.dart';
import '../../../../app/network/api_endpoints.dart';
import '../models/producto_model.dart';

abstract class ProductoRemoteDataSource {
  Future<List<ProductoModel>> fetchProductos();
  Future<ProductoModel> createProducto(ProductoModel producto);
  Future<ProductoModel> updateStock(int productoId, int nuevoStock);
}

class ProductoRemoteDataSourceImpl implements ProductoRemoteDataSource {
  final ApiClient client;

  ProductoRemoteDataSourceImpl(this.client);

  /// Catálogo semilla en memoria utilizado como fallback cuando la API aún no
  /// está disponible o falla en tiempo de ejecución.
  final List<ProductoModel> _fallbackProductos = [
    const ProductoModel(
      id: 1,
      nombre: 'Café Espresso',
      descripcion: 'Shot doble de café arábigo recién molido',
      precio: 2.25,
      stock: 18,
      categoria: 'Bebidas Calientes',
    ),
    const ProductoModel(
      id: 2,
      nombre: 'Cappuccino Artesanal',
      descripcion: 'Espresso con leche vaporizada y espuma cremosa',
      precio: 3.50,
      stock: 12,
      categoria: 'Bebidas Calientes',
    ),
    const ProductoModel(
      id: 3,
      nombre: 'Latte Vainilla Frío',
      descripcion: 'Espresso frío con leche y esencia natural de vainilla',
      precio: 4.00,
      stock: 9,
      categoria: 'Bebidas Frías',
    ),
    const ProductoModel(
      id: 4,
      nombre: 'Croissant de Mantequilla',
      descripcion: 'Hojaldre francés horneado del día',
      precio: 2.75,
      stock: 15,
      categoria: 'Panadería',
    ),
    const ProductoModel(
      id: 5,
      nombre: 'Cheesecake de Frutos Rojos',
      descripcion: 'Porción individual con coulis artesanal',
      precio: 5.50,
      stock: 6,
      categoria: 'Postres',
    ),
    const ProductoModel(
      id: 6,
      nombre: 'Muffin de Arándanos',
      descripcion: 'Bizcocho esponjoso con arándanos frescos',
      precio: 2.50,
      stock: 0,
      categoria: 'Panadería',
    ),
  ];

  List<dynamic> _extractList(dynamic response) {
    if (response is List) {
      return response;
    }
    if (response is Map<String, dynamic> && response['data'] is List) {
      return response['data'] as List;
    }
    throw const FormatException('La API no devolvió una lista de productos');
  }

  Map<String, dynamic> _extractObject(dynamic response) {
    if (response is Map<String, dynamic>) {
      final inner = response['data'];
      if (inner is Map<String, dynamic>) {
        return inner;
      }
      return response;
    }
    throw const FormatException('Formato de respuesta inesperado de la API');
  }

  @override
  Future<List<ProductoModel>> fetchProductos() async {
    try {
      final response = await client.get(ApiEndpoints.productos);
      final list = _extractList(response);

      return list
          .map((e) => ProductoModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return List<ProductoModel>.from(_fallbackProductos);
    }
  }

  @override
  Future<ProductoModel> createProducto(ProductoModel producto) async {
    if (producto.nombre.trim().isEmpty) {
      throw ArgumentError('El nombre del producto es obligatorio');
    }
    if (producto.precio <= 0) {
      throw ArgumentError('El precio debe ser mayor que 0');
    }
    if (producto.stock < 0) {
      throw ArgumentError('El stock no puede ser negativo');
    }

    try {
      final response = await client.post(
        ApiEndpoints.productos,
        data: producto.toJson(),
      );
      return ProductoModel.fromJson(_extractObject(response));
    } catch (_) {
      final nextId = _fallbackProductos.isEmpty
          ? 1
          : _fallbackProductos
                  .map((p) => p.id ?? 0)
                  .reduce((a, b) => a > b ? a : b) +
              1;
      final created = ProductoModel.fromEntity(
        producto.copyWith(id: producto.id ?? nextId),
      );
      _fallbackProductos.add(created);
      return created;
    }
  }

  @override
  Future<ProductoModel> updateStock(int productoId, int nuevoStock) async {
    if (nuevoStock < 0) {
      throw ArgumentError('El stock no puede ser negativo');
    }

    try {
      final response = await client.put(
        '${ApiEndpoints.productos}/$productoId',
        data: {'stock': nuevoStock},
      );
      return ProductoModel.fromJson(_extractObject(response));
    } catch (_) {
      final index = _fallbackProductos.indexWhere((p) => p.id == productoId);
      if (index == -1) {
        throw StateError('Producto con ID $productoId no encontrado');
      }
      final updated = ProductoModel.fromEntity(
        _fallbackProductos[index].copyWith(stock: nuevoStock),
      );
      _fallbackProductos[index] = updated;
      return updated;
    }
  }
}
