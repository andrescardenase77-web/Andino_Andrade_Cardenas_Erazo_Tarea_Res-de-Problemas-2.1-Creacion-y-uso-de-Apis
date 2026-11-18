// Ruta: lib/features/pedidos/data/models/pedido_model.dart

import '../../domain/entities/estado_pedido.dart';
import '../../domain/entities/pedido.dart';

class PedidoModel extends Pedido {
  const PedidoModel({
    super.id,
    required super.clienteId,
    required super.clienteNombre,
    required super.productoId,
    required super.productoNombre,
    required super.cantidad,
    required super.precioUnitario,
    required super.subtotal,
    required super.descuento,
    required super.total,
    required super.estado,
    super.fechaCreacion,
  });

  factory PedidoModel.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'] ?? json['pedidoId'] ?? json['idPedido'];
    final rawClienteId = json['clienteId'] ?? json['idCliente'] ?? json['cliente_id'] ?? 0;
    final rawProductoId = json['productoId'] ?? json['idProducto'] ?? json['producto_id'] ?? 0;
    final rawCantidad = json['cantidad'] ?? json['quantity'] ?? 1;
    final rawPrecio = json['precioUnitario'] ?? json['precio'] ?? json['price'] ?? 0;
    final rawSubtotal = json['subtotal'] ?? 0;
    final rawDescuento = json['descuento'] ?? json['discount'] ?? 0;
    final rawTotal = json['total'] ?? 0;
    final rawEstado = (json['estado'] ?? json['status'] ?? 'Pendiente').toString();
    final rawFecha = json['fechaCreacion'] ?? json['fecha'] ?? json['createdAt'];

    final double precioUnitario = rawPrecio is num
        ? rawPrecio.toDouble()
        : double.tryParse(rawPrecio.toString()) ?? 0.0;

    final int cantidad = rawCantidad is int
        ? rawCantidad
        : (rawCantidad is num
            ? rawCantidad.toInt()
            : int.tryParse(rawCantidad.toString()) ?? 1);

    final double subtotal = rawSubtotal is num
        ? rawSubtotal.toDouble()
        : double.tryParse(rawSubtotal.toString()) ?? (precioUnitario * cantidad);

    final double descuento = rawDescuento is num
        ? rawDescuento.toDouble()
        : double.tryParse(rawDescuento.toString()) ?? (subtotal > 50.0 ? subtotal * 0.10 : 0.0);

    final double total = rawTotal is num
        ? rawTotal.toDouble()
        : double.tryParse(rawTotal.toString()) ?? (subtotal - descuento);

    DateTime? fechaCreacion;
    if (rawFecha != null) {
      fechaCreacion = DateTime.tryParse(rawFecha.toString());
    }

    return PedidoModel(
      id: rawId is int ? rawId : int.tryParse(rawId?.toString() ?? ''),
      clienteId: rawClienteId is int
          ? rawClienteId
          : int.tryParse(rawClienteId.toString()) ?? 0,
      clienteNombre: (json['clienteNombre'] ?? json['nombreCliente'] ?? json['cliente'] ?? '').toString(),
      productoId: rawProductoId is int
          ? rawProductoId
          : int.tryParse(rawProductoId.toString()) ?? 0,
      productoNombre: (json['productoNombre'] ?? json['nombreProducto'] ?? json['producto'] ?? '').toString(),
      cantidad: cantidad,
      precioUnitario: precioUnitario,
      subtotal: subtotal,
      descuento: descuento,
      total: total,
      estado: EstadoPedido.fromString(rawEstado),
      fechaCreacion: fechaCreacion,
    );
  }

  factory PedidoModel.fromEntity(Pedido p) => PedidoModel(
        id: p.id,
        clienteId: p.clienteId,
        clienteNombre: p.clienteNombre,
        productoId: p.productoId,
        productoNombre: p.productoNombre,
        cantidad: p.cantidad,
        precioUnitario: p.precioUnitario,
        subtotal: p.subtotal,
        descuento: p.descuento,
        total: p.total,
        estado: p.estado,
        fechaCreacion: p.fechaCreacion,
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'clienteId': clienteId,
        'clienteNombre': clienteNombre,
        'productoId': productoId,
        'productoNombre': productoNombre,
        'cantidad': cantidad,
        'precioUnitario': precioUnitario,
        'subtotal': subtotal,
        'descuento': descuento,
        'total': total,
        'estado': estado.label,
        if (fechaCreacion != null) 'fechaCreacion': fechaCreacion!.toIso8601String(),
      };
}
