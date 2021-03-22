import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_frontend/infrastructure/core/base_dto.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/core/errors.dart';
import 'package:flutter_frontend/domain/post/value_objects.dart';
import 'package:flutter_frontend/domain/post/comment.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_dtos.dart';

part 'comment_dtos.freezed.dart';
part 'comment_dtos.g.dart';

// TODO I will go through infrastructure

@freezed
class CommentDto extends BaseDto with _$CommentDto {
  const CommentDto._();

  const factory CommentDto.parent({
    required String id,
  }) = _CommentParentDto;

  const factory CommentDto({
    required String id,
    required String commentContent,
    required DateTime creationDate,
    required ProfileDto profile, //TODO: make it an integer
    @ParentConverter() required Either<CommentDto, Unit> commentParent,
    required int post,
    @ChildrenConverter()  Either<int, Unit>? commentChildren,
  }) = _CommentDto;

  const factory CommentDto.WithoutId({
    required String commentContent,
    required DateTime creationDate,
    required ProfileDto profile, //TODO: make it an integer
    @ParentConverter() required Either<CommentDto, Unit> commentParent,
    required int post,
    @ChildrenConverter() required Either<int, Unit> commentChildren,
  }) = _CommentDtoWithoutId;

  //TODO: is this intager usefull? Determine that shit!
  const factory CommentDto.children({
    required int count,
    required List<CommentDto> children,
  }) = _CommentChildrenDto;

  /// Generate dto from domain, respecting the different union cases
  /// Map comment to parent or to full and generate the dto respectively
  ///
  // TODO this function does something really really strange! The syntax is a little bit mixed up but also it does not what it should
  factory CommentDto.fromDomain(Comment comment) {
    CommentDto returnedDto;
    //distinguish between the two Comment options
    comment.maybeMap(
        (CommentFull comment) => {
              //the full case
              returnedDto = CommentDto(
                id: comment.id.getOrCrash(),
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
        parent: (CommentParent comment) => {
              //the parent case
              returnedDto = CommentDto.parent(id: comment.id.getOrCrash()),
            },
        orElse: () {});

    return returnedDto;
  }

  factory CommentDto.fromJson(Map<String, dynamic> json) =>
      _$CommentDtoFromJson(json);

  /// Generate dto from domain, respecting the different union cases
  /// Map comment to parent or to full and generate the entity respectively
  // TODO this function does something really really strange! The syntax is a little bit mixed up but also it does not what it should
  @override
  Comment toDomain() {
    Comment returnedComment;
    map(
        (_CommentDto value) => {
              returnedComment = Comment(
                id: Id.fromUnique(value.id),
                creationDate: value.creationDate,
                commentContent: CommentContent(value.commentContent),
                owner: value.profile.toDomain(),
                commentChildren: value.commentChildren
                    //left(left()) because of the complex Either type
                    //where the list isn`t used here yet
                    .fold((l) => Comment.childCount(l),
                        (r) => const Comment.childLess()),
                post: value.post,
              )
            }, parent: (_CommentParentDto value) {
      returnedComment = Comment.parent(id: Id.fromUnique(value.id));
    }, children: (_CommentChildrenDto value) {
      returnedComment = Comment.children(
          count: value.count,
          commentChildren: value.children
              .map((commentDto) => commentDto.toDomain())
              .toList());
    }, WithoutId: (_CommentDtoWithoutId value) {
      returnedComment = CommentWithoutId(
        creationDate: value.creationDate,
        commentContent: CommentContent(value.commentContent),
        owner: value.profile.toDomain(),
        commentChildren: value.commentChildren
            //left(left()) because of the complex Either type
            //where the list isn`t used here yet
            .fold(
                (l) => Comment.childCount(l), (r) => const Comment.childLess()),
        post: value.post,
      );
    });
    return returnedComment;
  }
}

///converts the Either type from and to json for comment children
// TODO change the return type to left failure and right success
class ChildrenConverter implements JsonConverter<Either<int, Unit>, Object> {
  const ChildrenConverter();

  @override

  ///get children property from json
  ///api returns number of children,
  ///but if its 0 we want to have an Unit in the Either
  ///
  /// throws [UnexpectedTypeError] if the type isn`t an integer
  // TODO problematic in many ways. Since json is normally of tpye Map<String, dynamic> this would always fail or at least in the raw form it's a string and Object as input is a little bit wide spread. And also the problem of json decoding must be handled (like in the other cases mentioned earlier i.e. /infrastructure/event/event_remote_service.dart)
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
    // TODO: implement toJson (can't be handled here -> see problem above)
    throw UnimplementedError();
  }
}

///converts the Either type from and to json for comment parent
// TODO change the return type to left failure and right success
class ParentConverter
    implements JsonConverter<Either<CommentDto, Unit>, Object> {
  const ParentConverter();

  @override
  //calls parent factory if an parent id is included in the api request
  //if not it reurns the unit type
  // TODO same problem as in ChildConverter
  Either<CommentDto, Unit> fromJson(Object json) {
    if (json is String) {
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
