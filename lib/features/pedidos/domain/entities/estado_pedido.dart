// Ruta: lib/features/pedidos/domain/entities/estado_pedido.dart

enum EstadoPedido {
  pendiente,
  preparando,
  entregado,
  cancelado;

  String get label {
    switch (this) {
      case EstadoPedido.pendiente:
        return 'Pendiente';
      case EstadoPedido.preparando:
        return 'Preparando';
      case EstadoPedido.entregado:
        return 'Entregado';
      case EstadoPedido.cancelado:
        return 'Cancelado';
    }
  }

  bool canTransitionTo(EstadoPedido next) {
    if (this == next) return false;
    switch (this) {
      case EstadoPedido.pendiente:
        return next == EstadoPedido.preparando ||
            next == EstadoPedido.entregado ||
            next == EstadoPedido.cancelado;
      case EstadoPedido.preparando:
        return next == EstadoPedido.entregado ||
            next == EstadoPedido.cancelado;
      case EstadoPedido.entregado:
        return false;
      case EstadoPedido.cancelado:
        return false;
    }
  }

  bool get canDelete => this != EstadoPedido.entregado;

  static EstadoPedido fromString(String raw) {
    final normalized = raw.toLowerCase().trim();
    switch (normalized) {
      case 'preparando':
        return EstadoPedido.preparando;
      case 'entregado':
        return EstadoPedido.entregado;
      case 'cancelado':
        return EstadoPedido.cancelado;
      case 'pendiente':
      default:
        return EstadoPedido.pendiente;
    }
  }
}
