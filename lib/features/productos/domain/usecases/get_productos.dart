import '../entities/producto.dart';
import '../repositories/producto_repository.dart';

class GetProductos {
  final ProductoRepository repository;
  GetProductos(this.repository);

  Future<List<Producto>> call() => repository.getProductos();
}
