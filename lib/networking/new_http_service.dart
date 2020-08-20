import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:typesafehttp/networking/request.dart';
import 'package:typesafehttp/networking/response.dart';
import 'package:typesafehttp/networking/serializable.dart';

class NewHttpService {
  static NewHttpService _instance;

  NewHttpService._internal();

  factory NewHttpService() {
    _instance ??= NewHttpService._internal();
    return _instance;
  }

  Future<ResponseType> post<RequestType, ResponseType>(
      Request<RequestType> request,
      Serializable<ResponseType> responseSerializable) {
    return http
        .post(request.url,
            body: request.toJsonString(), headers: _getDefaultHeaders())
        .then(
            (http.Response value) =>
                Response<ResponseType>(value.body, responseSerializable)
                    .getResponseBody(),
            onError: () {});
  }

  Future<ResponseType> get<ResponseType>(
      String url, Serializable<ResponseType> responseSerializable) {
    return http.get(url, headers: _getDefaultHeaders()).then(
        (http.Response value) =>
            Response<ResponseType>(value.body, responseSerializable)
                .getResponseBody(),
        onError: () {});
  }

  Future<List<ResponseType>> getAll<ResponseType>(
      String url, Serializable<ResponseType> responseSerializable) {
    return http.get(url, headers: _getDefaultHeaders()).then(
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
            body: request.toJsonString(), headers: _getDefaultHeaders())
        .then(
            (http.Response value) =>
                Response<ResponseType>(value.body, responseSerializable)
                    .getResponseBody(),
            onError: () {});
  }

  Future<bool> delete(String url) {
    return http.delete(url).then((value) {
      return value.statusCode == 200;
    }, onError: () {});
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
  Map<String, String> _getDefaultHeaders() {
    return {"content-type": "application/json"};
  }
}
