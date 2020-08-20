import 'package:typesafehttp/networking/interceptor.dart';
import 'package:typesafehttp/networking/request.dart';
import 'package:typesafehttp/networking/response.dart';

class LoggingInterceptor implements Interceptor {
  @override
  Response intercept(Chain chain) {
    Request request = chain.request();

    //TODO: Check if the build is debug build, then print
    print("Logging for ${request.url}");
    print("Headers ${request.headers.toString()}");
    print("Request body ${request.toJsonString()}");

    return chain.proceed(request);
  }
}