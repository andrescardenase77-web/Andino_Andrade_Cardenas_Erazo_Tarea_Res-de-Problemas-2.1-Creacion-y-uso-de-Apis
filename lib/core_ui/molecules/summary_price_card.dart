import 'package:flutter/material.dart';

class SummaryPriceCard extends StatelessWidget {
  final double unitPrice;
  final int quantity;
  final String currency;

  const SummaryPriceCard({
    super.key,
    required this.unitPrice,
    required this.quantity,
    this.currency = 'USD',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final double subtotal = unitPrice * quantity;
    final bool aplicaDescuento = subtotal > 50.0;
    final double descuento = aplicaDescuento ? (subtotal * 0.10) : 0.0;
    final double total = subtotal - descuento;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Resumen del Pedido',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2B1A0E),
                  ),
                ),
                if (aplicaDescuento)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF27AE60).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF27AE60), width: 0.8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.local_offer_outlined, size: 14, color: Color(0xFF27AE60)),
                        SizedBox(width: 4),
                        Text(
                          '10% OFF aplicado',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF27AE60),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            _PriceRow(
              label: 'Precio unitario ($currency)',
              value: '\$${unitPrice.toStringAsFixed(2)}',
            ),
            const SizedBox(height: 6),
            _PriceRow(
              label: 'Cantidad solicitada',
              value: 'x$quantity',
            ),
            const SizedBox(height: 6),
            _PriceRow(
              label: 'Subtotal',
              value: '\$${subtotal.toStringAsFixed(2)}',
            ),
            if (aplicaDescuento) ...[
              const SizedBox(height: 6),
              _PriceRow(
                label: 'Descuento especial (> \$50)',
                value: '-\$${descuento.toStringAsFixed(2)}',
                valueColor: const Color(0xFF27AE60),
                isBold: true,
              ),
            ],
            const Divider(height: 22),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total a Pagar',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2B1A0E),
                  ),
                ),
                Text(
                  '\$${total.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isBold;

  const _PriceRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
            fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: valueColor ?? const Color(0xFF2B1A0E),
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
