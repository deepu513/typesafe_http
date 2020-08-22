import 'package:typesafehttp/models/token.dart';
import 'package:typesafehttp/networking/serializable.dart';

class TokenSerializable implements Serializable<Token> {
  @override
  Token fromJson(Map<String, dynamic> json) {
    return Token.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(Token token) {
    return token.toJson();
  }

  @override
  List<Token> fromJsonArray(List<dynamic> jsonArray) {
    return jsonArray?.map((tokenMap) =>
    tokenMap == null ? null : fromJson(tokenMap))
        ?.toList();
  }

  @override
  List<dynamic> toJsonArray(List<Token> tokenList) {
    return tokenList?.map((token) => token?.toJson())?.toList();
  }
}