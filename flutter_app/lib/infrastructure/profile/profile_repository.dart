import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/errors.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event_failure.dart';
import 'package:flutter_frontend/domain/post/post.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/profile/i_profile_repository.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/domain/profile/profile_failure.dart';
import 'package:flutter_frontend/infrastructure/core/exceptions.dart';
import 'package:flutter_frontend/infrastructure/core/exceptions_handler.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_dtos.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_remote_service.dart';

class ProfileRepository extends IProfileRepository {
  final ProfileRemoteService _profileRemoteService;

  ProfileRepository(this._profileRemoteService);

  @override
  Future<Either<NetWorkFailure, Profile>> create(Profile profile) async {
    try {
      final profileDto = ProfileDto.fromDomain(profile);
      ProfileDto returnedProfileDto =
          await _profileRemoteService.create(profileDto);
      return right(returnedProfileDto.toDomain());
    } on CommunicationException catch (e) {
      return left(ExceptionsHandler.reactOnCommunicationException(e));
    }
  }

  @override
  Future<Either<NetWorkFailure, Profile>> delete(Profile profile) async {
    try {
      final profileDto = ProfileDto.fromDomain(profile);
      ProfileDto returnedProfileDto =
          await _profileRemoteService.delete(profileDto);
      return right(returnedProfileDto.toDomain());
    } on CommunicationException catch (e) {
      return left(ExceptionsHandler.reactOnCommunicationException(e));
    }
  }

  @override
  Future<Either<NetWorkFailure, List<Profile>>> getList(
      Operation operation, int amount,
      {Post? post,
      Profile? profile,
      Event? event,
      String? searchString}) async {
    try {
      List<ProfileDto> profileDtos;
      switch (operation) {
        case Operation.search:
          if (searchString == null) {
            throw UnexpectedTypeError();
          }
          profileDtos = await _profileRemoteService.getSearchedProfiles(
              amount, searchString);
          break;
        case Operation.attendingUsersEvent:
          if (profile == null) {
            throw UnexpectedTypeError();
          }
          profileDtos = await _profileRemoteService.getAttendingUsersToEvent(
              amount, profile.id.getOrCrash().toString());
          break;
        case Operation.follower:
          if (profile == null) {
            throw UnexpectedTypeError();
          }
          profileDtos = await _profileRemoteService.getFollower(
              amount, profile.id.getOrCrash().toString());
          break;
        case Operation.friends:
          profileDtos = await _profileRemoteService
              .getAcceptedFriendships(profile?.id.getOrCrash().toString());
          break;
        case Operation.pendingFriends:
          profileDtos = await _profileRemoteService.getOpenFriendRequests();
          break;
        case Operation.postProfile:
          if (post == null || post.id == null) {
            throw UnexpectedTypeError();
          }
          profileDtos = await _profileRemoteService.getProfilesToPost(
              amount,
              post.id!.getOrCrash().toString());
          break;
      }
      //convert the dto objects to domain Objects
      final List<Profile> profiles =
          profileDtos.map((profileDtos) => profileDtos.toDomain()).toList();
      return right(profiles);
    } on CommunicationException catch (e) {
      return left(ExceptionsHandler.reactOnCommunicationException(e));
    }
  }

  @override
  Future<Either<NetWorkFailure, Profile>> getSingleProfile(UniqueId id) async {
    try {
      final ProfileDto profileDto =
          await _profileRemoteService.getSingleProfile(id.getOrCrash());
      final Profile profile = profileDto.toDomain();
      return right(profile);
    } on CommunicationException catch (e) {
      return left(ExceptionsHandler.reactOnCommunicationException(e));
    }
  }

  @override
  Future<Either<NetWorkFailure, Profile>> update(Profile profile) async {
    try {
      final profileDto = ProfileDto.fromDomain(profile);
      ProfileDto returnedpProfileDto;
      returnedpProfileDto = await _profileRemoteService.update(profileDto);
      return right(returnedpProfileDto.toDomain());
    } on CommunicationException catch (e) {
      return left(ExceptionsHandler.reactOnCommunicationException(e));
    }
  }

  ///Friendship functionalities (maybe do them in seperate repository
  Future<String> sendFriendRequest(UniqueId id) async {
    try {
      final success =
          await _profileRemoteService.sendFriendship(id.getOrCrash());
      return success;
    } on CommunicationException catch (e) {
      return e.toString();
    }
  }

  Future<bool> acceptFriend(UniqueId id) async {
    try {
      final bool success =
          (await _profileRemoteService.acceptFriendRequest(id.getOrCrash()));
      return success;
    } on CommunicationException catch (e) {
      return false;
    }
  }

  Future<bool> deleteFriend(UniqueId id) async {
    try {
      final bool success =
          (await _profileRemoteService.deleteFriendRequest(id.getOrCrash()));
      return success;
    } on CommunicationException catch (e) {
      return false;
    }
  }
}
