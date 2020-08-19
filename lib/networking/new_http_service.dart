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

  Future<Response<N, Serializable<N>>> post<R, N>(
      Request<R, Serializable<R>> request,
      Serializable<N> responseSerializable) {
    return http
        .post(request.url,
            body: request.toJsonString(), headers: _getDefaultHeaders())
        .then(
            (http.Response value) => Response(value.body, responseSerializable),
            onError: () {});
  }

  // Usage:
  //Request<Post, PostSerializable> request = Request("/posts/", _postSerializable);
//    newHttpService.post<Post, Post>(request, _postSerializable);

//  final S _serializable;
//
//  HttpService(this._serializable);
//
//  final _baseUrl = "https://jsonplaceholder.typicode.com";
//
//  Future<T> get(String path) async {
//    var responseObject;
//    try {
//      final response = await http.get(_baseUrl + path);
//      responseObject = _processResponse(response);
//    } catch (e) {
//      _throwSpecificException(e);
//    }
//    return responseObject;
//  }
//
//  Future<List<T>> getAll(String path) async {
//    var responseObject;
//    try {
//      final response = await http.get(_baseUrl + path);
//      responseObject = _processResponseArray(response);
//    } catch (e) {
//      _throwSpecificException(e);
//    }
//    return responseObject;
//  }
//
//  Future<T> post(String path, T t) async {
//    var responseObject;
//    try {
//      final response = await http.post(_baseUrl + path,
//          body: jsonEncode(_serializable.toJson(t)),
//          headers: _getDefaultHeaders());
//      responseObject = _processResponse(response);
//    } catch (e) {
//      _throwSpecificException(e);
//    }
//    return responseObject;
//  }
//
//  Future<T> put(String path, T t) async {
//    var responseObject;
//    try {
//      final response = await http.put(_baseUrl + path,
//          body: jsonEncode(_serializable.toJson(t)),
//          headers: _getDefaultHeaders());
//      responseObject = _processResponse(response);
//    } catch (e) {
//      _throwSpecificException(e);
//    }
//    return responseObject;
//  }
//
//  Future<bool> delete(String path) async {
//    var result;
//    try {
//      final response = await http.delete(_baseUrl + path);
//      result = response.statusCode == 200;
//    } catch (e) {
//      _throwSpecificException(e);
//    }
//    return result;
//  }
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
