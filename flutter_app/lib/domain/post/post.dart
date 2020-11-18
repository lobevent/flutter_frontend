import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';

import 'package:flutter_frontend/domain/post/comment.dart';
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
    @required Id id,
    @required DateTime creationDate,
    @required PostContent postContent,
    @required Profile owner,
    @required Event event,
    @required List<Comment> comments,
  }) = _Post;

  const factory Post.WithoutId({
    @required DateTime creationDate,
    @required PostContent postContent,
    @required Profile owner,
    @required Event event,
    @required List<Comment> comments,
  }) = PostWithoutId;

  //check if the whole object is no failure
  // TODO same as in domain/event/event.dart
  // TODO in this case if you only check one data field this is already implemented. Just realized it yet but it should actually also work for the other case. The base class ValueObjects implements failureOrUnit why not use it?
  Option<ValueFailure<dynamic>> get failureOption {
    return postContent.failureOrUnit.fold((f) => some(f), (_) => none());
  }
}
