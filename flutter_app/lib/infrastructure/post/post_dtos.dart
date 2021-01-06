import 'dart:core';

import 'package:flutter_frontend/infrastructure/core/base_dto.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/post/comment.dart';
import 'package:flutter_frontend/domain/post/value_objects.dart';
import 'package:flutter_frontend/infrastructure/core/event_converter.dart';
import 'package:flutter_frontend/infrastructure/core/json_converters.dart';
import 'package:flutter_frontend/infrastructure/event/event_dtos.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_dtos.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_frontend/domain/post/post.dart';
import 'package:flutter/cupertino.dart';

part 'post_dtos.freezed.dart';
part 'post_dtos.g.dart';

@freezed
abstract class PostDto extends BaseDto implements _$PostDto {
  const PostDto._();

  const factory PostDto({
    @required int id,
    @required DateTime creationDate,
    @required String postContent,
    @required @ProfileConverter() ProfileDto owner,
    @required @EventConverter() EventDto event,
  }) = _PostDto;

  const factory PostDto.WithoutId({
    @required DateTime creationDate,
    @required String postContent,
    @required @ProfileConverter() ProfileDto owner,
    @required @EventConverter() EventDto event,
  }) = _PostDtoWithoutId;

  factory PostDto.fromDomain(Post post) {
    PostDto returnedDto;
    //distinguish between both PostDto cases
    return post.map(
        (value) => PostDto(
              id: value.id.getOrCrash(),
              creationDate: value.creationDate,
              postContent: value.postContent.getOrCrash(),
              owner: ProfileDto.fromDomain(post.owner),
              event: EventDto.fromDomain(post.event),
            ),
        WithoutId: (value) => PostDto.WithoutId(
            creationDate: value.creationDate,
            postContent: value.postContent.getOrCrash(),
            owner: ProfileDto.fromDomain(value.owner),
            event: EventDto.fromDomain(value.event)));
  }

  factory PostDto.fromJson(Map<String, dynamic> json) =>
      _$PostDtoFromJson(json);

  @override
  Post toDomain() {
    return map(
        (value) => Post(
            id: Id.fromUnique(value.id),
            creationDate: value.creationDate,
            postContent: PostContent(value.postContent),
            owner: value.owner.toDomain(),
            event: value.event.toDomain(),
            comments: <Comment>[]),
        WithoutId: (value) => Post.WithoutId(
            creationDate: value.creationDate,
            postContent: PostContent(value.postContent),
            owner: value.owner.toDomain(),
            event: value.event.toDomain(),
            comments: <Comment>[]));
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
