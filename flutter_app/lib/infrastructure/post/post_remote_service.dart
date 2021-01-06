import 'dart:convert';
import 'dart:core';

import 'package:flutter_frontend/infrastructure/core/exceptions.dart';
import 'package:flutter_frontend/infrastructure/core/symfony_communicator.dart';
import 'package:http/http.dart';
import 'package:flutter_frontend/infrastructure/core/interpolation.dart';


import 'post_dtos.dart';

class PostRemoteService {

  static const String postIdPath = "/event/post/";

  //commented out Unused path

  /*static const String postAddPath =
      "/event/{eventId}/post/"; //Path for creating*/
  //static const String postPaginatedPath = "/event/{eventId}/posts/{page}/";
  //static const String postDeletePath = "/event/post/";

  //Routes Lists
  static const String ownPostsPath = "/post/%amount%/%lastPostTime%";
  static const String feedPath = "/feed/post/%amount%/%lastPostTime%";
  static const String postsFromUserPath = "/profile/post/%profileId%";

  static const String postPath = "/event/post/";
  static const String deletePath = "/post/";
  static const String updatePath = "/post/";

  final SymfonyCommunicator client;

  PostRemoteService({SymfonyCommunicator communicator})
      : client = communicator ??
      SymfonyCommunicator(
          jwt:
          null); // TODO this doesn't work on runtime -> will throw an error!


  //decode the json response for post
  Future<PostDto> _decodePost(Response json) async {
    return PostDto.fromJson(jsonDecode(json.body) as Map<String, dynamic>);
  }

  Future<List<PostDto>> getOwnPosts(
      DateTime lastPostTime, int amount) async {
    return _getPostList(
        ownPostsPath.interpolate(
            {"amount" : amount.toString(), "lastPostTime" : lastPostTime.toString()}));
  }

  Future<List<PostDto>> getFeed(DateTime lastPostTime, int amount) async {
    return _getPostList(
        feedPath.interpolate(
            {"amount" : amount.toString(), "lastPostTime" : lastPostTime.toString()}));
  }

  Future<List<PostDto>> getPostsFromUser(
      DateTime lastPostTime, int amount, String profileId) async {
    return _getPostList(
        postsFromUserPath.interpolate(
            {"profileId": profileId, "amount" : amount.toString(), "lastPostTime" : lastPostTime.toString()}));
  }

  Future<PostDto> getSingle(int id) async {
    // String uri = _postIdPath + id.toString(); // TODO use the dart best practice
    final String uri = "$postIdPath$id";
    final Response response = await client.get(uri);
    final PostDto postDto = await _decodePost(response);
    return postDto;
  }

  Future<PostDto> createPost(PostDto postDto) async {
    return _decodePost(
        await client.post(postPath, jsonEncode(postDto.toJson())));
  }

  Future<PostDto> deletePost(PostDto postDto) async {
    return _decodePost(await client.delete(
        "$deletePath${postDto.maybeMap((value) => value.id, orElse: () => throw UnexpectedFormatException())}"));
  }

  Future<PostDto> updatePost(PostDto postDto) async {
    return _decodePost(await client.put(
        "$updatePath${postDto.maybeMap((value) => value.id, orElse: () => throw UnexpectedFormatException())}",
        jsonEncode(postDto.toJson())));
  }

  /*static String generatePaginatedRoute(
      String route, int amount, DateTime lastCommentTime) {
    return "$route/$amount/$lastCommentTime";
  }*/

  Future<List<PostDto>> _getPostList(String path) async {
    final Response response = await client.get(path);



    List<PostDto> posts;
    try {
      posts = ((jsonDecode(response.body) as List)
          .map((e) => e as Map<String, dynamic>))
          .toList() // TODO one liners are nice for the flex xD but you already use a variable then I think it is easier to just put it into the next line
          .map((e) => PostDto.fromJson(e))
          .toList(); // TODO this is something we need to handle in a more robust and async way. This way will make our ui not responsive and also could fail if it's not a Map<String, dynamic>
    } on Exception {
      throw UnexpectedFormatException();
    }

    return posts;
  }



}
