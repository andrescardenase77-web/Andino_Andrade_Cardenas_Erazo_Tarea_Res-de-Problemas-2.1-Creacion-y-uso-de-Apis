import '../../domain/entities/cliente.dart';
import '../../domain/repositories/cliente_repository.dart';
import '../datasources/cliente_remote_datasource.dart';
import '../models/cliente_model.dart';

class ClienteRepositoryImpl implements ClienteRepository {
  final ClienteRemoteDataSource remote;
  ClienteRepositoryImpl(this.remote);

  @override
  Future<List<Cliente>> getClientes() => remote.fetchClientes();

  @override
  Future<Cliente> registerCliente(Cliente cliente) =>
      remote.createCliente(ClienteModel.fromEntity(cliente));
}