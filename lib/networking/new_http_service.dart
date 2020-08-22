import 'dart:async';

import 'package:typesafehttp/networking/interceptor.dart';
import 'package:typesafehttp/networking/real_interceptor_chain.dart';
import 'package:typesafehttp/networking/request.dart';
import 'package:typesafehttp/networking/response.dart';
import 'package:typesafehttp/networking/serializable.dart';
import 'package:typesafehttp/networking/server_call_interceptor.dart';

class NewHttpService {
  static NewHttpService _instance;

  List<Interceptor> _interceptors;
  ServerCallInterceptor _serverCallInterceptor;
  RealInterceptorChain _realInterceptorChain;

  NewHttpService._internal(List<Interceptor> interceptors) {
    if (interceptors != null)
      _interceptors = interceptors;
    else
      _interceptors = List<Interceptor>();

    // Add real call interceptor
    _serverCallInterceptor = ServerCallInterceptor();
    _interceptors.add(_serverCallInterceptor);
    _realInterceptorChain = RealInterceptorChain(_interceptors);
  }

  factory NewHttpService(List<Interceptor> interceptors) {
    _instance ??= NewHttpService._internal(interceptors);
    return _instance;
  }

  void addInterceptor(Interceptor interceptor) {
    _interceptors.add(interceptor);
  }

  Future<Response<ResponseType>> enqueue<RequestType, ResponseType>(
      Request<RequestType> request, Serializable<ResponseType> serializable) {
    if (request != null)
      return _realInterceptorChain.proceed(request, serializable);
    else throw Exception("Request can not be null");
  }

//  Future<ResponseType> post<RequestType, ResponseType>(
//      Request<RequestType> request,
//      Serializable<ResponseType> responseSerializable) {
//    return http
//        .post(request.url,
//            body: request.toJsonString(), headers: request.headers)
//        .then(
//            (http.Response value) =>
//                Response<ResponseType>(value.body, responseSerializable)
//                    .getResponseBody(),
//            onError: () {});
//  }
//
//  Future<ResponseType> get<RequestType, ResponseType>(
//      Request<RequestType> request,
//      Serializable<ResponseType> responseSerializable) {
//    return http.get(request.url, headers: request.headers).then(
//        (http.Response value) =>
//            Response<ResponseType>(value.body, responseSerializable)
//                .getResponseBody(),
//        onError: () {});
//  }
//
//  Future<List<ResponseType>> getAll<RequestType, ResponseType>(
//      Request<RequestType> request,
//      Serializable<ResponseType> responseSerializable) {
//    return http.get(request.url, headers: request.headers).then(
//        (http.Response value) =>
//            Response<ResponseType>(value.body, responseSerializable)
//                .getResponseBodyAsList(),
//        onError: () {});
//  }
//
//  Future<ResponseType> put<RequestType, ResponseType>(
//      Request<RequestType> request,
//      Serializable<ResponseType> responseSerializable) {
//    return http
//        .put(request.url,
//            body: request.toJsonString(), headers: request.headers)
//        .then(
//            (http.Response value) =>
//                Response<ResponseType>(value.body, responseSerializable)
//                    .getResponseBody(),
//            onError: () {});
//  }
//
//  Future<bool> delete<RequestType>(Request<RequestType> request) {
//    return http
//        .delete(request.url, headers: request.headers)
//        .then((value) => value.statusCode == 200, onError: () {});
//  }

// Usage:
//  var newHttpService = NewHttpService();
//  Request<Post> request = Request("/posts/", _postSerializable);
//  newHttpService.post<Post, OtherPost>(request, _otherPostSerializable);
}
