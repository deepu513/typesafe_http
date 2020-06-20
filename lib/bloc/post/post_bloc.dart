import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:typesafehttp/bloc/post/post_event.dart';
import 'package:typesafehttp/bloc/post/post_state.dart';
import 'package:typesafehttp/models/post.dart';
import 'package:typesafehttp/repository/post_repository.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostRepository _postRepository;

  PostBloc() {
    _postRepository = PostRepository();
  }

  @override
  PostState get initialState => Initial();

  @override
  Stream<PostState> mapEventToState(PostEvent event) async* {
    if (event is PostRequested) {
      yield Loading();

      try {
        Post post = await _postRepository.get("1");
        yield Loaded(post: post);
      } catch (error) {
        yield Failure(error: error.toString());
      }
    }

    if (event is AllPostsRequested) {
      yield Loading();

      try {
        List<Post> allPosts = await _postRepository.getAll();
        yield AllPostsLoaded(posts: allPosts);
      } catch (error) {
        yield Failure(error: error.toString());
      }
    }

    if (event is SendPost) {
      yield Loading();

      try {
        Post postToSend = new Post()
          ..id = 101
          ..title = "Sample post"
          ..userId = 10
          ..body = "Sample body";

        await _postRepository.send(postToSend);
        yield PostSent();
      } catch (error) {
        yield Failure(error: error.toString());
      }
    }
  }
}
