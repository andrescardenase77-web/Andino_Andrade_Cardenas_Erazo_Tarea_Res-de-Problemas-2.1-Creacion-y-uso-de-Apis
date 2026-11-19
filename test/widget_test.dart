import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:pedidos_app/app/network/api_client.dart';
import 'package:pedidos_app/features/clientes/data/models/cliente_model.dart';
import 'package:pedidos_app/features/pedidos/domain/usecases/calculate_discount.dart';
import 'package:pedidos_app/features/productos/domain/entities/producto.dart';
import 'package:pedidos_app/main.dart';

void main() {
  testWidgets('Renderiza catálogo inicial de productos y accesos a módulos', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.text('Productos de Cafetería'), findsOneWidget);
    expect(find.byIcon(Icons.people_outline), findsOneWidget);
    expect(find.byIcon(Icons.receipt_long_outlined), findsOneWidget);
  });

  test('CalculateDiscount aplica 10% únicamente cuando el subtotal > USD 50', () {
    final calc = CalculateDiscount();

    final sinDescuento = calc(precioUnitario: 5.0, cantidad: 10);
    expect(sinDescuento.subtotal, 50.0);
    expect(sinDescuento.descuento, 0.0);
    expect(sinDescuento.total, 50.0);

    final conDescuento = calc(precioUnitario: 5.5, cantidad: 10);
    expect(conDescuento.subtotal, 55.0);
    expect(conDescuento.descuento, 5.5);
    expect(conDescuento.total, 49.5);
  });

  test('Producto valida disponibilidad y límites de cantidad solicitada', () {
    const agotado = Producto(id: 6, nombre: 'Muffin', precio: 2.5, stock: 0);
    expect(agotado.tieneStock, isFalse);
    expect(agotado.puedeSolicitar(1), isFalse);

    const disponible = Producto(id: 1, nombre: 'Espresso', precio: 2.25, stock: 5);
    expect(disponible.tieneStock, isTrue);
    expect(disponible.puedeSolicitar(0), isFalse);
    expect(disponible.puedeSolicitar(5), isTrue);
    expect(disponible.puedeSolicitar(6), isFalse);
  });

  test('ApiClient soporta rutas relativas y URLs absolutas (multi-MockAPI)', () async {
    final requestedUrls = <String>[];
    final mockHttp = MockClient((request) async {
      requestedUrls.add(request.url.toString());
      return http.Response('[]', 200);
    });
    final client = ApiClient(
      client: mockHttp,
      baseUrl: 'https://proyecto1.mockapi.io/api/v1/',
    );

    await client.get('/productos');
    await client.get('https://proyecto2.mockapi.io/api/v1/pedidos');

    expect(requestedUrls[0], 'https://proyecto1.mockapi.io/api/v1/productos');
    expect(requestedUrls[1], 'https://proyecto2.mockapi.io/api/v1/pedidos');
    client.close();
  });

  test('ClienteModel.fromJson soporta id como String de MockAPI.io', () {
    final cliente = ClienteModel.fromJson({
      'id': '12',
      'nombre': 'Uriel Andrade',
      'telefono': '0987654321',
      'email': 'uaandrade@espe.edu.ec',
    });

    expect(cliente.id, 12);
    expect(cliente.nombre, 'Uriel Andrade');
    expect(cliente.telefono, '0987654321');
    expect(cliente.email, 'uaandrade@espe.edu.ec');
  });

  test('ApiClient decodifica UTF-8 sin charset explícito en Content-Type', () async {
    final payloadBytes = utf8.encode('[{"nombre":"Café Espresso","cliente":"Andrés Cárdenas"}]');
    final mockHttp = MockClient((_) async {
      return http.Response.bytes(
        payloadBytes,
        200,
        headers: {'content-type': 'application/json'},
      );
    });
    final client = ApiClient(client: mockHttp, baseUrl: 'https://example.com/api/v1');

    final data = await client.get('/productos') as List;
    expect((data.first as Map)['nombre'], 'Café Espresso');
    expect((data.first as Map)['cliente'], 'Andrés Cárdenas');
    client.close();
  });
}
