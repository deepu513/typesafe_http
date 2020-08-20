import 'dart:convert';

import 'package:typesafehttp/networking/serializable.dart';

class Response<T> {
  final Serializable<T> _serializable;

  T _body;

  Map<String, dynamic> responseMap;

  Response(String responseString, this._serializable) {
    // If json is huge, decoding this can jank UI
    // prefer using compute to do this on another isolate
    // https://flutter.dev/docs/cookbook/networking/background-parsing#4-move-this-work-to-a-separate-isolate
    responseMap = jsonDecode(responseString);
  }

  T getResponseBody() {
    _body ??= responseMap == null ? null : _serializable.fromJson(responseMap);
    return _body;
  }

  List<T> getResponseBodyAsList() {
    try {
      return (responseMap as List<dynamic>)
          ?.map((object) =>
              object == null ? null : _serializable.fromJson(object))
          ?.toList();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
