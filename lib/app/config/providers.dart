import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../network/api_client.dart';

import '../../features/clientes/data/datasources/cliente_remote_datasource.dart';
import '../../features/clientes/data/repositories/cliente_repository_impl.dart';
import '../../features/clientes/domain/usecases/get_clientes.dart';
import '../../features/clientes/domain/usecases/register_cliente.dart';
import '../../features/clientes/presentation/viewmodels/cliente_viewmodel.dart';

import '../../features/productos/data/datasources/producto_remote_datasource.dart';
import '../../features/productos/data/repositories/producto_repository_impl.dart';
import '../../features/productos/domain/usecases/get_productos.dart';
import '../../features/productos/domain/usecases/update_stock.dart';
import '../../features/productos/presentation/viewmodels/producto_viewmodel.dart';

// import '../../features/pedidos/presentation/viewmodels/pedido_viewmodel.dart';

List<SingleChildWidget> getAppProviders() {
  final apiClient = ApiClient();

  final clienteRemoteDataSource = ClienteRemoteDataSourceImpl(apiClient);
  final clienteRepository = ClienteRepositoryImpl(clienteRemoteDataSource);
  final getClientesUseCase = GetClientes(clienteRepository);
  final registerClienteUseCase = RegisterCliente(clienteRepository);

  final productoRemoteDataSource = ProductoRemoteDataSourceImpl(apiClient);
  final productoRepository = ProductoRepositoryImpl(productoRemoteDataSource);
  final getProductosUseCase = GetProductos(productoRepository);
  final updateStockUseCase = UpdateStock(productoRepository);

  return [
    Provider<ApiClient>.value(value: apiClient),
    ChangeNotifierProvider<ClienteViewModel>(
      create: (_) => ClienteViewModel(
        getClientesUseCase,
        registerClienteUseCase,
      ),
    ),
    ChangeNotifierProvider<ProductoViewModel>(
      create: (_) => ProductoViewModel(
        getProductosUseCase,
        updateStockUseCase,
        productoRepository,
      ),
    ),
    // ChangeNotifierProvider<PedidoViewModel>(
    //   create: (_) => PedidoViewModel(...),
    // ),
  ];
}
