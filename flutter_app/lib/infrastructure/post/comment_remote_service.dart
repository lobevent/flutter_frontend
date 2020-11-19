import 'dart:convert';
import 'dart:core';

import 'package:flutter_frontend/infrastructure/core/exceptions.dart';
import 'package:flutter_frontend/infrastructure/core/symfony_communicator.dart';
import 'comment_dtos.dart';
import 'package:http/http.dart';

class CommentRemoteService {
  static const String _commentAdd = "/event/post/{postId}/comment/{parentId}";
  static const String _commentsGet = "/event/post/{postId}/comment";
  static const String _commentDelete = "/comment";
  static const String _commentIdGet = "/comment";
  static const String _commentUpdate = "/comment";
  static const String _commentsPaginated = "/comment";

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

  Future<List<CommentDto>> getCommentsFromPost() async {
    return _getCommentList(_commentsGet);
  }

  Future<CommentDto> getSingleComment(int id) async {
    // String uri = _postIdPath + id.toString(); // TODO use the dart best practice
    final String uri = "$_commentIdGet$id";
    Response response = await client.get(uri);
    CommentDto returnedCommentDto = await _decodeComment(response);
    //CommentDto commentDto = CommentDto.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    return returnedCommentDto;
  }

  Future<List<CommentDto>> getPaginated() async {
    //TODO
    throw UnimplementedError();
  }

  Future<CommentDto> create(CommentDto commentDto) async {
    return _decodeComment(
        await client.post(postPath, jsonEncode(commentDto.toJson())));
  }

  Future<CommentDto> delete(CommentDto commentDto) async {
    return _decodeComment(
        await client.delete("$deletePath${commentDto.maybeMap((value) => value.id, orElse: ()
        => throw UnexpectedFormatException())}"));
  }

  Future<CommentDto> update(CommentDto commentDto) async {
    return _decodeComment(
        await client.put(
            "$updatePath${commentDto.maybeMap((value) => value.id, orElse: ()
            => throw UnexpectedFormatException())}", jsonEncode(commentDto.toJson())));
  }

  Future<List<CommentDto>> _getCommentList(String path) async {
    final Response response = await client.get(path);
    final List<CommentDto> comments = (jsonDecode(response.body) as List<
            Map<String,
                dynamic>>) // TODO one liners are nice for the flex xD but you already use a variable then I think it is easier to just put it into the next line
        .map((e) => CommentDto.fromJson(e))
        .toList(); // TODO this is something we need to handle in a more robust and async way. This way will make our ui not responsive and also could fail if it's not a Map<String, dynamic>

    final List<Map<String, dynamic>> commentsJsonList = jsonDecode(
        response
            .body) as List<
        Map<String,
            dynamic>>; // TODO same stuff with one variable and bit cleaner still we will have to rewrite it because of the json transformation
    return commentsJsonList
        .map((commentJsonMap) => CommentDto.fromJson(commentJsonMap))
        .toList();
  }
}
