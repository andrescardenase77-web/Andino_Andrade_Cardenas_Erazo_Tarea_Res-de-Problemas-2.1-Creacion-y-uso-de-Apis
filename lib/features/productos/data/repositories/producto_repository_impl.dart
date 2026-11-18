import '../../domain/entities/producto.dart';
import '../../domain/repositories/producto_repository.dart';
import '../datasources/producto_remote_datasource.dart';
import '../models/producto_model.dart';

class ProductoRepositoryImpl implements ProductoRepository {
  final ProductoRemoteDataSource remote;
  ProductoRepositoryImpl(this.remote);

  @override
  Future<List<Producto>> getProductos() => remote.fetchProductos();

  @override
  Future<Producto> createProducto(Producto producto) =>
      remote.createProducto(ProductoModel.fromEntity(producto));

  @override
  Future<Producto> updateStock(int productoId, int nuevoStock) =>
      remote.updateStock(productoId, nuevoStock);
}
