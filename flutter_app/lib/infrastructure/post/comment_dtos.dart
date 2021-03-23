import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
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
    @ParentConverter() required Option<CommentDto> commentParent,
    required int post,
    @ChildrenConverter() required Option<int> commentChildren,
  }) = _CommentDto;


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
    CommentDto? returnedDto;
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
                commentParent: comment.commentParent.fold((l) => some(CommentDto.fromDomain(l)), (r) => none()),
                commentChildren: none(), //TODO: I dont know if this is important, but its worth a second look
                //leave out children, as they arent used in to Api communication
              ),
            },
        parent: (CommentParent comment) => {
              //the parent case
              returnedDto = CommentDto.parent(id: comment.id.getOrCrash()),
            },
        orElse: () {});

    return returnedDto!;
  }

  factory CommentDto.fromJson(Map<String, dynamic> json) =>
      _$CommentDtoFromJson(json);

  /// Generate dto from domain, respecting the different union cases
  /// Map comment to parent or to full and generate the entity respectively
  // TODO this function does something really really strange! The syntax is a little bit mixed up but also it does not what it should
  @override
  Comment toDomain() {
    Comment? returnedComment;
    map(
        (_CommentDto value) => {
              returnedComment = Comment(
                id: UniqueId.fromUniqueString(value.id),
                creationDate: value.creationDate,
                commentContent: CommentContent(value.commentContent),
                owner: value.profile.toDomain(),
                commentChildren: value.commentChildren.fold(() => Comment.childLess(), (a) => Comment.childCount(count: a)),
                    //left(left()) because of the complex Either type
                    //where the list isn`t used here yet
                    // .fold((l) => Comment.childCount(count: value.commentChildren.fold((l) => l, (r) => 0)),
                    //     (r) => const Comment.childLess()),
                post: value.post,
                commentParent: value.commentParent.fold(() => right(unit), (a) => left(Comment.parent(id: UniqueId.fromUniqueString((a as _CommentParentDto).id))))
                    // .fold(
                    //     (l) => left(Comment.parent(id: Id.fromUnique((l as _CommentParentDto).id))),
                    //     (r) => right(unit)),
              )
            }, parent: (_CommentParentDto value) {
      returnedComment = Comment.parent(id: UniqueId.fromUniqueString(value.id));
    }, children: (_CommentChildrenDto value) {
      returnedComment = Comment.children(
          count: value.count,
          commentChildren: value.children
              .map((commentDto) => commentDto.toDomain())
              .toList());
    });
    return returnedComment!;
  }
}

///converts the Either type from and to json for comment children
// TODO change the return type to left failure and right success
class ChildrenConverter implements JsonConverter<Option<int>, Object> {
  const ChildrenConverter();

  @override

  ///get children property from json
  ///api returns number of children,
  ///but if its 0 we want to have an Unit in the Either
  ///
  /// throws [UnexpectedTypeError] if the type isn`t an integer
  // TODO problematic in many ways. Since json is normally of tpye Map<String, dynamic> this would always fail or at least in the raw form it's a string and Object as input is a little bit wide spread. And also the problem of json decoding must be handled (like in the other cases mentioned earlier i.e. /infrastructure/event/event_remote_service.dart)
  Option<int> fromJson(Object json) {
    if (json is int && json > 0) {
      return some(json);
    } else if (json == 0) {
      return none();
    }
    throw UnexpectedTypeError();
  }

  @override

  ///dont need that, as the api does not accept children
  Object toJson(Option<int> object) {
    // TODO: implement toJson (can't be handled here -> see problem above)
    throw UnimplementedError();
  }
}

///converts the Either type from and to json for comment parent
// TODO change the return type to left failure and right success
class ParentConverter
    implements JsonConverter<Option<CommentDto>, Object> {
  const ParentConverter();

  @override
  //calls parent factory if an parent id is included in the api request
  //if not it reurns the unit type
  // TODO same problem as in ChildConverter
  Option<CommentDto> fromJson(Object json) {
    if (json is String) {
      return some(CommentDto.parent(id: json));
    } else if (json == null) {
      return none();
    }
    throw UnexpectedTypeError();
  }

  //converts parent unit type to null if no id is given
  @override
  Object toJson(Option<CommentDto> object) {
    return object.fold(() => "", (a) => a);
  }
}
