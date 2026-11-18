// Ruta: lib/features/pedidos/data/repositories/pedido_repository_impl.dart

import '../../domain/entities/estado_pedido.dart';
import '../../domain/entities/pedido.dart';
import '../../domain/repositories/pedido_repository.dart';
import '../datasources/pedido_remote_datasource.dart';
import '../models/pedido_model.dart';

class PedidoRepositoryImpl implements PedidoRepository {
  final PedidoRemoteDataSource remoteDataSource;

  PedidoRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Pedido>> getPedidos() async {
    final models = await remoteDataSource.fetchPedidos();
    return models;
  }

  @override
  Future<Pedido> createPedido(Pedido pedido) async {
    final model = PedidoModel.fromEntity(pedido);
    final result = await remoteDataSource.createPedido(model);
    return result;
  }

  @override
  Future<Pedido> updateEstado(int pedidoId, EstadoPedido nuevoEstado) async {
    final result = await remoteDataSource.updateEstado(pedidoId, nuevoEstado);
    return result;
  }

  @override
  Future<void> deletePedido(int pedidoId) async {
    await remoteDataSource.deletePedido(pedidoId);
  }
}
