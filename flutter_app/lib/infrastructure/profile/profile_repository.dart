import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/errors.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/post/post.dart';
import 'package:flutter_frontend/domain/profile/i_profile_repository.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/infrastructure/core/exceptions.dart';
import 'package:flutter_frontend/infrastructure/core/exceptions_handler.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_dtos.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_remote_service.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/cubit/like/like_cubit.dart';
import 'package:flutter_frontend/domain/core/repository.dart';
import 'package:image_picker/image_picker.dart';

import 'achievements_dtos.dart';

class ProfileRepository extends Repository {
  final ProfileRemoteService _profileRemoteService;

  ProfileRepository(this._profileRemoteService);

  // ---------------------------------- Image Crud ------------------------------------------

  Future<Either<NetWorkFailure, String>> uploadImages(
      UniqueId postId, XFile image) async {
    return localErrorHandler(() async {
      return right(await _profileRemoteService.uploadImageToEvent(
          postId.value, File(image.path)));
    });
  }

  //---------------------------Simple CRUD-----------------------------
  ///
  /// Creates a profile in the backend or returns failure
  ///
  @override
  Future<Either<NetWorkFailure, Profile>> create(Profile profile) async {
    return localErrorHandler(() async {
      final profileDto = ProfileDto.fromDomain(profile);
      ProfileDto returnedProfileDto =
          await _profileRemoteService.create(profileDto);
      return right(returnedProfileDto.toDomain());
    });
  }

  ///
  /// deletes a profile in the backend or returns failure
  ///
  @override
  Future<Either<NetWorkFailure, Profile>> delete(Profile profile) async {
    return localErrorHandler(() async {
      final profileDto = ProfileDto.fromDomain(profile);
      ProfileDto returnedProfileDto =
          await _profileRemoteService.delete(profileDto);
      return right(returnedProfileDto.toDomain());
    });
  }

  ///
  /// gets a single profile in the backend or returns failure
  ///
  @override
  Future<Either<NetWorkFailure, Profile>> getSingleProfile(UniqueId id) async {
    return localErrorHandler(() async {
      final ProfileDto profileDto =
          await _profileRemoteService.getSingleProfile(id.value);
      final Profile profile = profileDto.toDomain();
      return right(profile);
    });
  }

  ///
  /// updates a profile in the backend or returns failure
  ///
  @override
  Future<Either<NetWorkFailure, Profile>> update(Profile profile) async {
    return localErrorHandler(() async {
      final profileDto = ProfileDto.fromDomain(profile);
      ProfileDto returnedpProfileDto;
      returnedpProfileDto = await _profileRemoteService.update(profileDto);
      return right(returnedpProfileDto.toDomain());
    });
  }

  //-------------------List Getters--------------------------

  ///
  /// gets the profiles found by the searchstring
  ///
  Future<Either<NetWorkFailure, List<Profile>>> getSearchProfiles(
      {required String searchString, required int amount}) {
    return localErrorHandler(() async {
      final List<ProfileDto> searchProfiles =
          await _profileRemoteService.getSearchedProfiles(amount, searchString);
      var x = right(_convertToDomainList(searchProfiles));
      return right(_convertToDomainList(searchProfiles));
    });
  }

  ///
  /// gets the profiles atten
  ///
  Future<Either<NetWorkFailure, List<Profile>>> getAttendingProfiles(
      {required int amount, required Event event}) async {
    return localErrorHandler(() async {
      final List<ProfileDto> profileDtos = await _profileRemoteService
          .getAttendingUsersToEvent(amount, event.id.value.toString());
      return right(_convertToDomainList(profileDtos));
    });
  }

  ///
  /// gets the follower
  ///
  Future<Either<NetWorkFailure, List<Profile>>> getFollower(
      {required int amount, required Profile profile}) async {
    return localErrorHandler(() async {
      final List<ProfileDto> profileDtos = await _profileRemoteService
          .getFollower(amount, profile.id.value.toString());
      return right(_convertToDomainList(profileDtos));
    });
  }

