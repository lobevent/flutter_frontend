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
abstract class ProfileDto extends BaseDto implements _$ProfileDto {
  const ProfileDto._();

  const factory ProfileDto({
    @required String id,
    @required String name,
  }) = _ProfileDto;

  const factory ProfileDto.full({
    @required String id,
    @required String name,
    @required List<EventDto> ownedEvents,
    @required List<EventDto> invitations,
    @required List<ProfileDto> friendships,
    @required List<PostDto> posts,
    @required List<CommentDto> comments,
  }) = _FullProfile;

  factory ProfileDto.fromDomain(Profile profile) {
    return profile.map(
        (value) => ProfileDto(
              id: profile.id.getOrCrash(),
              name: profile.name.getOrCrash(),
            ),
        full: (detailedProfile) => ProfileDto.full(
            id: detailedProfile.id.getOrCrash(),
            name: detailedProfile.name.getOrCrash(),
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
    return map(
        (listViewProfileDto) => Profile(
              id: Id.fromUnique(listViewProfileDto.id),
              name: ProfileName(listViewProfileDto.name),
            ),
        full: (detailedProfileDto) => Profile.full(
            id: Id.fromUnique(detailedProfileDto.id),
            name: new ProfileName(detailedProfileDto.name),
            ownedEvents: detailedProfileDto.ownedEvents
                .map((e) => e.toDomain())
                .toList(),
            invitations: detailedProfileDto.invitations
                .map((e) => e.toDomain())
                .toList(),
            friendships: detailedProfileDto.friendships
                .map((e) => e.toDomain())
                .toList(),
            posts: detailedProfileDto.posts.map((e) => e.toDomain()).toList(),
            comments:
                detailedProfileDto.comments.map((e) => e.toDomain()).toList()));
  }
}
