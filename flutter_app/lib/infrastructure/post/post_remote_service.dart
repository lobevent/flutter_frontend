import 'dart:convert';
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter_frontend/infrastructure/core/symfony_communicator.dart';
import 'post_dtos.dart';
import 'package:http/http.dart';

class PostRemoteService {
  static const String _postIdPath = "/event/post/{postId}";
  static const String _postPaginatedPath = "/event/{eventId}/posts/{page}";
  static const String _postDeletePath = "/event/post/";
  static const String _ownPostsPath = "/event/post/"; //TODO don't know the path
  static const String _feedPath = "/event/post/"; //TODO don't know the path
  static const String _postsFromUserPath =
      "/event/post/"; //TODO don't know the path

  SymfonyCommunicator client;

  PostRemoteService() {
    client = SymfonyCommunicator(jwt: null); // TODO check on this one
  }

  Future<List<PostDto>> getOwnPosts() async {
    return _getPostList(_ownPostsPath);
  }

  Future<List<PostDto>> getFeed() async {
    return _getPostList(_feedPath);
  }

  Future<List<PostDto>> getPostsFromUser() async {
    return _getPostList(_postsFromUserPath);
  }

  Future<PostDto> getSinglePost(int id) async {
    // String uri = _postIdPath + id.toString(); // TODO use the dart best practice
    final String uri = "$_postIdPath$id";
    Response response = await client.get(uri);
    PostDto postDto =
        PostDto.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    return postDto;
  }

  Future<PostDto> getPaginated() async {
    //TODO
    throw UnimplementedError();
  }

  Future<void> create(PostDto post) async { //change return value to postDto
    client.post(_postIdPath, post.toJson());
    throw UnimplementedError();
    //return postDto; //TODO json decode extra function
  }

  Future<void> delete(PostDto post) async {
    // client.delete(_postDeletePath + post.id.toString()); // TODO use the dart best practice
    client.delete("$_postDeletePath${post.id}");
  }

  Future<void> update(PostDto postDto) {
    //TODO
    throw UnimplementedError();
  }

  Future<List<PostDto>> _getPostList(String path) async {
    final Response response = await client.get(path);
    final List<PostDto> posts = (jsonDecode(response.body) as List<
            Map<String,
                dynamic>>) // TODO one liners are nice for the flex xD but you already use a variable then I think it is easier to just put it into the next line
        .map((e) => PostDto.fromJson(e))
        .toList(); // TODO this is something we need to handle in a more robust and async way. This way will make our ui not responsive and also could fail if it's not a Map<String, dynamic>

    final List<Map<String, dynamic>> postsJsonList = jsonDecode(
        response
            .body) as List<
        Map<String,
            dynamic>>; // TODO same stuff with one variable and bit cleaner still we will have to rewrite it because of the json transformation
    return postsJsonList
        .map((postJsonMap) => PostDto.fromJson(postJsonMap))
        .toList();
  }
}
