import 'package:typesafehttp/networking/request.dart';
import 'package:typesafehttp/networking/response.dart';

abstract class Authenticator {
  Request authenticate(Response response);
}