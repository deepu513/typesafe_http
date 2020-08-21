import 'package:typesafehttp/networking/interceptor.dart';
import 'package:typesafehttp/networking/request.dart';
import 'package:typesafehttp/networking/response.dart';
import 'package:typesafehttp/networking/serializable.dart';

// You iterate through all interceptors here
class RealInterceptorChain implements Chain {
  List<Interceptor> _interceptors;
  Request _updatedRequest;
  Serializable _serializable;
  int i = -1;

  RealInterceptorChain(List<Interceptor> interceptors) {
    this._interceptors = List.unmodifiable(interceptors);
  }

  @override
  Future<Response<ResponseType>> proceed<RequestType, ResponseType>(
      Request<RequestType> request,
      Serializable<ResponseType> serializable) async {
    this._updatedRequest = request;
    this._serializable = serializable;

    Response<ResponseType> response;

    // TODO: i should be reset for every new call or completion of a call, figure out a way
    if (i < _interceptors.length)
      response = await _interceptors[++i].intercept(this);

    return response;
  }

  @override
  Request<RequestType> request<RequestType>() {
    return _updatedRequest;
  }

  @override
  Serializable<ResponseType> responseSerializable<ResponseType>() {
    return _serializable;
  }
}
