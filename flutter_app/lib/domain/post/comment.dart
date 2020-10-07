import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/post/post.dart';
import 'package:flutter_frontend/domain/post/value_objects.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment.freezed.dart';

@freezed
abstract class Comment implements _$Comment {
  const Comment._();

  const factory Comment({
    @required int id,
    @required DateTime creationDate,
    @required CommentContent commentContent,
    @required Profile owner,
    @required int post,
    Either<CommentParent, Unit> commentParent,
    Either<Either<int, List<Comment>>, Unit> commentChildren,
  }) = CommentFull;

  const factory Comment.parent({
    @required int id,
  }) = CommentParent;

//check if the whole object is no failure
  Option<ValueFailure<dynamic>> get failureOption {
    return maybeMap(
            (CommentFull value) => value.commentContent.failureOrUnit.fold((f) => some(f), (_) => none()),
            orElse: () => none());

  }
}
