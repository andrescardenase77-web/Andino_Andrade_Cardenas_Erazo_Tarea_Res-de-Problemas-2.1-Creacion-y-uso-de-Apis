import 'package:flutter/foundation.dart';
import '../../domain/entities/producto.dart';
import '../../domain/repositories/producto_repository.dart';
import '../../domain/usecases/get_productos.dart';
import '../../domain/usecases/update_stock.dart';

class ProductoViewModel extends ChangeNotifier {
  final GetProductos _getProductos;
  final UpdateStock _updateStock;
  final ProductoRepository? _repository;

  ProductoViewModel(
    this._getProductos,
    this._updateStock, [
    this._repository,
  ]);

  List<Producto> _productos = [];
  bool _loading = false;
  String? _error;
  String _searchQuery = '';
  bool _soloConStock = false;

  List<Producto> get productos {
    final query = _searchQuery.trim().toLowerCase();
    return _productos.where((p) {
      if (_soloConStock && !p.tieneStock) {
        return false;
      }
      if (query.isEmpty) {
        return true;
      }
      return p.nombre.toLowerCase().contains(query) ||
          p.categoria.toLowerCase().contains(query) ||
          p.descripcion.toLowerCase().contains(query);
    }).toList();
  }

  List<Producto> get todosLosProductos => List.unmodifiable(_productos);

  List<Producto> get productosDisponibles =>
      _productos.where((p) => p.tieneStock).toList();

  bool get loading => _loading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  bool get soloConStock => _soloConStock;

  Future<void> loadProductos() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _productos = await _getProductos();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> actualizarStock(int productoId, int nuevoStock) =>
      _executeUpdate(() => _updateStock(productoId, nuevoStock));

  Future<bool> descontarStockPorPedido(Producto producto, int cantidad) =>
      _executeUpdate(
        () => _updateStock.descontarPorPedido(
          producto: producto,
          cantidad: cantidad,
        ),
      );

  Future<bool> restaurarStockPorCancelacion(Producto producto, int cantidad) =>
      _executeUpdate(
        () => _updateStock.restaurarPorCancelacion(
          producto: producto,
          cantidad: cantidad,
        ),
      );

  Future<bool> registrarProducto(Producto producto) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      if (producto.nombre.trim().isEmpty) {
        throw ArgumentError('El nombre del producto es obligatorio');
      }
      if (producto.precio <= 0) {
        throw ArgumentError('El precio debe ser mayor que 0');
      }
      if (producto.stock < 0) {
        throw ArgumentError('El stock inicial no puede ser negativo');
      }
      final repo = _repository ?? _updateStock.repository;
      final nuevo = await repo.createProducto(producto);
      _productos = [..._productos, nuevo];
      return true;
    } on ArgumentError catch (e) {
      _error = e.message.toString();
      return false;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> _executeUpdate(Future<Producto> Function() action) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final actualizado = await action();
      _replaceProducto(actualizado);
      return true;
    } on ArgumentError catch (e) {
      _error = e.message.toString();
      return false;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void _replaceProducto(Producto updated) {
    final index = _productos.indexWhere((p) => p.id == updated.id);
    if (index == -1) {
      _productos = [..._productos, updated];
    } else {
      final copy = [..._productos];
      copy[index] = updated;
      _productos = copy;
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void toggleSoloConStock([bool? value]) {
    _soloConStock = value ?? !_soloConStock;
    notifyListeners();
  }

  Producto? findById(int id) {
    for (final p in _productos) {
      if (p.id == id) return p;
    }
    return null;
  }
}
