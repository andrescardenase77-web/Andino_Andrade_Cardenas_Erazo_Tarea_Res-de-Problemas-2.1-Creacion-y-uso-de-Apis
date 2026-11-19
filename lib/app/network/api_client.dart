import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'api_endpoints.dart';
import 'network_exceptions.dart';

class ApiClient {
  final http.Client _client;
  final String _baseUrl;

  ApiClient({
    http.Client? client,
    String? baseUrl,
  })  : _client = client ?? http.Client(),
        _baseUrl = baseUrl ?? ApiEndpoints.baseUrl;

  Uri _buildUri(String endpoint, [Map<String, dynamic>? queryParameters]) {
    final bool isAbsolute =
        endpoint.startsWith('http://') || endpoint.startsWith('https://');
    final String fullUrl;
    if (isAbsolute) {
      fullUrl = endpoint;
    } else {
      final String cleanBase = _baseUrl.endsWith('/')
          ? _baseUrl.substring(0, _baseUrl.length - 1)
          : _baseUrl;
      final String cleanEndpoint =
          endpoint.startsWith('/') ? endpoint : '/$endpoint';
      fullUrl = '$cleanBase$cleanEndpoint';
    }

    final uri = Uri.parse(fullUrl);
    if (queryParameters != null && queryParameters.isNotEmpty) {
      return uri.replace(
        queryParameters: {
          ...uri.queryParameters,
          ...queryParameters.map((k, v) => MapEntry(k, v.toString())),
        },
      );
    }
    return uri;
  }

  Map<String, String> _defaultHeaders([Map<String, String>? customHeaders]) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      ...?customHeaders,
    };
  }

  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    final uri = _buildUri(endpoint, queryParameters);
    return _sendRequest(() => _client.get(uri, headers: _defaultHeaders(headers)), uri, timeout);
  }

  Future<dynamic> post(
    String endpoint, {
    dynamic data,
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    final uri = _buildUri(endpoint);
    final encodedBody = data is String ? data : (data != null ? jsonEncode(data) : null);
    return _sendRequest(
      () => _client.post(uri, headers: _defaultHeaders(headers), body: encodedBody),
      uri,
      timeout,
    );
  }

  Future<dynamic> put(
    String endpoint, {
    dynamic data,
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    final uri = _buildUri(endpoint);
    final encodedBody = data is String ? data : (data != null ? jsonEncode(data) : null);
    return _sendRequest(
      () => _client.put(uri, headers: _defaultHeaders(headers), body: encodedBody),
      uri,
      timeout,
    );
  }

  Future<dynamic> patch(
    String endpoint, {
    dynamic data,
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    final uri = _buildUri(endpoint);
    final encodedBody = data is String ? data : (data != null ? jsonEncode(data) : null);
    return _sendRequest(
      () => _client.patch(uri, headers: _defaultHeaders(headers), body: encodedBody),
      uri,
      timeout,
    );
  }

  Future<dynamic> delete(
    String endpoint, {
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    final uri = _buildUri(endpoint);
    return _sendRequest(
      () => _client.delete(uri, headers: _defaultHeaders(headers)),
      uri,
      timeout,
    );
  }

  Future<dynamic> _sendRequest(
    Future<http.Response> Function() requestFn,
    Uri uri,
    Duration? timeout,
  ) async {
    try {
      final response = await requestFn().timeout(
        timeout ?? ApiEndpoints.requestTimeout,
        onTimeout: () => throw TimeoutNetworkException(uri: uri),
      );

      return _handleResponse(response, uri);
    } on SocketException {
      throw NoInternetException(uri: uri);
    } on HttpException {
      throw const NoInternetException(message: 'Error al contactar con el servicio.');
    } on FormatException {
      throw const ServerException(message: 'El formato de respuesta del servidor es inválido.');
    } on TimeoutException {
      throw TimeoutNetworkException(uri: uri);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw UnknownNetworkException(
        message: 'Error inesperado: ${e.toString()}',
        uri: uri,
      );
    }
  }

  dynamic _handleResponse(http.Response response, Uri uri) {
    final statusCode = response.statusCode;
    final bodyString =
        utf8.decode(response.bodyBytes, allowMalformed: true).trim();

    dynamic decodedData;
    if (bodyString.isNotEmpty) {
      try {
        decodedData = jsonDecode(bodyString);
      } catch (_) {
        decodedData = bodyString;
      }
    }

    if (statusCode >= 200 && statusCode < 300) {
      return decodedData;
    }

    switch (statusCode) {
      case 400:
        throw BadRequestException(
          message: _extractErrorMessage(decodedData) ?? 'Solicitud incorrecta.',
          statusCode: statusCode,
          uri: uri,
        );
      case 401:
      case 403:
        throw UnauthorizedException(
          message: _extractErrorMessage(decodedData) ?? 'Acceso denegado o no autorizado.',
          statusCode: statusCode,
          uri: uri,
        );
      case 404:
        throw NotFoundException(
          message: _extractErrorMessage(decodedData) ?? 'El recurso no fue encontrado.',
          statusCode: statusCode,
          uri: uri,
        );
      default:
        if (statusCode >= 500) {
          throw ServerException(
            message: _extractErrorMessage(decodedData) ?? 'Error interno del servidor ($statusCode).',
            statusCode: statusCode,
            uri: uri,
          );
        }
        throw UnknownNetworkException(
          message: _extractErrorMessage(decodedData) ?? 'Error con código HTTP $statusCode.',
          statusCode: statusCode,
          uri: uri,
        );
    }
  }

  String? _extractErrorMessage(dynamic data) {
    if (data is Map) {
      if (data['message'] != null) return data['message'].toString();
      if (data['error'] != null) return data['error'].toString();
      if (data['msg'] != null) return data['msg'].toString();
    }
    return null;
  }

  void close() {
    _client.close();
  }
}
