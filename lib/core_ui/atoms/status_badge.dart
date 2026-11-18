import 'package:flutter/material.dart';
import '../../app/config/app_theme.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  final double fontSize;

  const StatusBadge({
    super.key,
    required this.status,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    final statusConfig = _resolveStatus(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: statusConfig.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: statusConfig.color.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            statusConfig.icon,
            size: fontSize + 2,
            color: statusConfig.color,
          ),
          const SizedBox(width: 5),
          Text(
            statusConfig.label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: statusConfig.color,
            ),
          ),
        ],
      ),
    );
  }

  _StatusConfig _resolveStatus(String rawStatus) {
    final normalized = rawStatus.toLowerCase().trim();
    switch (normalized) {
      case 'preparando':
        return const _StatusConfig(
          label: 'Preparando',
          color: AppTheme.statusPreparando,
          icon: Icons.local_cafe,
        );
      case 'entregado':
        return const _StatusConfig(
          label: 'Entregado',
          color: AppTheme.statusEntregado,
          icon: Icons.check_circle_outline,
        );
      case 'cancelado':
        return const _StatusConfig(
          label: 'Cancelado',
          color: AppTheme.statusCancelado,
          icon: Icons.cancel_outlined,
        );
      case 'pendiente':
      default:
        return const _StatusConfig(
          label: 'Pendiente',
          color: AppTheme.statusPendiente,
          icon: Icons.access_time,
        );
    }
  }
}

class _StatusConfig {
  final String label;
  final Color color;
  final IconData icon;

  const _StatusConfig({
    required this.label,
    required this.color,
    required this.icon,
  });
}
