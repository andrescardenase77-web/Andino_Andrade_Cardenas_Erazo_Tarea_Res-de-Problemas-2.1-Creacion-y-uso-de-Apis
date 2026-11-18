// Ruta: lib/features/pedidos/data/datasources/pedido_remote_datasource.dart

import '../../../../app/network/api_client.dart';
import '../../../../app/network/api_endpoints.dart';
import '../../domain/entities/estado_pedido.dart';
import '../models/pedido_model.dart';

abstract class PedidoRemoteDataSource {
  Future<List<PedidoModel>> fetchPedidos();
  Future<PedidoModel> createPedido(PedidoModel pedido);
  Future<PedidoModel> updateEstado(int pedidoId, EstadoPedido nuevoEstado);
  Future<void> deletePedido(int pedidoId);
}

class PedidoRemoteDataSourceImpl implements PedidoRemoteDataSource {
  final ApiClient client;

  PedidoRemoteDataSourceImpl(this.client);

  /// Lista fallback en memoria utilizada cuando la API no responde o falla.
  final List<PedidoModel> _fallbackPedidos = [
    PedidoModel(
      id: 1,
      clienteId: 1,
      clienteNombre: 'Nelson Andrade',
      productoId: 1,
      productoNombre: 'Café Espresso',
      cantidad: 2,
      precioUnitario: 2.25,
      subtotal: 4.50,
      descuento: 0.0,
      total: 4.50,
      estado: EstadoPedido.pendiente,
      fechaCreacion: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    PedidoModel(
      id: 2,
      clienteId: 2,
      clienteNombre: 'Uriel Cárdenas',
      productoId: 2,
      productoNombre: 'Cappuccino Artesanal',
      cantidad: 3,
      precioUnitario: 3.50,
      subtotal: 10.50,
      descuento: 0.0,
      total: 10.50,
      estado: EstadoPedido.preparando,
      fechaCreacion: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    PedidoModel(
      id: 3,
      clienteId: 3,
      clienteNombre: 'Andrés Erazo',
      productoId: 5,
      productoNombre: 'Cheesecake de Frutos Rojos',
      cantidad: 10,
      precioUnitario: 5.50,
      subtotal: 55.00,
      descuento: 5.50,
      total: 49.50,
      estado: EstadoPedido.entregado,
      fechaCreacion: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  List<dynamic> _extractList(dynamic response) {
    if (response is List) {
      return response;
    }
    if (response is Map<String, dynamic> && response['data'] is List) {
      return response['data'] as List;
    }
    throw const FormatException('La API no devolvió una lista de pedidos');
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
  Future<List<PedidoModel>> fetchPedidos() async {
    try {
      final response = await client.get(ApiEndpoints.pedidos);
      final list = _extractList(response);
      return list
          .map((e) => PedidoModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return List<PedidoModel>.from(_fallbackPedidos);
    }
  }

  @override
  Future<PedidoModel> createPedido(PedidoModel pedido) async {
    try {
      final response = await client.post(
        ApiEndpoints.pedidos,
        data: pedido.toJson(),
      );
      return PedidoModel.fromJson(_extractObject(response));
    } catch (_) {
      final nextId = _fallbackPedidos.isEmpty
          ? 1
          : _fallbackPedidos
                  .map((p) => p.id ?? 0)
                  .reduce((a, b) => a > b ? a : b) +
              1;
      final created = PedidoModel.fromEntity(
        pedido.copyWith(id: pedido.id ?? nextId),
      );
      _fallbackPedidos.add(created);
      return created;
    }
  }

  @override
  Future<PedidoModel> updateEstado(int pedidoId, EstadoPedido nuevoEstado) async {
    try {
      final response = await client.put(
        ApiEndpoints.pedidoDetalle(pedidoId),
        data: {'estado': nuevoEstado.label},
      );
      return PedidoModel.fromJson(_extractObject(response));
    } catch (_) {
      final index = _fallbackPedidos.indexWhere((p) => p.id == pedidoId);
      if (index == -1) {
        throw StateError('Pedido con ID $pedidoId no encontrado');
      }
      final updated = PedidoModel.fromEntity(
        _fallbackPedidos[index].copyWith(estado: nuevoEstado),
      );
      _fallbackPedidos[index] = updated;
      return updated;
    }
  }

  @override
  Future<void> deletePedido(int pedidoId) async {
    final index = _fallbackPedidos.indexWhere((p) => p.id == pedidoId);
    if (index != -1 && _fallbackPedidos[index].estado == EstadoPedido.entregado) {
      throw StateError('Un pedido entregado no puede eliminarse');
    }

    try {
      await client.delete(ApiEndpoints.pedidoDetalle(pedidoId));
      if (index != -1) {
        _fallbackPedidos.removeAt(index);
      }
    } catch (_) {
      if (index != -1) {
        _fallbackPedidos.removeAt(index);
      } else {
        throw StateError('Pedido con ID $pedidoId no encontrado');
      }
    }
  }
}
