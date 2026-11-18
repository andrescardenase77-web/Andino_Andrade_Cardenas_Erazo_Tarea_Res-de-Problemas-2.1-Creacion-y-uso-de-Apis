class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'https://mockapi.io/api/v1';
  static const Duration requestTimeout = Duration(seconds: 15);

  static const String productos = '/productos';
  static String productoDetalle(dynamic id) => '/productos/$id';

  static const String clientes = '/clientes';
  static String clienteDetalle(dynamic id) => '/clientes/$id';

  static const String pedidos = '/pedidos';
  static String pedidoDetalle(dynamic id) => '/pedidos/$id';
}
