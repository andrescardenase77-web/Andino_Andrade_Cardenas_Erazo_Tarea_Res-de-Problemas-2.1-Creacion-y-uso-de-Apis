import '../entities/cliente.dart';

abstract class ClienteRepository {
  Future<List<Cliente>> getClientes();
  Future<Cliente> registerCliente(Cliente cliente);
}