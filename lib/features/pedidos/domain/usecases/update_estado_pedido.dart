// Ruta: lib/features/pedidos/domain/usecases/update_estado_pedido.dart

import '../entities/estado_pedido.dart';
import '../entities/pedido.dart';
import '../repositories/pedido_repository.dart';

class UpdateEstadoPedido {
  final PedidoRepository repository;

  UpdateEstadoPedido(this.repository);

  Future<Pedido> call({
    required Pedido pedido,
    required EstadoPedido nuevoEstado,
  }) async {
    if (pedido.id == null) {
      throw ArgumentError('El pedido no tiene un ID válido');
    }
    if (!pedido.estado.canTransitionTo(nuevoEstado)) {
      throw ArgumentError(
        'Transición de estado no válida de ${pedido.estado.label} a ${nuevoEstado.label}',
      );
    }

    return repository.updateEstado(pedido.id!, nuevoEstado);
  }
}