  ///
  /// gets the friends
  ///
  Future<Either<NetWorkFailure, List<Profile>>> getFriends(
      {Profile? profile}) async {
    return localErrorHandler(() async {
      final List<ProfileDto> profileDtos = await _profileRemoteService
          .getAcceptedFriendships(profile?.id.value.toString());
      return right(_convertToDomainList(profileDtos));
    });
  }

  ///
  /// gets the open friend requests
  ///
  Future<Either<NetWorkFailure, List<Profile>>> getOpenFriends() async {
    return localErrorHandler(() async {
      final List<ProfileDto> profileDtos =
          await _profileRemoteService.getOpenFriendRequests();
      return right(_convertToDomainList(profileDtos));
    });
  }

  ///
  /// gets the profiles of post
  ///
  Future<Either<NetWorkFailure, List<Profile>>> getProfilesToPost(
      {required int amount, required Profile profile}) async {
    return localErrorHandler(() async {
      final List<ProfileDto> profileDtos = await _profileRemoteService
          .getProfilesToPost(amount, profile.id.value.toString());
      return right(_convertToDomainList(profileDtos));
    });
  }

  ///Friendship functionalities (maybe do them in seperate repository
  Future<Either<NetWorkFailure, String>> sendFriendRequest(UniqueId id) async {
    return localErrorHandler(() async {
      final success = await _profileRemoteService.sendFriendship(id.value);
      return right(success);
    });
  }

  Future<Either<NetWorkFailure, bool>> acceptFriend(UniqueId id) async {
    return localErrorHandler(() async {
      final bool success =
          await _profileRemoteService.acceptFriendRequest(id.value);
      return right(success);
    });
  }

  Future<Either<NetWorkFailure, bool>> deleteFriend(UniqueId id) async {
    return localErrorHandler(() async {
      final bool success =
          await _profileRemoteService.deleteFriendRequest(id.value);
      return right(success);
    });
  }

  ///Like functionalities
  //TODO: make this to show backend errors ...
  Future<Either<NetWorkFailure, bool>> like(
      UniqueId objectId, LikeTypeOption option) async {
    return localErrorHandler(() async {
      final bool success =
          await _profileRemoteService.like(objectId.value, option);
      return right(success);
    });
  }

  Future<Either<NetWorkFailure, bool>> unlike(
      UniqueId objectId, LikeTypeOption option) async {
    return localErrorHandler(() async {
      final bool success =
          await _profileRemoteService.unlike(objectId.value, option);
      return right(success);
    });
  }

  Future<Either<NetWorkFailure, bool>> checkLikeStatus(
      UniqueId objectId) async {
    return localErrorHandler(() async {
      final bool success =
          await _profileRemoteService.getOwnLikeStatus(objectId.value);
      return right(success);
    });
  }

  Future<Either<NetWorkFailure, List<Profile>>> addFriendsToEvent(
      List<Profile> profiles, Event event) async {
    return localErrorHandler(() async {
      final profileDtos =
          profiles.map((e) => ProfileDto.fromDomain(e)).toList();
      final List<Profile> profilesResp =
          (await _profileRemoteService.addFriendsToEvent(profileDtos, event))
              .map((e) => e.toDomain())
              .toList();
      return right(profilesResp);
    });
  }

  ///
  /// converts to domain list
  ///
  List<Profile> _convertToDomainList(List<ProfileDto> dtos) {
    return dtos.map((profileDto) => profileDto.toDomain()).toList();
  }

  Future<Either<NetWorkFailure, Profile>> getOwnProfile() async {
    return localErrorHandler(() async {
      final ProfileDto profileDto = await _profileRemoteService.getOwnProfile();
      final Profile profile = profileDto.toDomain();
      return right(profile);
    });
  }

  Future<Either<NetWorkFailure, String>> getScore(String profileId) async {
    return localErrorHandler(() async {
      final resp = await _profileRemoteService.getProfileScore(profileId);
      return right(utf8.decode(resp.bodyBytes));
    });
  }

  Future<Either<NetWorkFailure, AchievementsDto>> getAchievements(
      String profileId) async {
    return localErrorHandler(() async {
      final AchievementsDto achievements =
          await _profileRemoteService.getAchievements(profileId);
      return right(achievements);
    });
  }
}
