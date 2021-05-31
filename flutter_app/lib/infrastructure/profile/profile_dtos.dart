import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_frontend/infrastructure/core/base_dto.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/domain/profile/value_objects.dart';
import 'package:flutter_frontend/infrastructure/event/event_dtos.dart';
import 'package:flutter_frontend/infrastructure/post/comment_dtos.dart';
import 'package:flutter_frontend/infrastructure/post/post_dtos.dart';


part 'profile_dtos.freezed.dart';

part 'profile_dtos.g.dart';

@freezed
class ProfileDto extends BaseDto with _$ProfileDto {
  const ProfileDto._();
  

  const factory ProfileDto({
    required String id,
    required String username,
    List<EventDto>? ownedEvents,
    List<EventDto>? invitations,
    List<ProfileDto>? friendships,
    List<PostDto>? posts,
    List<CommentDto>? comments,
  }) = _ProfileDto;

  factory ProfileDto.fromDomain(Profile profile) {
    return profile.map(
        (value) => ProfileDto(
              id: profile.id.getOrCrash(),
          username: profile.name.getOrCrash(),
            ),
        full: (detailedProfile) => ProfileDto(
            id: detailedProfile.id.getOrCrash(),
            username: detailedProfile.name.getOrCrash(),
            ownedEvents: detailedProfile.ownedEvents
                .map((e) => EventDto.fromDomain(e))
                .toList(),
            invitations: detailedProfile.invitations
                .map((e) => EventDto.fromDomain(e))
                .toList(),
            friendships: detailedProfile.friendships
                .map((e) => ProfileDto.fromDomain(e))
                .toList(),
            posts: detailedProfile.posts
                .map((e) => PostDto.fromDomain(e))
                .toList(),
            comments: detailedProfile.comments
                .map((e) => CommentDto.fromDomain(e))
                .toList()));
  }

  factory ProfileDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileDtoFromJson(json);


  @override
  Profile toDomain() {
    if(posts == null) {
      return Profile(
          id: UniqueId.fromUniqueString(id), name: ProfileName(username));
    }
    else{
      return Profile.full(
          id: UniqueId.fromUniqueString(id),
          name: ProfileName(username),
          ownedEvents: ownedEvents!
              .map((e) => e.toDomain())
              .toList(),
          invitations: invitations!
              .map((e) => e.toDomain())
              .toList(),
          friendships: friendships!
              .map((e) => e.toDomain())
              .toList(),
          posts: posts!.map((e) => e.toDomain()).toList(),
          comments:
          comments!.map((e) => e.toDomain()).toList());
    }

  }
}
