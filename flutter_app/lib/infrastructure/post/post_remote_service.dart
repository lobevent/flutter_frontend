import 'dart:convert';
import 'dart:core';

import 'package:flutter_frontend/infrastructure/core/exceptions.dart';
import 'package:flutter_frontend/infrastructure/core/symfony_communicator.dart';
import 'package:http/http.dart';

import 'post_dtos.dart';

class PostRemoteService {
  static const String postIdPath = "/event/post/";
  static const String postAddPath =
      "/event/{eventId}/post/"; //Path for creating
  static const String postPaginatedPath = "/event/{eventId}/posts/{page}";
  static const String postDeletePath = "/event/post/";
  static const String ownPostsPath = "/post/"; //TODO don't know the path
  static const String feedPath = "/feed/post/"; //TODO don't know the path
  static const String postsFromUserPath =
      "/profile/post/"; //TODO don't know the path

  static const String postPath = "/post/";
  static const String deletePath = "/post/";
  static const String updatePath = "/post/";

  SymfonyCommunicator client;

  PostRemoteService({SymfonyCommunicator communicator})
      : client = communicator ??
            SymfonyCommunicator(jwt: null); // TODO check on this one

  //decode the json response for post
  Future<PostDto> _decodePost(Response json) async {
    return PostDto.fromJson(jsonDecode(json.body) as Map<String, dynamic>);
  }

  Future<List<PostDto>> getOwnPosts(
      DateTime lastCommentTime, int amount) async {
    return _getPostList(
        generatePaginatedRoute(ownPostsPath, amount, lastCommentTime));
  }

  Future<List<PostDto>> getFeed(DateTime lastCommentTime, int amount) async {
    return _getPostList(
        generatePaginatedRoute(feedPath, amount, lastCommentTime));
  }

  Future<List<PostDto>> getPostsFromUser(
      DateTime lastCommentTime, int amount, String profileId) async {
    return _getPostList(generatePaginatedRoute(
        "$postsFromUserPath/$profileId", amount, lastCommentTime));
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

  static String generatePaginatedRoute(
      String route, int amount, DateTime lastCommentTime) {
    return "$route/$amount/$lastCommentTime";
  }

  Future<List<PostDto>> _getPostList(String path) async {
    final Response response = await client.get(path);
    final List<Map<String, dynamic>> postsJsonList = jsonDecode(response.body) as List<
        Map<
            String, // TODO this is something we need to handle in a more robust and async way. This way will make our ui not responsive and also could fail if it's not a Map<String, dynamic>
            dynamic>>; // TODO same stuff with one variable and bit cleaner still we will have to rewrite it because of the json transformation
    return postsJsonList
        .map((postJsonMap) => PostDto.fromJson(postJsonMap))
        .toList();
  }
}
