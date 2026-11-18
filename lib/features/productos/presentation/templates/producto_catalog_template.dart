import 'package:flutter/material.dart';
import '../../domain/entities/producto.dart';
import '../organisms/producto_card_organism.dart';

class ProductoCatalogTemplate extends StatelessWidget {
  final List<Producto> productos;
  final bool loading;
  final String? error;
  final String searchQuery;
  final bool soloConStock;
  final Future<void> Function() onRefresh;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<bool> onFilterStockChanged;
  final void Function(Producto producto, int nuevoStock)? onUpdateStock;
  final ValueChanged<Producto>? onSelectProducto;

  const ProductoCatalogTemplate({
    super.key,
    required this.productos,
    required this.loading,
    this.error,
    this.searchQuery = '',
    this.soloConStock = false,
    required this.onRefresh,
    required this.onSearchChanged,
    required this.onFilterStockChanged,
    this.onUpdateStock,
    this.onSelectProducto,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          // Puede reemplazarse por SearchBarField de core_ui/molecules.
          child: _CatalogSearchBar(
            query: searchQuery,
            onChanged: onSearchChanged,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              FilterChip(
                label: const Text('Todos'),
                selected: !soloConStock,
                onSelected: (_) => onFilterStockChanged(false),
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('Disponibles con stock'),
                selected: soloConStock,
                onSelected: (_) => onFilterStockChanged(true),
              ),
              const Spacer(),
              Text(
                '${productos.length} ítem(s)',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          ),
        ),
        Expanded(child: _buildBody(context)),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    if (loading && productos.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null && productos.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 12),
              Text(
                error!,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: onRefresh,
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (productos.isEmpty) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 120),
            Icon(Icons.coffee_outlined, size: 56, color: Colors.grey),
            SizedBox(height: 12),
            Center(
              child: Text('No se encontraron productos con el filtro actual'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 84),
        itemCount: productos.length,
        itemBuilder: (_, index) {
          final producto = productos[index];
          return ProductoCardOrganism(
            producto: producto,
            onTap: onSelectProducto != null
                ? () => onSelectProducto!(producto)
                : null,
            onStockChanged: onUpdateStock != null
                ? (nuevoStock) => onUpdateStock!(producto, nuevoStock)
                : null,
          );
        },
      ),
    );
  }
}

class _CatalogSearchBar extends StatefulWidget {
  final String query;
  final ValueChanged<String> onChanged;

  const _CatalogSearchBar({
    required this.query,
    required this.onChanged,
  });

  @override
  State<_CatalogSearchBar> createState() => _CatalogSearchBarState();
}

class _CatalogSearchBarState extends State<_CatalogSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.query);
  }

  @override
  void didUpdateWidget(covariant _CatalogSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.query != _controller.text) {
      _controller.value = TextEditingValue(
        text: widget.query,
        selection: TextSelection.collapsed(offset: widget.query.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        hintText: 'Buscar producto o categoría...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: widget.query.isNotEmpty
            ? IconButton(
                tooltip: 'Limpiar búsqueda',
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _controller.clear();
                  widget.onChanged('');
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        isDense: true,
      ),
    );
  }
}
