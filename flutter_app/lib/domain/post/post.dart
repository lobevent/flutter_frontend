import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/comment/comment.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/post/value_objects.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post.freezed.dart';

@freezed
abstract class Post implements _$Post {
  const Post._();

  const factory Post({
    @required int id,
    @required DateTime creationDate,
    @required PostContent postContent,
    @required Profile owner,
    @required Event event,
    @required List<Comment> comments,
  }) = _Post;
//check if the whole object is no failure
  Option<ValueFailure<dynamic>> get failureOption {
    return postContent.failureOrUnit.fold((f) => some(f), (_) => none());
  }
}
