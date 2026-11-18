// Ruta: lib/features/pedidos/presentation/pages/order_creation_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../clientes/domain/entities/cliente.dart';
import '../../../clientes/presentation/viewmodels/cliente_viewmodel.dart';
import '../../../productos/domain/entities/producto.dart';
import '../../../productos/presentation/viewmodels/producto_viewmodel.dart';
import '../templates/order_creation_template.dart';
import '../viewmodels/pedido_viewmodel.dart';

class OrderCreationPage extends StatefulWidget {
  const OrderCreationPage({super.key});

  @override
  State<OrderCreationPage> createState() => _OrderCreationPageState();
}

class _OrderCreationPageState extends State<OrderCreationPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ClienteViewModel>().loadClientes();
      context.read<ProductoViewModel>().loadProductos();
    });
  }

  Future<void> _handleCreatePedido(
    Cliente cliente,
    Producto producto,
    int cantidad,
  ) async {
    final pedidoVM = context.read<PedidoViewModel>();
    final productoVM = context.read<ProductoViewModel>();

    final exitoso = await pedidoVM.crearPedido(
      cliente: cliente,
      producto: producto,
      cantidad: cantidad,
    );

    if (!mounted) return;

    if (exitoso) {
      // Regla de negocio 6: Al confirmar un pedido, el stock del producto disminuye.
      await productoVM.descontarStockPorPedido(producto, cantidad);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Pedido creado exitosamente!'),
          backgroundColor: Color(0xFF27AE60),
        ),
      );
      Navigator.pop(context);
    } else {
      final errorMsg = pedidoVM.error ?? 'Error al crear el pedido';
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
    final clienteVM = context.watch<ClienteViewModel>();
    final productoVM = context.watch<ProductoViewModel>();
    final pedidoVM = context.watch<PedidoViewModel>();

    final bool isDataLoading = clienteVM.loading || productoVM.loading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo Pedido'),
      ),
      body: isDataLoading
          ? const Center(child: CircularProgressIndicator())
          : OrderCreationTemplate(
              clientes: clienteVM.clientes,
              productos: productoVM.productos,
              loading: pedidoVM.loading,
              onSubmit: _handleCreatePedido,
            ),
    );
  }
}
