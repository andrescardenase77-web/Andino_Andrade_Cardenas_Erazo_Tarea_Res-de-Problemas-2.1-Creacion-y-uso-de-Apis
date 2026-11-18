import 'package:flutter/material.dart';
import '../../domain/entities/producto.dart';

class ProductoCardOrganism extends StatelessWidget {
  final Producto producto;
  final ValueChanged<int>? onStockChanged;
  final VoidCallback? onTap;

  const ProductoCardOrganism({
    super.key,
    required this.producto,
    this.onStockChanged,
    this.onTap,
  });

  IconData _iconForCategory(String categoria) {
    final normalized = categoria.toLowerCase();
    if (normalized.contains('fría') || normalized.contains('fria')) {
      return Icons.local_drink;
    }
    if (normalized.contains('pan')) {
      return Icons.bakery_dining;
    }
    if (normalized.contains('postre')) {
      return Icons.cake;
    }
    return Icons.local_cafe;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final disponible = producto.tieneStock;
    final badgeBg = disponible ? Colors.green.shade50 : Colors.red.shade50;
    final badgeFg = disponible ? Colors.green.shade800 : Colors.red.shade800;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: disponible
                    ? theme.colorScheme.primaryContainer
                    : Colors.grey.shade200,
                child: Icon(
                  _iconForCategory(producto.categoria),
                  color: disponible
                      ? theme.colorScheme.onPrimaryContainer
                      : Colors.grey.shade600,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      producto.nombre,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      producto.categoria,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    if (producto.descripcion.trim().isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        producto.descripcion,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          'USD \$${producto.precio.toStringAsFixed(2)}',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Puede reemplazarse por StatusBadge de core_ui/atoms.
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: badgeBg,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: badgeFg.withValues(alpha: 0.35),
                            ),
                          ),
                          child: Text(
                            disponible
                                ? 'En stock: ${producto.stock}'
                                : 'Sin stock',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: badgeFg,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (onStockChanged != null) ...[
                const SizedBox(width: 8),
                // Puede reemplazarse por QuantitySelector de core_ui/molecules.
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: 'Disminuir stock',
                          icon: const Icon(Icons.remove_circle_outline),
                          visualDensity: VisualDensity.compact,
                          onPressed: producto.stock > 0
                              ? () => onStockChanged!(producto.stock - 1)
                              : null,
                        ),
                        IconButton(
                          tooltip: 'Aumentar stock',
                          icon: const Icon(Icons.add_circle_outline),
                          visualDensity: VisualDensity.compact,
                          onPressed: () => onStockChanged!(producto.stock + 1),
                        ),
                      ],
                    ),
                    if (onTap != null)
                      TextButton(
                        onPressed: onTap,
                        style: TextButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        child: const Text('Editar'),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
