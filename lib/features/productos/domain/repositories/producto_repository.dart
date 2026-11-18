import '../entities/producto.dart';

abstract class ProductoRepository {
  Future<List<Producto>> getProductos();
  Future<Producto> createProducto(Producto producto);
  Future<Producto> updateStock(int productoId, int nuevoStock);
}
