import 'dart:convert';
import 'dart:core';

import 'package:flutter_frontend/infrastructure/core/exceptions.dart';
import 'package:flutter_frontend/infrastructure/core/symfony_communicator.dart';
import 'comment_dtos.dart';
import 'package:http/http.dart';

class CommentRemoteService {
  static const String _commentAdd = "/event/post/{postId}/comment/{parentId}";
  static const String _commentsGet = "/event/post/{postId}/comment";
  static const String commentIdGet = "/comment/";
  static const String commentsFromPostPath = "/post/";
  static const String ownCommentsPath = "/comment/"; //TODO create route for it
  static const String commentsFromUserPath =
      "/comment/"; //TODO create route for it
  static const String commentsFromCommentParentPath = "/comment/";

  static const String postPath = "/comment";
  static const String deletePath = "/comment";
  static const String updatePath = "/comment";

  //either comment or post as parent

  SymfonyCommunicator client;

  CommentRemoteService() {
    client = SymfonyCommunicator(jwt: null); // TODO check on this one
  }

  //decode the json response for post
  //TODO dont know if this is stable, because of cancer childrenconverter
  Future<CommentDto> _decodeComment(Response json) async {
    return CommentDto.fromJson(jsonDecode(json.body) as Map<String, dynamic>);
  }

  Future<List<CommentDto>> getCommentsFromPost(
      DateTime lastCommentTime, int amount, String postId) async {
    return _getCommentList(_generatePaginatedRoute(
        "$commentsFromPostPath$postId", amount, lastCommentTime));
  }

  Future<List<CommentDto>> getOwnComments(
      DateTime lastCommentTime, int amount) async {
    throw UnimplementedError(); //This path is not yet defined properly
    return _getCommentList(ownCommentsPath);
  }

  Future<List<CommentDto>> getCommentsFromUser(
      DateTime lastCommentTime, int amount, String profileId) async {
    throw UnimplementedError(); //This path is not yet defined properly
    return _getCommentList(commentsFromUserPath);
  }

  Future<List<CommentDto>> getCommentsFromCommentParent(
      DateTime lastCommentTime, int amount, String parentCommentId) async {
    return _getCommentList(_generatePaginatedRoute(
        "$commentsFromCommentParentPath$parentCommentId",
        amount,
        lastCommentTime));
  }

  Future<CommentDto> getSingleComment(int id) async {
    // String uri = _postIdPath + id.toString(); // TODO use the dart best practice
    final String uri = "$commentIdGet$id";
    Response response = await client.get(uri);
    CommentDto returnedCommentDto = await _decodeComment(response);
    //CommentDto commentDto = CommentDto.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    return returnedCommentDto;
  }

  Future<CommentDto> create(CommentDto commentDto) async {
    return _decodeComment(
        await client.post(postPath, jsonEncode(commentDto.toJson())));
  }

  Future<CommentDto> delete(CommentDto commentDto) async {
    return _decodeComment(await client.delete(
        "$deletePath${commentDto.maybeMap((value) => value.id, orElse: () => throw UnexpectedFormatException())}"));
  }

  Future<CommentDto> update(CommentDto commentDto) async {
    return _decodeComment(await client.put(
        "$updatePath${commentDto.maybeMap((value) => value.id, orElse: () => throw UnexpectedFormatException())}",
        jsonEncode(commentDto.toJson())));
  }

  String _generatePaginatedRoute(
      String route, int amount, DateTime lastCommentTime) {
    return "$route/comments/$amount/$lastCommentTime";
  }

  Future<List<CommentDto>> _getCommentList(String path) async {
    final Response response = await client.get(path);

    final List<
        Map<String,
            dynamic>> commentsJsonList = jsonDecode(response.body) as List<
        Map<
            String, // TODO this is something we need to handle in a more robust and async way. This way will make our ui not responsive and also could fail if it's not a Map<String, dynamic>
            dynamic>>; // TODO same stuff with one variable and bit cleaner still we will have to rewrite it because of the json transformation
    return commentsJsonList
        .map((commentJsonMap) => CommentDto.fromJson(commentJsonMap))
        .toList();
  }
}
