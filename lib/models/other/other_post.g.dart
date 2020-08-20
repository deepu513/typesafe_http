// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'other_post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OtherPost _$OtherPostFromJson(Map<String, dynamic> json) {
  return OtherPost()
    ..title = json['title'] as String
    ..body = json['body'] as String;
}

Map<String, dynamic> _$OtherPostToJson(OtherPost instance) => <String, dynamic>{
      'title': instance.title,
      'body': instance.body,
    };
