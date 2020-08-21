import 'package:typesafehttp/networking/request.dart';
import 'package:typesafehttp/networking/response.dart';
import 'package:typesafehttp/networking/serializable.dart';

abstract class Interceptor {
  Future<Response<ResponseType>> intercept<RequestType, ResponseType>(Chain chain);
}

abstract class Chain {
  Request<RequestType> request<RequestType>();

  Future<Response<ResponseType>> proceed<RequestType, ResponseType>(
      Request<RequestType> request, Serializable<ResponseType> serializable);

  Serializable<ResponseType> responseSerializable<ResponseType>();
}
