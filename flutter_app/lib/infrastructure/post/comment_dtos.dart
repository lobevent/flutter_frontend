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
    @required @ParentConverter() Either<CommentDto, Unit> commentParent,
    @required int post,
    @ChildrenConverter() Either<int, Unit> commentChildren,
  }) = _CommentDto;

  ///generate dto from domain, respecting the different union cases
  ///
  /// map comment to parent or to full and generate the dto respectively
  factory CommentDto.fromDomain(Comment comment) {
    CommentDto returnedDto;
    //distinguish between the two Comment options
    comment.map(
        (CommentFull comment) => { //the full case
              returnedDto = CommentDto(
                id: comment.id,
                creationDate: comment.creationDate,
                profile: ProfileDto.fromDomain(comment.owner),
                commentContent: comment.commentContent.getOrCrash(),
                post: comment.post,
                //fold for the Either type
                commentParent: comment.commentParent.fold(
                    (l) => left(CommentDto.fromDomain(l)), (r) => right(r)),
                //leave out children, as they arent used in to Api communication
              ),
            },
        parent: (CommentParent comment) => { //the parent case
              returnedDto = CommentDto.parent(id: comment.id),
            });

    return returnedDto;
  }

  factory CommentDto.fromJson(Map<String, dynamic> json) =>
      _$CommentDtoFromJson(json);

  ///generate dto from domain, respecting the different union cases
  ///
  /// map comment to parent or to full and generate the entity respectively
  Comment toDomain() {
    Comment returnedComment;
    map(
        (_CommentDto value) => {
              returnedComment = Comment(
                id: this.id,
                creationDate: value.creationDate,
                commentContent: CommentContent(value.commentContent),
                owner: value.profile.toDomain(),
                commentChildren: value.commentChildren
                //left(left()) because of the complex Either type
                //where the list isn`t used here yet
                    .fold((l) => left(left(l)), (r) => right(r)),
                post: value.post,
              )
            }, parent: (_CommentParentDto value) {
      returnedComment = Comment.parent(id: value.id);
    });
    return returnedComment;
  }
}

///converts the Either type from and to json for comment children
class ChildrenConverter implements JsonConverter<Either<int, Unit>, Object> {
  const ChildrenConverter();

  @override
  ///get children property from json
  ///api returns number of children,
  ///but if its 0 we want to have an Unit in the Either
  ///
  /// throws [UnexpectedTypeError] if the type isn`t an integer
  Either<int, Unit> fromJson(Object json) {
    if (json is int && json > 0) {
      return left(json);
    } else if (json == 0) {
      return right(unit);
    }
    throw UnexpectedTypeError();
  }

  @override
  ///dont need that, as the api does not accept children
  Object toJson(Either<dynamic, dynamic> object) {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}

///converts the Either type from and to json for comment parent
class ParentConverter
    implements JsonConverter<Either<CommentDto, Unit>, Object> {
  const ParentConverter();

  @override
  //calls parent factory if an parent id is included in the api request
  //if not it reurns the unit type
  Either<CommentDto, Unit> fromJson(Object json) {
    if (json is int) {
      return left(CommentDto.parent(id: json));
    } else if (json == null) {
      return right(unit);
    }
    throw UnexpectedTypeError();
  }

  //converts parent unit type to null if no id is given
  @override
  Object toJson(Either<CommentDto, Unit> object) {
    return object.fold(
      (l) => left(l),
      (r) => right(null),
    );
  }
}
