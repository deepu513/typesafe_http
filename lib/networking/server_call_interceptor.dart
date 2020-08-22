import 'package:http/http.dart' as http;
import 'package:typesafehttp/networking/http_exceptions.dart';
import 'package:typesafehttp/networking/interceptor.dart';
import 'package:typesafehttp/networking/method.dart';
import 'package:typesafehttp/networking/request.dart';
import 'package:typesafehttp/networking/response.dart';
import 'package:typesafehttp/networking/serializable.dart';

// You do actual the server calls here
class ServerCallInterceptor implements Interceptor {
  @override
  Future<Response<ResponseType>> intercept<RequestType, ResponseType>(
      Chain chain) {
    if (chain.request() == null) return null;

    Request<RequestType> request = chain.request();
    if (request.method == Method.GET) {
      return get<RequestType, ResponseType>(
          request, chain.responseSerializable());
    } else if (request.method == Method.GET_LIST)
      return getAll<RequestType, ResponseType>(
          request, chain.responseSerializable());
    else if (request.method == Method.POST)
      return post<RequestType, ResponseType>(
          request, chain.responseSerializable());
    else if (request.method == Method.PUT)
      return put<RequestType, ResponseType>(
          request, chain.responseSerializable());
    else if (request.method == Method.DELETE)
      return delete<RequestType, ResponseType>(request);

    return null;
  }

  Future<Response<ResponseType>> get<RequestType, ResponseType>(
      Request<RequestType> request,
      Serializable<ResponseType> responseSerializable) {
    return http.get(request.url, headers: request.headers).then(
        (actualResponse) =>
            _processResponse(actualResponse, responseSerializable),
        onError: (e) => throw FetchDataException());
  }

  Future<Response<ResponseType>> getAll<RequestType, ResponseType>(
      Request<RequestType> request,
      Serializable<ResponseType> responseSerializable) {
    return http.get(request.url, headers: request.headers).then(
        (actualResponse) =>
            _processResponse(actualResponse, responseSerializable),
        onError: (e) => throw FetchDataException());
  }

  Future<Response<ResponseType>> post<RequestType, ResponseType>(
      Request<RequestType> request,
      Serializable<ResponseType> responseSerializable) {
    return http
        .post(request.url,
            body: request.toJsonString(), headers: request.headers)
        .then(
            (actualResponse) =>
                _processResponse(actualResponse, responseSerializable),
            onError: (e) => throw FetchDataException());
  }

  Future<Response<ResponseType>> put<RequestType, ResponseType>(
      Request<RequestType> request,
      Serializable<ResponseType> responseSerializable) {
    return http
        .put(request.url,
            body: request.toJsonString(), headers: request.headers)
        .then(
            (actualResponse) =>
                _processResponse(actualResponse, responseSerializable),
            onError: (e) => throw FetchDataException());
  }

  Future<Response<ResponseType>> delete<RequestType, ResponseType>(
      Request<RequestType> request) {
    return http.delete(request.url, headers: request.headers).then(
        (actualResponse) => _processResponse(actualResponse, null),
        onError: (e) => throw FetchDataException());
  }

  Response<ResponseType> _processResponse<ResponseType>(
      http.Response actualResponse,
      Serializable<ResponseType> responseSerializable) {
    if (_isSuccessOrThrow(actualResponse.statusCode))
      return Response<ResponseType>(actualResponse.body, responseSerializable,
          statusCode: actualResponse.statusCode);
    else
      throw UnknownResponseCodeException();
  }

  bool _isSuccessOrThrow(int statusCode) {
    switch (statusCode) {
      case 200:
      case 201:
        return true;
      case 400:
        throw BadRequestException();
      case 401:
        throw UnauthorisedException();
      case 404:
        throw ResourceNotFoundException();
      case 409:
        throw ResourceConflictException();
      case 500:
      default:
        throw FetchDataException();
    }
  }
}
