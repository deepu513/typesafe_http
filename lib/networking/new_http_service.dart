import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:typesafehttp/networking/interceptor.dart';
import 'package:typesafehttp/networking/request.dart';
import 'package:typesafehttp/networking/response.dart';
import 'package:typesafehttp/networking/serializable.dart';

class NewHttpService {
  static NewHttpService _instance;

  List<Interceptor> _interceptors;

  NewHttpService._internal() {
    _interceptors = List<Interceptor>();
  }

  factory NewHttpService() {
    _instance ??= NewHttpService._internal();
    return _instance;
  }

  void addInterceptor(Interceptor interceptor) {
    _interceptors.add(interceptor);
  }

  execute(Request request) {

  }

  Future<ResponseType> post<RequestType, ResponseType>(
      Request<RequestType> request,
      Serializable<ResponseType> responseSerializable) {
    return http
        .post(request.url,
            body: request.toJsonString(), headers: request.headers)
        .then(
            (http.Response value) =>
                Response<ResponseType>(value.body, responseSerializable)
                    .getResponseBody(),
            onError: () {});
  }

  Future<ResponseType> get<RequestType, ResponseType>(
      Request<RequestType> request,
      Serializable<ResponseType> responseSerializable) {
    return http.get(request.url, headers: request.headers).then(
        (http.Response value) =>
            Response<ResponseType>(value.body, responseSerializable)
                .getResponseBody(),
        onError: () {});
  }

  Future<List<ResponseType>> getAll<RequestType, ResponseType>(
      Request<RequestType> request,
      Serializable<ResponseType> responseSerializable) {
    return http.get(request.url, headers: request.headers).then(
        (http.Response value) =>
            Response<ResponseType>(value.body, responseSerializable)
                .getResponseBodyAsList(),
        onError: () {});
  }

  Future<ResponseType> put<RequestType, ResponseType>(
      Request<RequestType> request,
      Serializable<ResponseType> responseSerializable) {
    return http
        .put(request.url,
            body: request.toJsonString(), headers: request.headers)
        .then(
            (http.Response value) =>
                Response<ResponseType>(value.body, responseSerializable)
                    .getResponseBody(),
            onError: () {});
  }

  Future<bool> delete<RequestType>(Request<RequestType> request) {
    return http
        .delete(request.url, headers: request.headers)
        .then((value) => value.statusCode == 200, onError: () {});
  }

// Usage:
//  var newHttpService = NewHttpService();
//  Request<Post> request = Request("/posts/", _postSerializable);
//  newHttpService.post<Post, OtherPost>(request, _otherPostSerializable);

//
//  List<T> _processResponseArray(http.Response response) {
//    var responseList;
//    if (_isSuccessOrThrow(response)) {
//      responseList =
//          _serializable.fromJsonArray(jsonDecode(response.body.toString()));
//    }
//    return responseList;
//  }
//
//  T _processResponse(http.Response response) {
//    var responseObject;
//    if (_isSuccessOrThrow(response)) {
//      responseObject =
//          _serializable.fromJson(jsonDecode(response.body.toString()));
//    }
//    return responseObject;
//  }
//
//  bool _isSuccessOrThrow(http.Response response) {
//    switch (response.statusCode) {
//      case 200:
//      case 201:
//        return true;
//      case 400:
//        throw BadRequestException(response.body.toString());
//      case 401:
//      case 403:
//        throw UnauthorisedException(response.body.toString());
//      case 404:
//        throw ResourceNotFoundException(response.body.toString());
//      case 500:
//      default:
//        throw FetchDataException(
//            'Error occurred while communicating with server : ${response.statusCode}');
//    }
//  }
//
//  _throwSpecificException(Exception e) {
//    if (e is FormatException) {
//      throw BadUrlException(e.message);
//    } else if (e is SocketException) {
//      throw FetchDataException('No Internet connection');
//    } else
//      throw e;
//  }
//

//  Map<String, String> _getDefaultHeaders({String token}) {
//    var map = {"content-type": "application/json"};
//
//    if (token != null && token.isNotEmpty) {
//      map.putIfAbsent("Authorization", () => "Bearer $token");
//    }
//
//    return map;
//  }
}
