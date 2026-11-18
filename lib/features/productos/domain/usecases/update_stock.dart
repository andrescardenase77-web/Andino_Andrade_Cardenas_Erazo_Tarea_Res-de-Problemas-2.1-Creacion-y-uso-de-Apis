import '../entities/producto.dart';
import '../repositories/producto_repository.dart';

class UpdateStock {
  final ProductoRepository repository;
  UpdateStock(this.repository);

  Future<Producto> call(int productoId, int nuevoStock) {
    if (productoId <= 0) {
      throw ArgumentError('El ID del producto es inválido');
    }
    if (nuevoStock < 0) {
      throw ArgumentError('El stock no puede ser negativo');
    }
    return repository.updateStock(productoId, nuevoStock);
  }

  /// Reglas de negocio (Caso 2 - Pedidos para una cafetería):
  /// - La cantidad solicitada debe ser mayor que 0.
  /// - No se puede realizar un pedido si el producto no tiene stock.
  /// - La cantidad solicitada no puede superar el stock disponible.
  /// - Al confirmar un pedido, el stock del producto disminuye.
  Future<Producto> descontarPorPedido({
    required Producto producto,
    required int cantidad,
  }) {
    if (cantidad <= 0) {
      throw ArgumentError('La cantidad solicitada debe ser mayor que 0');
    }
    if (producto.stock <= 0) {
      throw ArgumentError(
        'No se puede realizar un pedido si el producto no tiene stock',
      );
    }
    if (cantidad > producto.stock) {
      throw ArgumentError(
        'La cantidad solicitada no puede superar el stock disponible',
      );
    }
    if (producto.id == null) {
      throw ArgumentError('El producto no tiene un ID válido');
    }
    return call(producto.id!, producto.stock - cantidad);
  }

  /// Regla de negocio (Caso 2 - Pedidos para una cafetería):
  /// - Si un pedido se cancela antes de ser entregado, el stock debe restaurarse.
  Future<Producto> restaurarPorCancelacion({
    required Producto producto,
    required int cantidad,
  }) {
    if (cantidad <= 0) {
      throw ArgumentError('La cantidad a restaurar debe ser mayor que 0');
    }
    if (producto.id == null) {
      throw ArgumentError('El producto no tiene un ID válido');
    }
    return call(producto.id!, producto.stock + cantidad);
  }
}
