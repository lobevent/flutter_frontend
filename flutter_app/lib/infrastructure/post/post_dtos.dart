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
abstract class PostDto implements _$PostDto {
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
    return PostDto(
      id: post.id.getOrCrash(),
      creationDate: post.creationDate,
      postContent: post.postContent.getOrCrash(),
      owner: ProfileDto.fromDomain(post.owner),
      event: EventDto.fromDomain(post.event),
    );
  }

  factory PostDto.fromJson(Map<String, dynamic> json) =>
      _$PostDtoFromJson(json);

  Post toDomain() {
    return Post(
        id: Id.fromUnique(id),
        creationDate: creationDate,
        postContent: PostContent(postContent),
        owner: owner.toDomain(),
        event: event.toDomain(),
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
