// Ruta: lib/features/pedidos/domain/repositories/pedido_repository.dart

import '../entities/estado_pedido.dart';
import '../entities/pedido.dart';

abstract class PedidoRepository {
  Future<List<Pedido>> getPedidos();
  Future<Pedido> createPedido(Pedido pedido);
  Future<Pedido> updateEstado(int pedidoId, EstadoPedido nuevoEstado);
  Future<void> deletePedido(int pedidoId);
}
