import '../entities/cliente.dart';
import '../repositories/cliente_repository.dart';

class RegisterCliente {
  final ClienteRepository repository;
  RegisterCliente(this.repository);

  Future<Cliente> call(Cliente cliente) {
    if (cliente.nombre.trim().isEmpty) {
      throw ArgumentError('El nombre es obligatorio');
    }
    if (cliente.telefono.trim().length < 7) {
      throw ArgumentError('Teléfono inválido');
    }
    final emailOk = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(cliente.email);
    if (!emailOk) {
      throw ArgumentError('Correo inválido');
    }
    return repository.registerCliente(cliente);
  }
}