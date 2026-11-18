// Ruta: lib/features/pedidos/presentation/templates/order_creation_template.dart

import 'package:flutter/material.dart';
import '../../../../core_ui/atoms/custom_button.dart';
import '../../../../core_ui/molecules/quantity_selector.dart';
import '../../../../core_ui/molecules/summary_price_card.dart';
import '../../../clientes/domain/entities/cliente.dart';
import '../../../productos/domain/entities/producto.dart';

class OrderCreationTemplate extends StatefulWidget {
  final List<Cliente> clientes;
  final List<Producto> productos;
  final bool loading;
  final Future<void> Function(Cliente cliente, Producto producto, int cantidad) onSubmit;

  const OrderCreationTemplate({
    super.key,
    required this.clientes,
    required this.productos,
    required this.loading,
    required this.onSubmit,
  });

  @override
  State<OrderCreationTemplate> createState() => _OrderCreationTemplateState();
}

class _OrderCreationTemplateState extends State<OrderCreationTemplate> {
  final _formKey = GlobalKey<FormState>();
  Cliente? _selectedCliente;
  Producto? _selectedProducto;
  int _cantidad = 1;

  List<Producto> get _productosConStock =>
      widget.productos.where((p) => p.tieneStock).toList();

  void _onProductoChanged(Producto? p) {
    setState(() {
      _selectedProducto = p;
      _cantidad = 1;
    });
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      if (_selectedCliente == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor seleccione un cliente')),
        );
        return;
      }
      if (_selectedProducto == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor seleccione un producto')),
        );
        return;
      }
      widget.onSubmit(_selectedCliente!, _selectedProducto!, _cantidad);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Datos del Pedido',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2B1A0E),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Cliente>(
              decoration: const InputDecoration(
                labelText: 'Cliente',
                hintText: 'Seleccione un cliente',
                prefixIcon: Icon(Icons.person_outline),
              ),
              initialValue: _selectedCliente,
              items: widget.clientes.map((c) {
                return DropdownMenuItem<Cliente>(
                  value: c,
                  child: Text(c.nombre),
                );
              }).toList(),
              onChanged: (c) => setState(() => _selectedCliente = c),
              validator: (val) =>
                  val == null ? 'Seleccionar un cliente es obligatorio' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Producto>(
              decoration: const InputDecoration(
                labelText: 'Producto (solo con stock)',
                hintText: 'Seleccione un producto',
                prefixIcon: Icon(Icons.coffee_outlined),
              ),
              initialValue: _selectedProducto,
              items: _productosConStock.map((p) {
                return DropdownMenuItem<Producto>(
                  value: p,
                  child: Text('${p.nombre} - \$${p.precio.toStringAsFixed(2)} (Stock: ${p.stock})'),
                );
              }).toList(),
              onChanged: _onProductoChanged,
              validator: (val) =>
                  val == null ? 'Seleccionar un producto es obligatorio' : null,
            ),
            const SizedBox(height: 20),
            if (_selectedProducto != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Cantidad:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2B1A0E),
                    ),
                  ),
                  QuantitySelector(
                    quantity: _cantidad,
                    maxStock: _selectedProducto!.stock,
                    onChanged: (val) => setState(() => _cantidad = val),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SummaryPriceCard(
                unitPrice: _selectedProducto!.precio,
                quantity: _cantidad,
              ),
              const SizedBox(height: 24),
            ],
            CustomButton(
              text: 'Confirmar Pedido',
              icon: Icons.check_circle_outline,
              isLoading: widget.loading,
              onPressed: _handleSubmit,
            ),
          ],
        ),
      ),
    );
  }
}
