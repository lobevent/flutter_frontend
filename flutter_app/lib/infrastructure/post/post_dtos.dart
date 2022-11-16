import 'dart:core';

import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/post/comment.dart';
import 'package:flutter_frontend/domain/post/post.dart';
import 'package:flutter_frontend/domain/post/value_objects.dart';
import 'package:flutter_frontend/infrastructure/core/base_dto.dart';
import 'package:flutter_frontend/infrastructure/core/json_converters.dart';
import 'package:flutter_frontend/infrastructure/event/event_dtos.dart';
import 'package:flutter_frontend/infrastructure/post/comment_dtos.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_dtos.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_dtos.freezed.dart';
part 'post_dtos.g.dart';

@freezed
class PostDto extends BaseDto with _$PostDto {
  const PostDto._();

  const factory PostDto(
      {String? id,
      required DateTime date,
      required String content,
      int? commentCount,
      @CommentsConverter() List<CommentDto>? comments,
      @ProfileConverter() ProfileDto? owner,
      @EventConverter() EventDto? event,
      List<String>? images}) = _PostDto;

  factory PostDto.fromDomain(Post post) {
    PostDto returnedDto;
    //distinguish between both PostDto cases
    return PostDto(
        id: post.id?.value,
        date: post.creationDate,
        content: post.postContent.getOrCrash(),
        owner: post.owner != null ? ProfileDto.fromDomain(post.owner!) : null,
        event: post.event != null ? EventDto.fromDomain(post.event!) : null,
        comments: <CommentDto>[],
        images: post.images,
        commentCount: post.commentCount);
  }

  factory PostDto.fromJson(Map<String, dynamic> json) =>
      _$PostDtoFromJson(json);

  @override
  Post toDomain() {
    return Post(
        id: UniqueId.fromUniqueString(id!),
        creationDate: date.toLocal(),
        postContent: PostContent(content),
        owner: owner?.toDomain(),
        event: event?.toDomain(),
        comments: <Comment>[],
        images: images,
        commentCount: commentCount);
  }
}

/*
  Post toDomain(){
  return Post(
    id: id,
    creationDate: DateTime ,
    postContent: PostContent(),
    owner: Profile(owner),
    event: Event(event),

  )

   */
