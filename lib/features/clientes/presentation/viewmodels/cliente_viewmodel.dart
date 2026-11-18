import 'package:flutter/foundation.dart';
import '../../domain/entities/cliente.dart';
import '../../domain/usecases/get_clientes.dart';
import '../../domain/usecases/register_cliente.dart';

class ClienteViewModel extends ChangeNotifier {
  final GetClientes _getClientes;
  final RegisterCliente _registerCliente;

  ClienteViewModel(this._getClientes, this._registerCliente);

  List<Cliente> _clientes = [];
  bool _loading = false;
  String? _error;

  List<Cliente> get clientes => _clientes;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> loadClientes() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _clientes = await _getClientes();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// Devuelve true si se registró correctamente.
  Future<bool> registrar(Cliente cliente) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final nuevo = await _registerCliente(cliente);
      _clientes = [..._clientes, nuevo];
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
}