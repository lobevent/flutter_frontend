import 'dart:core';

import 'package:flutter_frontend/infrastructure/core/base_dto.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/post/comment.dart';
import 'package:flutter_frontend/domain/post/value_objects.dart';
import 'package:flutter_frontend/infrastructure/event/event_dtos.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_dtos.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_frontend/domain/post/post.dart';
import 'package:flutter/cupertino.dart';

part 'post_dtos.freezed.dart';
part 'post_dtos.g.dart';

@freezed
class PostDto extends BaseDto with _$PostDto {
  const PostDto._();

  const factory PostDto({
    String? id,
    required DateTime date,
    required String content,
    @ProfileConverter()  ProfileDto? owner,
    @EventConverter() EventDto? event,
  }) = _PostDto;


  factory PostDto.fromDomain(Post post) {
    PostDto returnedDto;
    //distinguish between both PostDto cases
    return post.map(
        (value) => PostDto(
              id: value.id.getOrCrash(),
              date: value.creationDate,
              content: value.postContent.getOrCrash(),
              owner: ProfileDto.fromDomain(value.owner!),
              event: EventDto.fromDomain(value.event!),
            ),
        WithoutId: (value) => PostDto(
            date: value.creationDate,
            content: value.postContent.getOrCrash(),
            owner: ProfileDto.fromDomain(value.owner!),
            event: EventDto.fromDomain(value.event!)));
  }

  factory PostDto.fromJson(Map<String, dynamic> json) =>
      _$PostDtoFromJson(json);

  @override
  Post toDomain() {
    if(id != null) {
      return Post(
          id: UniqueId.fromUniqueString(id!),
          creationDate: date,
          postContent: PostContent(content),
          owner: owner?.toDomain(),
          event: event?.toDomain(),
          comments: <Comment>[]);
    }
      return Post.WithoutId(
            creationDate: date,
            postContent: PostContent(content),
            owner: owner?.toDomain(),
            event: event?.toDomain(),
            comments: <Comment>[]);
  }
}

class ProfileConverter
    implements JsonConverter<ProfileDto, Map<String, dynamic>> {
  const ProfileConverter();
  @override
  ProfileDto fromJson(Map<String, dynamic> owner) {
    return ProfileDto.fromJson(owner);
  }

  @override
  Map<String, dynamic> toJson(ProfileDto profileDto) {
    return profileDto.toJson();
  }
}

class EventConverter implements JsonConverter<EventDto, Map<String, dynamic>> {
  const EventConverter();
  @override
  EventDto fromJson(Map<String, dynamic> event) {
    return EventDto.fromJson(event);
  }

  @override
  Map<String, dynamic> toJson(EventDto EventDto) {
    return EventDto.toJson();
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
