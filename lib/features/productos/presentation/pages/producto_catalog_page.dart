import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/producto.dart';
import '../templates/producto_catalog_template.dart';
import '../viewmodels/producto_viewmodel.dart';

class ProductoCatalogPage extends StatefulWidget {
  const ProductoCatalogPage({super.key});

  @override
  State<ProductoCatalogPage> createState() => _ProductoCatalogPageState();
}

class _ProductoCatalogPageState extends State<ProductoCatalogPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<ProductoViewModel>().loadProductos(),
    );
  }

  Future<void> _handleStockChange(Producto producto, int nuevoStock) async {
    if (producto.id == null) return;
    final vm = context.read<ProductoViewModel>();
    final ok = await vm.actualizarStock(producto.id!, nuevoStock);
    if (!mounted || ok) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(vm.error ?? 'No se pudo actualizar el stock')),
    );
  }

  void _openEditStockDialog(Producto producto) {
    if (producto.id == null) return;
    final stockCtrl = TextEditingController(text: producto.stock.toString());
    final formKey = GlobalKey<FormState>();

    showDialog<void>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text('Ajustar stock: ${producto.nombre}'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: stockCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Stock disponible',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              final parsed = int.tryParse(value?.trim() ?? '');
              if (parsed == null || parsed < 0) {
                return 'Ingresa un número entero >= 0';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              final nuevoStock = int.parse(stockCtrl.text.trim());
              Navigator.pop(dialogCtx);
              await _handleStockChange(producto, nuevoStock);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    ).whenComplete(stockCtrl.dispose);
  }

  void _openCreateProductSheet() {
    final formKey = GlobalKey<FormState>();
    final nombreCtrl = TextEditingController();
    final descripcionCtrl = TextEditingController();
    final precioCtrl = TextEditingController();
    final stockCtrl = TextEditingController();
    String categoria = 'Bebidas Calientes';
    const categorias = [
      'Bebidas Calientes',
      'Bebidas Frías',
      'Panadería',
      'Postres',
      'Cafetería',
    ];

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetCtx) => StatefulBuilder(
        builder: (_, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 20,
            bottom: MediaQuery.of(sheetCtx).viewInsets.bottom + 20,
          ),
          child: Consumer<ProductoViewModel>(
            builder: (_, vm, _) => Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Registrar Producto',
                      style: Theme.of(sheetCtx).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: nombreCtrl,
                      decoration: const InputDecoration(labelText: 'Nombre'),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Campo obligatorio'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: descripcionCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Descripción (opcional)',
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: categoria,
                      decoration: const InputDecoration(labelText: 'Categoría'),
                      items: categorias
                          .map(
                            (c) => DropdownMenuItem(value: c, child: Text(c)),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setModalState(() => categoria = value);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: precioCtrl,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Precio (USD)',
                      ),
                      validator: (v) {
                        final parsed = double.tryParse(
                          (v ?? '').trim().replaceAll(',', '.'),
                        );
                        if (parsed == null || parsed <= 0) {
                          return 'El precio debe ser mayor que 0';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: stockCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Stock inicial',
                      ),
                      validator: (v) {
                        final parsed = int.tryParse((v ?? '').trim());
                        if (parsed == null || parsed < 0) {
                          return 'Ingresa un stock entero >= 0';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: vm.loading
                          ? null
                          : () async {
                              if (!formKey.currentState!.validate()) return;
                              final precio = double.parse(
                                precioCtrl.text.trim().replaceAll(',', '.'),
                              );
                              final stock = int.parse(stockCtrl.text.trim());
                              final ok = await vm.registrarProducto(
                                Producto(
                                  nombre: nombreCtrl.text.trim(),
                                  descripcion: descripcionCtrl.text.trim(),
                                  precio: precio,
                                  stock: stock,
                                  categoria: categoria,
                                ),
                              );
                              if (!sheetCtx.mounted) return;
                              if (ok) {
                                Navigator.pop(sheetCtx);
                              } else {
                                ScaffoldMessenger.of(sheetCtx).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      vm.error ?? 'Error al registrar producto',
                                    ),
                                  ),
                                );
                              }
                            },
                      child: vm.loading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Guardar producto'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ).whenComplete(() {
      nombreCtrl.dispose();
      descripcionCtrl.dispose();
      precioCtrl.dispose();
      stockCtrl.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProductoViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Productos de Cafetería')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreateProductSheet,
        icon: const Icon(Icons.add),
        label: const Text('Nuevo producto'),
      ),
      body: ProductoCatalogTemplate(
        productos: vm.productos,
        loading: vm.loading,
        error: vm.error,
        searchQuery: vm.searchQuery,
        soloConStock: vm.soloConStock,
        onRefresh: vm.loadProductos,
        onSearchChanged: vm.setSearchQuery,
        onFilterStockChanged: (value) => vm.toggleSoloConStock(value),
        onUpdateStock: _handleStockChange,
        onSelectProducto: _openEditStockDialog,
      ),
    );
  }
}
