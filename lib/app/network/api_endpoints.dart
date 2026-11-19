class ApiEndpoints {
  ApiEndpoints._();

  static const String _envBaseUrl = String.fromEnvironment('API_BASE_URL');
  static const String _envPedidosBaseUrl =
      String.fromEnvironment('PEDIDOS_API_BASE_URL');

  static const String _defaultCatalogoBaseUrl =
      'https://6afe4bd93a0e70bc8d533e96.mockapi.io/api/v1';
  static const String _defaultPedidosBaseUrl =
      'https://6afe507a3a0e70bc8d53421c.mockapi.io/api/v1';

  /// URL base pública del Proyecto 1 en MockAPI (`clientes` y `productos`).
  static String get baseUrl =>
      _envBaseUrl.isNotEmpty ? _envBaseUrl : _defaultCatalogoBaseUrl;

  /// URL base pública del Proyecto 2 en MockAPI (`pedidos`).
  static String get pedidosBaseUrl => _envPedidosBaseUrl.isNotEmpty
      ? _envPedidosBaseUrl
      : _defaultPedidosBaseUrl;

  static const Duration requestTimeout = Duration(seconds: 15);

  static const String productos = '/productos';
  static String productoDetalle(dynamic id) => '/productos/$id';

  static const String clientes = '/clientes';
  static String clienteDetalle(dynamic id) => '/clientes/$id';

  static String get pedidos => '$pedidosBaseUrl/pedidos';
  static String pedidoDetalle(dynamic id) => '$pedidos/$id';
}
