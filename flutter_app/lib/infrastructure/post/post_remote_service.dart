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

  SymfonyCommunicator client;

  PostRemoteService() {
    client = SymfonyCommunicator(jwt: null); // TODO check on this one
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
  }

  void create(PostDto post) async {
    client.post(_postIdPath, post.toJson());
  }

  void delete(PostDto post) async {
    // client.delete(_postDeletePath + post.id.toString()); // TODO use the dart best practice
    client.delete("$_postDeletePath${post.id}");
  }

  void update(PostDto postDto) {
    //TODO
    throw UnimplementedError();
  }
}
