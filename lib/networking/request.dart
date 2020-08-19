import 'dart:convert';

import 'package:typesafehttp/networking/serializable.dart';

class Request<T, S extends Serializable<T>> {
  final String url;
  final S _serializable;

  T _body;

  Request(this. url, this._serializable);

  void setBody(T body) {
    _body = body;
  }

  Map<String, dynamic> toJsonMap() => _serializable.toJson(_body);

  String toJsonString() => jsonEncode(toJsonMap());
}