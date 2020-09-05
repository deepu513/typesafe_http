import 'dart:convert';

import 'package:typesafehttp/networking/serializable.dart';

class Response<T> {
  final Serializable<T> _serializable;

  T _body;
  List<T> _responseBodyList;

  final int statusCode;

  Map<String, dynamic> _responseMap;
  List<dynamic> _responseList;

  Response(String responseString, this._serializable, {this.statusCode}) {
    // If json is huge, decoding this can jank UI
    // prefer using compute to do this on another isolate
    // https://flutter.dev/docs/cookbook/networking/background-parsing#4-move-this-work-to-a-separate-isolate
    if (responseString != null && responseString.isNotEmpty)
      _responseMap = jsonDecode(responseString);
  }

  Response.fromJsonArray(String responseString, this._serializable,
      {this.statusCode}) {
    // If json is huge, decoding this can jank UI
    // prefer using compute to do this on another isolate
    // https://flutter.dev/docs/cookbook/networking/background-parsing#4-move-this-work-to-a-separate-isolate
    if (responseString != null && responseString.isNotEmpty)
      _responseList = jsonDecode(responseString);
  }

  T getResponseBody() {
    _body ??=
    _responseMap == null ? null : _serializable.fromJson(_responseMap);
    return _body;
  }

  List<T> getResponseBodyAsList() {
    try {
      _responseBodyList ??= _responseList == null
          ? null
          : _serializable.fromJsonArray(_responseList);
      return _responseBodyList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
