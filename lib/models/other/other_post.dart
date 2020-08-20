import 'package:json_annotation/json_annotation.dart';

part 'other_post.g.dart';

@JsonSerializable()
class OtherPost {
  String title;
  String body;

  OtherPost();

  factory OtherPost.fromJson(Map<String, dynamic> json) => _$OtherPostFromJson(json);

  Map<String, dynamic> toJson() => _$OtherPostToJson(this);
}