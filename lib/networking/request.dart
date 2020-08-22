import 'dart:convert';

import 'package:typesafehttp/networking/method.dart';
import 'package:typesafehttp/networking/serializable.dart';

class Request<T> {
  final String url;
  final Serializable<T> _serializable;
  final Map<String, String> headers;
  final Method method;

  T _body;

  Request(this.method, this.url, this._serializable, {this.headers});

  void setBody(T body) {
    _body = body;
  }

  Map<String, dynamic> toJsonMap() {
    if (_body != null) return _serializable.toJson(_body);
    else return {};
  }

  String toJsonString() => jsonEncode(toJsonMap());

  Request<T> copyWith(
      {Method method,
      String url,
      Serializable<T> serializable,
      Map<String, String> headers}) {
    return Request<T>(method ?? this.method, url ?? this.url,
        serializable ?? this._serializable,
        headers: headers ?? this.headers);
  }
}
