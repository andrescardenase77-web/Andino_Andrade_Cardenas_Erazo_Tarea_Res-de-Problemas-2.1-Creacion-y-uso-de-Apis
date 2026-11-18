// Ruta: lib/features/pedidos/domain/usecases/create_pedido.dart

import '../../../clientes/domain/entities/cliente.dart';
import '../../../productos/domain/entities/producto.dart';
import '../entities/estado_pedido.dart';
import '../entities/pedido.dart';
import '../repositories/pedido_repository.dart';

class CreatePedido {
  final PedidoRepository repository;

  CreatePedido(this.repository);

  Future<Pedido> call({
    required Cliente cliente,
    required Producto producto,
    required int cantidad,
  }) async {
    if (cantidad <= 0) {
      throw ArgumentError('La cantidad solicitada debe ser mayor que 0');
    }
    if (!producto.tieneStock) {
      throw ArgumentError('No se puede realizar un pedido si el producto no tiene stock');
    }
    if (cantidad > producto.stock) {
      throw ArgumentError('La cantidad solicitada no puede superar el stock disponible');
    }
    if (cliente.id == null) {
      throw ArgumentError('El cliente seleccionado debe tener un ID válido');
    }
    if (producto.id == null) {
      throw ArgumentError('El producto seleccionado debe tener un ID válido');
    }

    final double subtotal = producto.precio * cantidad;
    final double descuento = subtotal > 50.0 ? (subtotal * 0.10) : 0.0;
    final double total = subtotal - descuento;

    final nuevoPedido = Pedido(
      clienteId: cliente.id!,
      clienteNombre: cliente.nombre,
      productoId: producto.id!,
      productoNombre: producto.nombre,
      cantidad: cantidad,
      precioUnitario: producto.precio,
      subtotal: subtotal,
      descuento: descuento,
      total: total,
      estado: EstadoPedido.pendiente,
      fechaCreacion: DateTime.now(),
    );

    return repository.createPedido(nuevoPedido);
  }
}
