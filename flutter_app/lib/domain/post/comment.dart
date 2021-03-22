import 'package:dartz/dartz.dart';

import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/post/value_objects.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment.freezed.dart';

@freezed
class Comment implements _$Comment {
  const Comment._();

  const factory Comment({
    required Id id,
    required DateTime creationDate,
    required CommentContent commentContent,
    required Profile owner,
    required int post,
    //TODO change this, all kid comments are comments. lazy loading from application layer (cubit)
    Either<CommentParent, Unit> commentParent,
    Comment commentChildren, // TODO find some solution for this one
  }) = CommentFull;

  const factory Comment.withoutId({
    required DateTime creationDate,
    required CommentContent commentContent,
    required Profile owner,
    required int post,
    //TODO change this, all kid comments are comments. lazy loading from application layer (cubit)
    Either<CommentParent, Unit> commentParent,
    Comment commentChildren, // TODO find some solution for this one
  }) = CommentWithoutId;

  const factory Comment.parent({
    required Id id,
  }) = CommentParent;

  const factory Comment.childLess() = CommentChildLess;

  const factory Comment.childCount(
    required int count,
  ) = CommentChildCount;

  const factory Comment.children({
    required int count,
    required List<Comment> commentChildren,
  }) = CommentChildren;

  // check if the whole object is no failure
  // TODO same as in domain/event/event.dart
  Option<ValueFailure<dynamic>> get failureOption {
    return maybeMap(
        (CommentFull value) => value.commentContent.failureOrUnit.fold(
              (f) => some(f),
              (_) => none(),
            ),
        orElse: () => none());
  }
}

extension CommentX on CommentFull {
  void set commentChildren(CommentChildren commentChi) {
    commentChildren = commentChi;
  }
}
