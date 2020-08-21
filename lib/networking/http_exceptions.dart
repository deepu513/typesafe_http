class HttpException implements Exception {
  final _message;

  HttpException(this._message);

  String toString() {
    return "$_message";
  }
}

class FetchDataException extends HttpException {
  FetchDataException() : super("No internet connection");
}

class BadRequestException extends HttpException {
  BadRequestException() : super("Invalid request");
}

class UnauthorisedException extends HttpException {
  UnauthorisedException() : super("Unauthorised");
}

class ResourceNotFoundException extends HttpException {
  ResourceNotFoundException() : super("Not found");
}

class ResourceConflictException extends HttpException {
  ResourceConflictException() : super("Conflict in resource");
}

class UnknownResponseCodeException extends HttpException {
  UnknownResponseCodeException() : super("Unknown response code");
}
