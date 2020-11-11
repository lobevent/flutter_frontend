import 'dart:convert';
import 'dart:core';

import 'package:flutter_frontend/infrastructure/core/symfony_communicator.dart';

class CommentRemoteService {
  static const String _commentAdd = "/event/post/{postId}/comment/{parentId}";
  static const String _commentsGet = "/event/post/{postId}/comment";
//TODO//
}
