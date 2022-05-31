import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/domain/profile/value_objects.dart';
import 'package:flutter_frontend/infrastructure/core/base_dto.dart';
import 'package:flutter_frontend/infrastructure/event/event_dtos.dart';
import 'package:flutter_frontend/infrastructure/post/comment_dtos.dart';
import 'package:flutter_frontend/infrastructure/post/post_dtos.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

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
    int? friendshipCount,
    List<PostDto>? posts,
    List<CommentDto>? comments,
    List<String>? images,
    required bool ownProfile
  }) = _ProfileDto;

  factory ProfileDto.fromDomain(Profile profile) {
    return profile.map(
        (value) => ProfileDto(
              id: profile.id.value,
              username: profile.name.getOrCrash(),
              ownProfile: value.ownProfile
            ),
        full: (detailedProfile) => ProfileDto(
            id: detailedProfile.id.value,
            ownProfile: detailedProfile.ownProfile,
            username: detailedProfile.name.getOrCrash(),
            ownedEvents: detailedProfile.ownedEvents != null
                ? detailedProfile.ownedEvents!
                    .map((e) => EventDto.fromDomain(e))
                    .toList()
                : null,
            invitations: detailedProfile.invitations != null
                ? detailedProfile.invitations!
                    .map((e) => EventDto.fromDomain(e))
                    .toList()
                : null,
            friendshipCount: detailedProfile.friendshipCount,
            posts: detailedProfile.posts != null
                ? detailedProfile.posts!
                    .map((e) => PostDto.fromDomain(e))
                    .toList()
                : null,
            comments: detailedProfile.comments != null
                ? detailedProfile.comments!
                    .map((e) => CommentDto.fromDomain(e))
                    .toList()
                : null,
          images: profile.images,));
  }

  factory ProfileDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileDtoFromJson(json);

  @override
  Profile toDomain() {
    if (posts == null) {
      return Profile(
          ownProfile: ownProfile,
          id: UniqueId.fromUniqueString(id), name: ProfileName(username),
          // that is done, so we dont have empty arrays as images (so there is no need for index checks!)
          images: images != null && images!.length == 0 ? null : images);
    } else {
      return Profile.full(
          ownProfile: ownProfile,
          id: UniqueId.fromUniqueString(id),
          name: ProfileName(username),
          ownedEvents: ownedEvents != null
              ? ownedEvents!.map((e) => e.toDomain()).toList()
              : null,
          invitations: invitations != null
              ? invitations!.map((e) => e.toDomain()).toList()
              : null,
          friendshipCount: friendshipCount,
          posts:
              posts != null ? posts!.map((e) => e.toDomain()).toList() : null,
          comments: comments != null
              ? comments!.map((e) => e.toDomain()).toList()
              : null,
        images: images);
    }
  }
}
