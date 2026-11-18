// Ruta: lib/features/pedidos/domain/entities/pedido.dart

import 'estado_pedido.dart';

class Pedido {
  final int? id;
  final int clienteId;
  final String clienteNombre;
  final int productoId;
  final String productoNombre;
  final int cantidad;
  final double precioUnitario;
  final double subtotal;
  final double descuento;
  final double total;
  final EstadoPedido estado;
  final DateTime? fechaCreacion;

  const Pedido({
    this.id,
    required this.clienteId,
    required this.clienteNombre,
    required this.productoId,
    required this.productoNombre,
    required this.cantidad,
    required this.precioUnitario,
    required this.subtotal,
    required this.descuento,
    required this.total,
    required this.estado,
    this.fechaCreacion,
  });

  bool get aplicaDescuento => subtotal > 50.0;

  Pedido copyWith({
    int? id,
    int? clienteId,
    String? clienteNombre,
    int? productoId,
    String? productoNombre,
    int? cantidad,
    double? precioUnitario,
    double? subtotal,
    double? descuento,
    double? total,
    EstadoPedido? estado,
    DateTime? fechaCreacion,
  }) {
    return Pedido(
      id: id ?? this.id,
      clienteId: clienteId ?? this.clienteId,
      clienteNombre: clienteNombre ?? this.clienteNombre,
      productoId: productoId ?? this.productoId,
      productoNombre: productoNombre ?? this.productoNombre,
      cantidad: cantidad ?? this.cantidad,
      precioUnitario: precioUnitario ?? this.precioUnitario,
      subtotal: subtotal ?? this.subtotal,
      descuento: descuento ?? this.descuento,
      total: total ?? this.total,
      estado: estado ?? this.estado,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    );
  }
}
