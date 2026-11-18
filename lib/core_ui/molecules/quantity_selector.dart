import 'package:flutter/material.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final int maxStock;
  final ValueChanged<int> onChanged;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.maxStock,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool sinStock = maxStock <= 0;
    final bool puedeDecrementar = !sinStock && quantity > 1;
    final bool puedeIncrementar = !sinStock && quantity < maxStock;

    if (sinStock) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.shade200),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red, size: 20),
            SizedBox(width: 8),
            Text(
              'Producto sin stock disponible',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5DACF)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _IconButtonCircle(
            icon: Icons.remove,
            enabled: puedeDecrementar,
            onPressed: puedeDecrementar ? () => onChanged(quantity - 1) : null,
          ),
          Container(
            constraints: const BoxConstraints(minWidth: 46),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$quantity',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2B1A0E),
                  ),
                ),
                Text(
                  'Máx: $maxStock',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF7A6A5E),
                  ),
                ),
              ],
            ),
          ),
          _IconButtonCircle(
            icon: Icons.add,
            enabled: puedeIncrementar,
            onPressed: puedeIncrementar ? () => onChanged(quantity + 1) : null,
          ),
        ],
      ),
    );
  }
}

class _IconButtonCircle extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback? onPressed;

  const _IconButtonCircle({
    required this.icon,
    required this.enabled,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: enabled ? theme.colorScheme.primary : Colors.grey.shade300,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(
            icon,
            size: 18,
            color: enabled ? Colors.white : Colors.grey.shade500,
          ),
        ),
      ),
    );
  }
}
