import 'dart:convert';
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter_frontend/infrastructure/core/symfony_communicator.dart';
import 'post_dtos.dart';
import 'package:http/http.dart';

class PostRemoteService {
  final String _POSTIDPATH = "/event/post/{postId}";
  final String _POSTPAGINATEDPATH = "/event/{eventId}/posts/{page}";
  final String _POSTDELETEPATH = "/event/post/";

  SymfonyCommunicator client;

  PostRemoteService() {
    client = SymfonyCommunicator(jwt: null);
  }

  Future<PostDto> getSinglePost(int id) async {
    String uri = _POSTIDPATH + id.toString();
    Response response = await client.get(uri);
    PostDto postDto =
        PostDto.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    return postDto;
  }

  Future<PostDto> getPaginated() async {
    //TODO
  }

  void create(PostDto post) async {
    client.post(_POSTIDPATH, post.toJson());
  }

  void delete(PostDto post) async {
    client.delete(_POSTDELETEPATH + post.id.toString());
  }

  void update(PostDto postDto) {
    //TODO
    throw UnimplementedError();
  }
}
