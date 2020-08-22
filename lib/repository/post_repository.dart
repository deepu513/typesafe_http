import 'package:typesafehttp/models/post.dart';
import 'package:typesafehttp/models/post_serializable.dart';
import 'package:typesafehttp/networking/http_service.dart';
import 'package:typesafehttp/networking/method.dart';
import 'package:typesafehttp/networking/new_http_service.dart';
import 'package:typesafehttp/networking/request.dart';
import 'package:typesafehttp/networking/response.dart';

class PostRepository {
  PostSerializable _postSerializable;

  HttpService<Post, PostSerializable> _postHttpService;

  PostRepository() {
    _postSerializable = PostSerializable();
    _postHttpService = HttpService(_postSerializable);
  }

  final _baseUrl = "https://jsonplaceholder.typicode.com";

  Future<Post> get(String id) async {
    Request<Post> request =
        Request(Method.GET, "$_baseUrl/posts/$id", _postSerializable);
    Response<Post> post = await NewHttpService.instance
        .enqueue<Post, Post>(request, _postSerializable);
    print(post.getResponseBody().toJson());
    return post.getResponseBody();
  }

  Future<List<Post>> getAll() async {
    return _postHttpService.getAll("/posts");
  }

  Future<Post> send(Post post) async {
    return _postHttpService.post("/posts", post);
  }
}
