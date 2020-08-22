import 'package:typesafehttp/networking/interceptor.dart';
import 'package:typesafehttp/networking/request.dart';
import 'package:typesafehttp/networking/response.dart';

class LoggingInterceptor implements Interceptor {
  @override
  Future<Response<ResponseType>> intercept<RequestType, ResponseType>(
      Chain chain) async {
    Request request = chain.request();

    print("Logging for ${request.url}");
    print("Headers ${request.headers.toString()}");
    print("Request body ${request.toJsonString()}");

    return chain.proceed<RequestType, ResponseType>(
        request, chain.responseSerializable());
  }
}
