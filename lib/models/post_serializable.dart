import 'package:typesafehttp/networking/serializable.dart';
import 'package:typesafehttp/models/post.dart';

class PostSerializable implements Serializable<Post> {
  @override
  Post fromJson(Map<String, dynamic> json) {
    return Post.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(Post post) {
    return post.toJson();
  }

  @override
  List<Post> fromJsonArray(List<dynamic> jsonArray) {
    return jsonArray?.map((postMap) =>
    postMap == null ? null : fromJson(postMap))
        ?.toList();
  }

  @override
  List<dynamic> toJsonArray(List<Post> postList) {
    return postList?.map((post) => post?.toJson())?.toList();
  }
}
