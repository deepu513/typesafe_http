import 'package:typesafehttp/networking/interceptor.dart';
import 'package:typesafehttp/networking/request.dart';
import 'package:typesafehttp/networking/response.dart';

class RequestHeaderInterceptor implements Interceptor {
  // TODO: Add dependency of shared prefs here to obtain token
  @override
  Future<Response<ResponseType>> intercept<RequestType, ResponseType>(
      Chain chain) {
    Request request = chain.request();

    if (request.headers == null) {
      Request newRequest = request.copyWith(headers: _getDefaultHeaders());
      return chain.proceed(newRequest, chain.responseSerializable());
    }

    return chain.proceed(request, chain.responseSerializable());
  }

  Map<String, String> _getDefaultHeaders({String token}) {
    var map = {"content-type": "application/json"};

    if (token != null && token.isNotEmpty) {
      map.putIfAbsent("Authorization", () => "Bearer $token");
    }

    return map;
  }
}
