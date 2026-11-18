// Ruta: lib/features/pedidos/presentation/pages/order_list_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/config/app_routes.dart';
import '../../../../core_ui/atoms/loading_indicator.dart';
import '../../../productos/presentation/viewmodels/producto_viewmodel.dart';
import '../../domain/entities/estado_pedido.dart';
import '../../domain/entities/pedido.dart';
import '../organisms/order_summary_organism.dart';
import '../viewmodels/pedido_viewmodel.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({super.key});

  @override
  State<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PedidoViewModel>().loadPedidos();
    });
  }

  void _showChangeStatusDialog(Pedido pedido) {
    final availableStates = EstadoPedido.values
        .where((st) => pedido.estado.canTransitionTo(st))
        .toList();

    if (availableStates.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('El pedido en estado "${pedido.estado.label}" no puede cambiar de estado.'),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Cambiar estado del Pedido #${pedido.id}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: availableStates.map((st) {
              return ListTile(
                leading: Icon(
                  st == EstadoPedido.cancelado
                      ? Icons.cancel_outlined
                      : Icons.play_arrow,
                  color: st == EstadoPedido.cancelado ? Colors.red : Colors.brown,
                ),
                title: Text(st.label),
                onTap: () async {
                  Navigator.pop(dialogContext);
                  await _handleChangeStatus(pedido, st);
                },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleChangeStatus(Pedido pedido, EstadoPedido nuevoEstado) async {
    final pedidoVM = context.read<PedidoViewModel>();
    final productoVM = context.read<ProductoViewModel>();

    final bool exitoso = await pedidoVM.cambiarEstado(
      pedido: pedido,
      nuevoEstado: nuevoEstado,
    );

    if (!mounted) return;

    if (exitoso) {
      // Regla de negocio 9: Cancelar un pedido antes de entregarlo restaura el stock.
      if (nuevoEstado == EstadoPedido.cancelado) {
        final producto = productoVM.findById(pedido.productoId);
        if (producto != null) {
          await productoVM.restaurarStockPorCancelacion(producto, pedido.cantidad);
        }
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Estado actualizado a "${nuevoEstado.label}"'),
          backgroundColor: const Color(0xFF27AE60),
        ),
      );
    } else {
      final errorMsg = pedidoVM.error ?? 'Error al actualizar el estado';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMsg),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showDeleteConfirmDialog(Pedido pedido) {
    if (!pedido.estado.canDelete) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Un pedido entregado no puede eliminarse.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: Text('¿Está seguro de eliminar el pedido #${pedido.id}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                Navigator.pop(dialogContext);
                await _handleDeletePedido(pedido);
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleDeletePedido(Pedido pedido) async {
    final pedidoVM = context.read<PedidoViewModel>();

    final exitoso = await pedidoVM.eliminarPedido(pedido);

    if (!mounted) return;

    if (exitoso) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pedido eliminado correctamente'),
          backgroundColor: Color(0xFF27AE60),
        ),
      );
    } else {
      final errorMsg = pedidoVM.error ?? 'Error al eliminar el pedido';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMsg),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final pedidoVM = context.watch<PedidoViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.crearPedido);
        },
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Pedido'),
      ),
      body: _buildBody(pedidoVM),
    );
  }

  Widget _buildBody(PedidoViewModel pedidoVM) {
    if (pedidoVM.loading && pedidoVM.pedidos.isEmpty) {
      return const LoadingIndicator(message: 'Cargando pedidos...');
    }

    if (pedidoVM.error != null && pedidoVM.pedidos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            Text(
              pedidoVM.error!,
              style: const TextStyle(color: Colors.red, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => context.read<PedidoViewModel>().loadPedidos(),
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (pedidoVM.pedidos.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => context.read<PedidoViewModel>().loadPedidos(),
        child: ListView(
          children: const [
            SizedBox(height: 100),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No hay pedidos registrados',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<PedidoViewModel>().loadPedidos(),
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 80),
        itemCount: pedidoVM.pedidos.length,
        itemBuilder: (context, index) {
          final pedido = pedidoVM.pedidos[index];
          return OrderSummaryOrganism(
            pedido: pedido,
            onChangeStatus: () => _showChangeStatusDialog(pedido),
            onDelete: () => _showDeleteConfirmDialog(pedido),
          );
        },
      ),
    );
  }
}
