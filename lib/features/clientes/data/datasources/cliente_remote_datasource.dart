import '../../../../app/network/api_client.dart';
import '../../../../app/network/api_endpoints.dart';
import '../models/cliente_model.dart';

abstract class ClienteRemoteDataSource {
  Future<List<ClienteModel>> fetchClientes();
  Future<ClienteModel> createCliente(ClienteModel cliente);
}

class ClienteRemoteDataSourceImpl implements ClienteRemoteDataSource {
  final ApiClient client;
  ClienteRemoteDataSourceImpl(this.client);

  @override
  Future<List<ClienteModel>> fetchClientes() async {
    final data = await client.get(ApiEndpoints.clientes) as List;
    return data
        .map((e) => ClienteModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ClienteModel> createCliente(ClienteModel cliente) async {
    final data = await client.post(
      ApiEndpoints.clientes,
      data: cliente.toJson(),
    );
    return ClienteModel.fromJson(data as Map<String, dynamic>);
  }
}