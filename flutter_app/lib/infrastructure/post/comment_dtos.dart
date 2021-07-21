import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_frontend/infrastructure/core/json_converters.dart';
import 'package:flutter_frontend/infrastructure/post/post_dtos.dart';
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


  const factory CommentDto({
    String? id,
    required String content,
    required DateTime date,
    int? children,
    @ProfileConverter() required ProfileDto profile, //TODO: make it an integer
    @CommentConverter() CommentDto? commentParent,
    @PostConverter() required PostDto post,
    @CommentsConverter() List<CommentDto>? comments,
  }) = _CommentDto;


  factory CommentDto.fromDomain(Comment comment){
    return CommentDto(content: comment.commentContent.getOrCrash(), date: comment.creationDate, profile: ProfileDto.fromDomain(comment.owner), post: PostDto.fromDomain(comment.post));
  }

  factory CommentDto.fromJson(Map<String, dynamic> json) =>
      _$CommentDtoFromJson(json);

  /// Generate dto from domain, respecting the different union cases
  @override
  Comment toDomain(){
    return Comment(id: UniqueId.fromUniqueString(this.id!), creationDate: date, commentContent: CommentContent(content), owner: profile.toDomain(), post: post.toDomain(), commentParent: commentParent?.toDomain(), childCount: children);
  }



}
