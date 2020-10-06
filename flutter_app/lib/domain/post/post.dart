import 'package:flutter_frontend/domain/comment/comment.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/post/value_objects.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post.freezed.dart';

@freezed
abstract class Post with _$Post {
  const factory Post({
    @required int id,
    @required DateTime creationDate,
    @required PostContent postContent,
    @required Profile owner,
    @required Event event,
    @required List<Comment> comments,
  }) = _Post;
}
