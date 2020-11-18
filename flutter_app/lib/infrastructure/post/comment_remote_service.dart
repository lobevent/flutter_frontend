import 'dart:convert';
import 'dart:core';

import 'package:flutter_frontend/infrastructure/core/symfony_communicator.dart';
import 'comment_dtos.dart';
import 'package:http/http.dart';

class CommentRemoteService {
  static const String _commentAdd = "/event/post/{postId}/comment/{parentId}";
  static const String _commentsGet = "/event/post/{postId}/comment";
//TODO//

  SymfonyCommunicator client;

  CommentRemoteService() {
    client = SymfonyCommunicator(jwt: null); // TODO check on this one
  }

  //decode the json response for post
  Future<CommentDto> _decodePost(Response json) async {
    return CommentDto.fromJson(jsonDecode(json.body) as Map<String, dynamic>);
  }
}
