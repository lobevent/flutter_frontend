import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/errors.dart';
import 'package:flutter_frontend/domain/post/value_objects.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/post/comment.dart';

import '../event/event_dtos.dart';
import '../profile/profile_dtos.dart';
import 'post_dtos.dart';
part 'comment_dtos.freezed.dart';
part 'comment_dtos.g.dart';

@freezed
abstract class CommentDto with _$CommentDto {
  const CommentDto._();

  const factory CommentDto.parent({
    @required int id,
  }) = _CommentParentDto;

  const factory CommentDto({
    @required int id,
    @required String commentContent,
    @required DateTime creationDate,
    @required ProfileDto profile,
    @required EventDto event,
    @required @ParentConverter() Either<CommentDto, Unit> commentParent,
    @required int post,
    @ChildrenConverter() Either<int, Unit> commentChildren,
  }) = _CommentDto;

  factory CommentDto.fromDomain(Comment comment) {
    CommentDto returnedDto;
    comment.map(
        (CommentFull comment) => {
              returnedDto = CommentDto(
                id: comment.id,
                creationDate: comment.creationDate,
                profile: ProfileDto.fromDomain(comment.owner),
                event: EventDto.fromDomain(comment.event),
                commentContent: comment.commentContent.getOrCrash(),
                post: comment.post,
                commentParent: comment.commentParent.fold(
                    (l) => left(CommentDto.fromDomain(l)), (r) => right(r)),
              ),
            },
        parent: (CommentParent comment) => {
              returnedDto = CommentDto.parent(id: comment.id),
            });

    return returnedDto;
  }

  factory CommentDto.fromJson(Map<String, dynamic> json) =>
      _$CommentDtoFromJson(json);

  Comment toDomain() {
    Comment returnedComment;
    map(
        (_CommentDto value) => {
              returnedComment = Comment(
                id: this.id,
                creationDate: value.creationDate,
                commentContent: CommentContent(value.commentContent),
                owner: value.profile.toDomain(),
                event: value.event.toDomain(),
                commentChildren: value.commentChildren
                    .fold((l) => left(left(l)), (r) => right(r)),
                post: value.post,
              )
            }, parent: (_CommentParentDto value) {
      returnedComment = Comment.parent(id: value.id);
    });
    return returnedComment;
  }
}

class ChildrenConverter implements JsonConverter<Either<int, Unit>, Object> {
  const ChildrenConverter();

  @override
  Either<int, Unit> fromJson(Object json) {
    if (json is int && json > 0) {
      return left(json);
    } else if (json == 0) {
      return right(unit);
    }
    throw UnexpectedTypeError();
  }

  @override
  Object toJson(Either<dynamic, dynamic> object) {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}

class ParentConverter
    implements JsonConverter<Either<CommentDto, Unit>, Object> {
  const ParentConverter();

  @override
  Either<CommentDto, Unit> fromJson(Object json) {
    if (json is int) {
      return left(CommentDto.parent(id: json));
    } else if (json == 0) {
      return right(unit);
    }
    throw UnexpectedTypeError();
  }

  @override
  Object toJson(Either<CommentDto, Unit> object) {
    return object.fold(
      (l) => left(l),
      (r) => right(null),
    );
  }
}
