import 'dart:convert';
import 'dart:core';

import 'package:flutter_frontend/infrastructure/core/interpolation.dart';
import 'package:flutter_frontend/infrastructure/core/remote_service.dart';
import 'package:flutter_frontend/infrastructure/core/symfony_communicator.dart';
import 'package:http/http.dart';

import 'comment_dtos.dart';

class CommentRemoteService extends RemoteService<CommentDto> {
  static const String commentIdGet = "/comment/";

  //commented out unused paths
  //static const String _commentAdd = "/event/post/{postId}/comment/{parentId}";
  //static const String _commentsGet = "/event/post/{postId}/comment";

  //Routes Lists
  static const String ownCommentsPath = "/comments/%amount%/%lastCommentTime%";
  static const String commentsFromUserPath =
      "/profile/%profileId%/comments/%amount%/%lastCommentTime%";
  static const String commentsFromCommentParentPath =
      "/comment/%parentCommentId%/comment/%amount%/%lastCommentTime%";
  static const String commentsFromPostPath =
      "/event/post/%postId%/comment/%amount%/%lastCommentTime%";
  static const String postPathComment =
      "/event/post/%parentId%";
  static const String postPath = "/comment";
  static const String deletePath = "/comment";
  static const String updatePath = "/comment";
  static const String deleteCommentPath =
      "/event/post/comment/delete/%commentId%";

  //either comment or post as parent

  SymfonyCommunicator client;

  CommentRemoteService({required SymfonyCommunicator communicator})
      : client = communicator; // TODO check on this one

  //decode the json response for post
  //TODO dont know if this is stable, because of cancer childrenconverter
  Future<CommentDto> _decodeComment(Response json) async {
    return CommentDto.fromJson(jsonDecode(json.body) as Map<String, dynamic>);
  }

  Future<List<CommentDto>> getCommentsFromPost(
      DateTime lastCommentTime, int amount, String postId) async {
    return _getCommentList(commentsFromPostPath.interpolate({
      "postId": postId,
      "amount": amount.toString(),
      "lastCommentTime": lastCommentTime.toString()
    }));
  }

  Future<List<CommentDto>> getOwnComments(
      DateTime lastCommentTime, int amount) async {
    return _getCommentList(commentsFromPostPath.interpolate({
      "amount": amount.toString(),
      "lastCommentTime": lastCommentTime.toString()
    }));
  }

  Future<List<CommentDto>> getCommentsFromUser(
      DateTime lastCommentTime, int amount, String profileId) async {
    return _getCommentList(commentsFromUserPath.interpolate({
      "profileId": profileId,
      "amount": amount.toString(),
      "lastCommentTime": lastCommentTime.toString()
    }));
  }

  Future<List<CommentDto>> getCommentsFromCommentParent(
      DateTime lastCommentTime, int amount, String parentCommentId) async {
    return _getCommentList(commentsFromCommentParentPath.interpolate({
      "parentCommentId": parentCommentId,
      "amount": amount.toString(),
      "lastCommentTime": lastCommentTime.toString()
    }));
  }

  Future<CommentDto> getSingleComment(String id) async {
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
    return _decodeComment(await client.delete("$deletePath/${commentDto.id}"));
  }

  Future<CommentDto> update(CommentDto commentDto) async {
    return _decodeComment(await client.put(
        "$updatePath${commentDto.id}", jsonEncode(commentDto.toJson())));
  }

  //Not necessery anymore
  /*String _generatePaginatedRoute(
      String route, int amount, DateTime lastCommentTime) {
    return "$route/comments/$amount/$lastCommentTime/";
  }*/

  Future<List<CommentDto>> _getCommentList(String path) async {
    final Response response = await client.get(path);
    return convertList(response);
  }

  Future<CommentDto> createComment(
      CommentDto commentDto, String parentId) async {
    return _decodeComment(await client.post(
        postPathComment.interpolate({
          "parentId": parentId,
        }),
        jsonEncode(commentDto.toJson())));
  }

  Future<CommentDto> deletePostOrComment(String commentId) async {
    return _decodeComment(await client.delete(deleteCommentPath.interpolate({
      "commentId": commentId,
    })));
  }
}
