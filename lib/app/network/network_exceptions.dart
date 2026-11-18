abstract class NetworkException implements Exception {
  final String message;
  final int? statusCode;
  final Uri? uri;

  const NetworkException({
    required this.message,
    this.statusCode,
    this.uri,
  });

  @override
  String toString() => message;
}

class NoInternetException extends NetworkException {
  const NoInternetException({
    super.message = 'No se pudo establecer conexión con el servidor. Verifica tu conexión a internet.',
    super.uri,
  });
}

class TimeoutNetworkException extends NetworkException {
  const TimeoutNetworkException({
    super.message = 'El tiempo de espera con el servidor ha expirado.',
    super.uri,
  });
}

class BadRequestException extends NetworkException {
  const BadRequestException({
    super.message = 'La solicitud enviada no es válida.',
    super.statusCode = 400,
    super.uri,
  });
}

class UnauthorizedException extends NetworkException {
  const UnauthorizedException({
    super.message = 'No tienes autorización para realizar esta operación.',
    super.statusCode = 401,
    super.uri,
  });
}

class NotFoundException extends NetworkException {
  const NotFoundException({
    super.message = 'El recurso solicitado no fue encontrado.',
    super.statusCode = 404,
    super.uri,
  });
}

class ServerException extends NetworkException {
  const ServerException({
    super.message = 'Ocurrió un error interno en el servidor.',
    super.statusCode = 500,
    super.uri,
  });
}

class UnknownNetworkException extends NetworkException {
  const UnknownNetworkException({
    super.message = 'Ocurrió un error inesperado al comunicarse con el servidor.',
    super.statusCode,
    super.uri,
  });
}
