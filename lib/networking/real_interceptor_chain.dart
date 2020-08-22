import 'package:typesafehttp/networking/interceptor.dart';
import 'package:typesafehttp/networking/request.dart';
import 'package:typesafehttp/networking/response.dart';
import 'package:typesafehttp/networking/serializable.dart';

// Iterate through all interceptors here
class RealInterceptorChain implements Chain {
  List<Interceptor> _interceptors;
  Request _updatedRequest;
  Serializable _serializable;
  int _index = -1;

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

    if (_index < _interceptors.length)
      response = await _interceptors[++_index].intercept(this);

    // reset index
    _index = -1;
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
