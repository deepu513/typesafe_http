import 'dart:async';

import 'package:typesafehttp/models/token.dart';
import 'package:typesafehttp/models/token_serializable.dart';
import 'package:typesafehttp/networking/http_exceptions.dart';
import 'package:typesafehttp/networking/interceptor.dart';
import 'package:typesafehttp/networking/method.dart';
import 'package:typesafehttp/networking/real_interceptor_chain.dart';
import 'package:typesafehttp/networking/request.dart';
import 'package:typesafehttp/networking/response.dart';
import 'package:typesafehttp/networking/serializable.dart';
import 'package:typesafehttp/networking/server_call_interceptor.dart';
import 'package:typesafehttp/repository/settings_repository.dart';
import 'package:typesafehttp/setting_key.dart';

class NewHttpService {
  static NewHttpService _instance;

  List<Interceptor> _interceptors;
  RealInterceptorChain _realInterceptorChain;

  // TODO: Initialize this
  SettingsRepository _settingsRepository;

  int _refreshTokenCounter = 0;

  NewHttpService._internal(List<Interceptor> interceptors) {
    _interceptors = interceptors != null ? interceptors : List<Interceptor>();

    // Add real call interceptor
    _interceptors.add(ServerCallInterceptor());

    _realInterceptorChain = RealInterceptorChain(_interceptors);
  }

  static NewHttpService get instance => _instance;

  factory NewHttpService(List<Interceptor> interceptors) {
    _instance ??= NewHttpService._internal(interceptors);
    return _instance;
  }

  Future<Response<ResponseType>> enqueue<RequestType, ResponseType>(
      Request<RequestType> request,
      Serializable<ResponseType> serializable) async {
    try {
      if (request != null)
        return _realInterceptorChain.proceed(request, serializable);
      else
        throw Exception("Request can not be null");
    } on UnauthorisedException {
      // Chain is broken here
      try {
        // If you again get 401 in refreshing token call,
        // this will go in endless loop
        // It is mostly backend error but should at least be handled on frontend
        // and logout user.
        // Make a counter, initialize it to 0, increment it during refresh token,
        // if counter > 0, logout user.
        if(_refreshTokenCounter == 0) {
          _refreshTokenCounter++;

          final String refreshToken =
          _settingsRepository.get(SettingKey.KEY_REFRESH_TOKEN);

          // Get a refresh token request
          TokenSerializable tokenSerializable = TokenSerializable();
          Request<Token> refreshTokenRequest = Request(
              Method.GET, "refreshTokenUrl", tokenSerializable,
              headers: _getDefaultHeaders(token: refreshToken));

          // await for the request to complete
          Response<Token> tokenResponse =
          await enqueue<Token, Token>(refreshTokenRequest, tokenSerializable);

          // update shared preferences with new token
          var updatedToken = tokenResponse
              .getResponseBody()
              .token;
          _settingsRepository.saveValue(
              SettingKey.KEY_REQUEST_TOKEN, updatedToken);

          // copy existing request and give new token to updated request
          Request<RequestType> updatedRequest =
          request.copyWith(headers: _getDefaultHeaders(token: updatedToken));

          // call and enqueue again with updated request
          return enqueue(updatedRequest, serializable);
        } else {
          // Logout user
          throw Exception("Session expired");
        }
      } catch (e) {
        // If you get any error in refresh token, logout user from the app
        throw Exception("Session expired");
      } finally {
        _refreshTokenCounter = 0;
      }
    } catch (e) {
      throw e;
    } finally  {
      _refreshTokenCounter = 0;
    }
  }

  Map<String, String> _getDefaultHeaders({String token}) {
    var map = {"content-type": "application/json"};

    if (token != null && token.isNotEmpty) {
      map.putIfAbsent("Authorization", () => "Bearer $token");
    }

    return map;
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
