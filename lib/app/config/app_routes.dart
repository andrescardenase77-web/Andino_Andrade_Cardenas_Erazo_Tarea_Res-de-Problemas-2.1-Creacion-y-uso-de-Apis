import 'package:flutter/material.dart';

import '../../features/clientes/presentation/pages/cliente_list_page.dart';
import '../../features/productos/presentation/pages/producto_catalog_page.dart';
import '../../features/pedidos/presentation/pages/order_list_page.dart';
import '../../features/pedidos/presentation/pages/order_creation_page.dart';

class AppRoutes {
  AppRoutes._();

  static const String inicio = '/';
  static const String clientes = '/clientes';
  static const String productos = '/productos';
  static const String pedidos = '/pedidos';
  static const String crearPedido = '/pedidos/crear';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      inicio: (_) => const ProductoCatalogPage(),
      productos: (_) => const ProductoCatalogPage(),
      clientes: (_) => const ClienteListPage(),
      pedidos: (_) => const OrderListPage(),
      crearPedido: (_) => const OrderCreationPage(),
    };
  }
}
