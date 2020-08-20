import 'package:typesafehttp/networking/request.dart';
import 'package:typesafehttp/networking/response.dart';

abstract class Interceptor {
  Response intercept(Chain chain);
}

abstract class Chain {
  Request request();

  Response proceed(Request request);
}
