import 'package:typesafehttp/models/other/other_post.dart';
import 'package:typesafehttp/networking/serializable.dart';

class OtherPostSerializable implements Serializable<OtherPost> {
  @override
  OtherPost fromJson(Map<String, dynamic> json) {
    return OtherPost.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(OtherPost otherPost) {
    return otherPost.toJson();
  }

  @override
  List<OtherPost> fromJsonArray(List<dynamic> jsonArray) {
    return jsonArray?.map((otherPostMap) =>
    otherPostMap == null ? null : fromJson(otherPostMap))
        ?.toList();
  }

  @override
  List<dynamic> toJsonArray(List<OtherPost> otherPostList) {
    return otherPostList?.map((otherPost) => otherPost?.toJson())?.toList();
  }
}