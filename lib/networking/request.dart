import 'dart:convert';

import 'package:typesafehttp/networking/serializable.dart';

class Request<T> {
  final String url;
  final Serializable<T> _serializable;
  final Map<String, String> headers;

  T _body;

  Request(this._serializable, {this. url, this.headers});

  void setBody(T body) {
    _body = body;
  }

  Map<String, dynamic> toJsonMap() => _serializable.toJson(_body);

  String toJsonString() => jsonEncode(toJsonMap());
}