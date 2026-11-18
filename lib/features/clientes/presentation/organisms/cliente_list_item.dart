import 'package:flutter/material.dart';
import '../../domain/entities/cliente.dart';

class ClienteListItem extends StatelessWidget {
  final Cliente cliente;
  final VoidCallback? onTap;

  const ClienteListItem({super.key, required this.cliente, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          child: Text(cliente.nombre.isNotEmpty
              ? cliente.nombre[0].toUpperCase()
              : '?'),
        ),
        title: Text(cliente.nombre),
        subtitle: Text('${cliente.telefono}\n${cliente.email}'),
        isThreeLine: true,
      ),
    );
  }
}