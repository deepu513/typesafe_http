import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:typesafehttp/bloc/post/post_bloc.dart';
import 'package:typesafehttp/bloc/post/post_event.dart';
import 'package:typesafehttp/bloc/post/post_state.dart';
import 'package:typesafehttp/networking/logging_interceptor.dart';
import 'package:typesafehttp/networking/new_http_service.dart';
import 'package:typesafehttp/networking/request_header_interceptor.dart';
import 'package:typesafehttp/repository/settings_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  NewHttpService([
    //TODO: Check if the build is debug build, then only add this interceptor
    LoggingInterceptor(),
    RequestHeaderInterceptor(await SettingsRepository.getInstance())
  ], () {
    // on session expired, should add event in bloc,
    // which will output a state and logout user.
  });

  runApp(BlocProvider(
      create: (context) {
        return PostBloc();
      },
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Typesafe HTTP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Typesafe HTTP"),
      ),
      body: Center(
        child: BlocBuilder<PostBloc, PostState>(
          builder: (context, postState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  child: Text('Get single post'),
                  onPressed: () =>
                      BlocProvider.of<PostBloc>(context).add(PostRequested()),
                ),
                RaisedButton(
                  child: Text('Get All posts'),
                  onPressed: () => BlocProvider.of<PostBloc>(context)
                      .add(AllPostsRequested()),
                ),
                RaisedButton(
                  child: Text('Send a post'),
                  onPressed: () =>
                      BlocProvider.of<PostBloc>(context).add(SendPost()),
                ),
                Text(postState.toString())
              ],
            );
          },
        ),
      ),
    );
  }
}
