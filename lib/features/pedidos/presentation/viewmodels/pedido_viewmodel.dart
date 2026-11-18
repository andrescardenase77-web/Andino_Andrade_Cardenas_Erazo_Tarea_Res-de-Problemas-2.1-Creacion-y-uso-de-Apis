// Ruta: lib/features/pedidos/presentation/viewmodels/pedido_viewmodel.dart

import 'package:flutter/foundation.dart';
import '../../../clientes/domain/entities/cliente.dart';
import '../../../productos/domain/entities/producto.dart';
import '../../domain/entities/estado_pedido.dart';
import '../../domain/entities/pedido.dart';
import '../../domain/repositories/pedido_repository.dart';
import '../../domain/usecases/calculate_discount.dart';
import '../../domain/usecases/create_pedido.dart';
import '../../domain/usecases/update_estado_pedido.dart';

class PedidoViewModel extends ChangeNotifier {
  final CreatePedido _createPedido;
  final UpdateEstadoPedido _updateEstadoPedido;
  final CalculateDiscount _calculateDiscount;
  final PedidoRepository _repository;

  PedidoViewModel(
    this._createPedido,
    this._updateEstadoPedido,
    this._calculateDiscount,
    this._repository,
  );

  List<Pedido> _pedidos = [];
  bool _loading = false;
  String? _error;

  List<Pedido> get pedidos => List.unmodifiable(_pedidos);
  bool get loading => _loading;
  String? get error => _error;

  Future<void> loadPedidos() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _pedidos = await _repository.getPedidos();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> crearPedido({
    required Cliente cliente,
    required Producto producto,
    required int cantidad,
  }) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final nuevo = await _createPedido(
        cliente: cliente,
        producto: producto,
        cantidad: cantidad,
      );
      _pedidos = [..._pedidos, nuevo];
      return true;
    } on ArgumentError catch (e) {
      _error = e.message.toString();
      return false;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> cambiarEstado({
    required Pedido pedido,
    required EstadoPedido nuevoEstado,
  }) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final actualizado = await _updateEstadoPedido(
        pedido: pedido,
        nuevoEstado: nuevoEstado,
      );
      _replacePedido(actualizado);
      return true;
    } on ArgumentError catch (e) {
      _error = e.message.toString();
      return false;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> eliminarPedido(Pedido pedido) async {
    if (!pedido.estado.canDelete) {
      _error = 'Un pedido entregado no puede eliminarse';
      notifyListeners();
      return false;
    }
    if (pedido.id == null) {
      _error = 'El pedido no tiene un ID válido';
      notifyListeners();
      return false;
    }

    _loading = true;
    _error = null;
    notifyListeners();
    try {
      await _repository.deletePedido(pedido.id!);
      _pedidos = _pedidos.where((p) => p.id != pedido.id).toList();
      return true;
    } on StateError catch (e) {
      _error = e.message;
      return false;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  ({double subtotal, double descuento, double total}) calcularPrecio({
    required double precioUnitario,
    required int cantidad,
  }) {
    return _calculateDiscount(
      precioUnitario: precioUnitario,
      cantidad: cantidad,
    );
  }

  void _replacePedido(Pedido updated) {
    final index = _pedidos.indexWhere((p) => p.id == updated.id);
    if (index == -1) {
      _pedidos = [..._pedidos, updated];
    } else {
      final copy = [..._pedidos];
      copy[index] = updated;
      _pedidos = copy;
    }
  }
}
