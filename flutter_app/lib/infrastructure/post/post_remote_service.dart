import 'dart:convert';
import 'dart:core';

import 'package:flutter_frontend/infrastructure/core/interpolation.dart';
import 'package:flutter_frontend/infrastructure/core/remote_service.dart';
import 'package:flutter_frontend/infrastructure/core/symfony_communicator.dart';
import 'package:http/http.dart';

import 'post_dtos.dart';

class PostRemoteService extends RemoteService<PostDto> {
  static const String postIdPath = "/event/post/";

  //commented out Unused path

  /*static const String postAddPath =
      "/event/{eventId}/post/"; //Path for creating*/
  //static const String postPaginatedPath = "/event/{eventId}/posts/{page}/";
  //static const String postDeletePath = "/event/post/";

  //Routes Lists
  static const String ownPostsPath = "/post/%amount%/%lastPostTime%";
  static const String feedPath = "/mainfeed/%amount%/%lastPostTime%";
  static const String postsFromUserPath = "/profile/post/%profileId%";
  static const String postsFromEventPath = "/event/%eventId%/posts/%amount%/%lastPostTime%";

  static const String postPath = "/event/post/";
  static const String deletePath = "/post/";
  static const String updatePath = "/post/";

  final SymfonyCommunicator client;

  PostRemoteService({required SymfonyCommunicator communicator})
      : client =
            communicator; // TODO this doesn't work on runtime -> will throw an error!

  //decode the json response for post
  Future<PostDto> _decodePost(Response json) async {
    return PostDto.fromJson(jsonDecode(json.body) as Map<String, dynamic>);
  }

  Future<List<PostDto>> getOwnPosts(DateTime lastPostTime, int amount) async {
    return _getPostList(ownPostsPath.interpolate({
      "amount": amount.toString(),
      "lastPostTime": lastPostTime.toString()
    }));
  }

  Future<List<PostDto>> getFeed(DateTime lastPostTime, int amount) async {
    return _getPostList(feedPath.interpolate({
      "amount": amount.toString(),
      "lastPostTime": lastPostTime.toIso8601String()
    }));
  }

  Future<List<PostDto>> getPostsFromUser(
      DateTime lastPostTime, int amount, String profileId) async {
    return _getPostList(postsFromUserPath.interpolate({
      "profileId": profileId,
      "amount": amount.toString(),
      "lastPostTime": lastPostTime.toString()
    }));
  }

  Future<List<PostDto>> getPostsFromEvent(
      DateTime lastPostTime, int amount, String eventId) async {
    return _getPostList(postsFromEventPath.interpolate({
      "eventId": eventId,
      "amount": amount.toString(),
      "lastPostTime": lastPostTime.toString()
    }));
  }

  Future<PostDto> getSingle(String id) async {
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
    return _decodePost(await client.delete("$deletePath${postDto.id}"));
  }

  Future<PostDto> updatePost(PostDto postDto) async {
    return _decodePost(await client.put(
        "$updatePath${postDto.id}", jsonEncode(postDto.toJson())));
  }

  /*static String generatePaginatedRoute(
      String route, int amount, DateTime lastCommentTime) {
    return "$route/$amount/$lastCommentTime";
  }*/

  Future<List<PostDto>> _getPostList(String path) async {
    final Response response = await client.get(path);
    return convertList(response);
  }
}
