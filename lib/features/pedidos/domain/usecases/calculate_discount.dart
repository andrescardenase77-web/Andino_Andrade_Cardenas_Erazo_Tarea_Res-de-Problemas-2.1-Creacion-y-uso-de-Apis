// Ruta: lib/features/pedidos/domain/usecases/calculate_discount.dart

class CalculateDiscount {
  ({double subtotal, double descuento, double total}) call({
    required double precioUnitario,
    required int cantidad,
  }) {
    if (precioUnitario < 0 || cantidad <= 0) {
      return (subtotal: 0.0, descuento: 0.0, total: 0.0);
    }

    final double subtotal = precioUnitario * cantidad;
    final double descuento = subtotal > 50.0 ? (subtotal * 0.10) : 0.0;
    final double total = subtotal - descuento;

    return (subtotal: subtotal, descuento: descuento, total: total);
  }
}
