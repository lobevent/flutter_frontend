import 'package:flutter_frontend/domain/comment/value_objects.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/post/post.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment.freezed.dart';

@freezed
abstract class Comment with _$Comment {
  const factory Comment({
    @required int id,
    @required DateTime creationDate,
    @required CommentContent commentContent,
    @required Profile owner,
    @required Event event,
    @required Post post,
    @required Comment commentParent,
    List<Comment> commentChilds,
  }) = _Comment;
}
