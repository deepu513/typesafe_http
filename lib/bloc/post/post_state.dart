import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:typesafehttp/models/post.dart';

abstract class PostState extends Equatable {

  const PostState();

  @override
  List<Object> get props => [];
}

class Initial extends PostState {}

class Loading extends PostState {}

class Loaded extends PostState {
  final Post post;
  
  const Loaded({@required this.post});

  @override
  List<Object> get props => [post];

  @override
  bool get stringify => true;
}

class AllPostsLoaded extends PostState {
  final List<Post> posts;

  const AllPostsLoaded({@required this.posts});

  @override
  List<Object> get props => [posts];

  @override
  bool get stringify => true;
}

class PostSent extends PostState {}

class Failure extends PostState {
  final String error;

  const Failure({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  bool get stringify => true;
}