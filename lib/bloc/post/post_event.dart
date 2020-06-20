import 'package:equatable/equatable.dart';

abstract class PostEvent extends Equatable {

  const PostEvent();

  @override
  List<Object> get props => [];
}

class PostRequested extends PostEvent {}

class AllPostsRequested extends PostEvent {}

class SendPost extends PostEvent {}