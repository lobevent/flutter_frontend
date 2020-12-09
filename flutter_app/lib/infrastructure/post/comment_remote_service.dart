import 'dart:convert';
import 'dart:core';

import 'package:flutter_frontend/infrastructure/core/exceptions.dart';
import 'package:flutter_frontend/infrastructure/core/symfony_communicator.dart';
import 'comment_dtos.dart';
import 'package:http/http.dart';
import 'package:flutter_frontend/infrastructure/core/interpolation.dart';

class CommentRemoteService {
  static const String commentIdGet = "/comment/";

  //commented out unused paths
  //static const String _commentAdd = "/event/post/{postId}/comment/{parentId}";
  //static const String _commentsGet = "/event/post/{postId}/comment";


  //Routes Lists
  static const String ownCommentsPath = "/comments/%amount%/%lastCommentTime%/";
  static const String commentsFromUserPath = "/profile/%profileId%/comments/%amount%/%lastCommentTime%/";
  static const String commentsFromCommentParentPath = "/comment/%parentCommentId%/comments/%amount%/%lastCommentTime%/";
  static const String commentsFromPostPath ="/post/%postId%/comments/%amount%/%lastCommentTime%/";

  static const String postPath = "/comment";
  static const String deletePath = "/comment";
  static const String updatePath = "/comment";

  //either comment or post as parent

  SymfonyCommunicator client;

  CommentRemoteService({SymfonyCommunicator communicator})
      : client = communicator ??
            SymfonyCommunicator(jwt: null); // TODO check on this one

  //decode the json response for post
  //TODO dont know if this is stable, because of cancer childrenconverter
  Future<CommentDto> _decodeComment(Response json) async {
    return CommentDto.fromJson(jsonDecode(json.body) as Map<String, dynamic>);
  }

  Future<List<CommentDto>> getCommentsFromPost(
      DateTime lastCommentTime, int amount, String postId) async {
    return _getCommentList(commentsFromPostPath.interpolate(
        {"postId" : postId, "amount" : amount.toString(), "lastCommentTime" : lastCommentTime.toString()}));
  }

  Future<List<CommentDto>> getOwnComments(
      DateTime lastCommentTime, int amount) async {
    return _getCommentList(commentsFromPostPath.interpolate(
        {"amount" : amount.toString(), "lastCommentTime" : lastCommentTime.toString()}));
  }

  Future<List<CommentDto>> getCommentsFromUser(
      DateTime lastCommentTime, int amount, String profileId) async {
    return _getCommentList(commentsFromUserPath.interpolate(
        {"profileId" : profileId, "amount" : amount.toString(), "lastCommentTime" : lastCommentTime.toString()}));
  }

  Future<List<CommentDto>> getCommentsFromCommentParent(
      DateTime lastCommentTime, int amount, String parentCommentId) async {
    return _getCommentList(commentsFromCommentParentPath.interpolate(
        {"parentCommentId" : parentCommentId, "amount" : amount.toString(), "lastCommentTime" : lastCommentTime.toString()}));
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

  //Not necessery anymore
  /*String _generatePaginatedRoute(
      String route, int amount, DateTime lastCommentTime) {
    return "$route/comments/$amount/$lastCommentTime/";
  }*/

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
