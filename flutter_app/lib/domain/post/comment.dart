import 'package:dartz/dartz.dart';

import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/post/post.dart';
import 'package:flutter_frontend/domain/post/value_objects.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment.freezed.dart';

@freezed
class Comment with _$Comment {
  const Comment._();

  const factory Comment({
    required UniqueId id,
    required DateTime creationDate,
    required CommentContent commentContent,
    required Profile owner,
    required Post post,
    //TODO change this, all kid comments are comments. lazy loading from application layer (cubit)
    Comment? commentParent,
    List<Comment>? commentChildren, // TODO find some solution for this one
    int? childCount,

  }) = CommentFull;



  // check if the whole object is no failure
  // TODO same as in domain/event/event.dart
  Option<ValueFailure<dynamic>> get failureOption {
    return commentContent.failureOrUnit.fold(
              (f) => some(f),
              (_) => none(),
            );
  }
}


