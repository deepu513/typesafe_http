import 'package:typesafehttp/networking/interceptor.dart';
import 'package:typesafehttp/networking/request.dart';
import 'package:typesafehttp/networking/response.dart';

class LoggingInterceptor implements Interceptor {
  @override
  Future<Response<ResponseType>> intercept<RequestType, ResponseType>(
      Chain chain) async {
    Request request = chain.request();

    //TODO: Check if the build is debug build, then only add this interceptor
    print("Logging for ${request.url}");
    print("Headers ${request.headers.toString()}");
    // TODO: Check for nulls here
    //print("Request body ${request.toJsonString()}");

    return chain.proceed<RequestType, ResponseType>(
        request, chain.responseSerializable());
  }
}
