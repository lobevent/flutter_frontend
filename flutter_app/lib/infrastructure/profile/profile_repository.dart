import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/post/post.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/profile/i_profile_repository.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/domain/profile/profile_failure.dart';
import 'package:flutter_frontend/infrastructure/core/exceptions.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_dtos.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_remote_service.dart';

class ProfileRepository extends IProfileRepository {
  final ProfileRemoteService _profileRemoteService;

  ProfileRepository(this._profileRemoteService);

  @override
  Future<Either<ProfileFailure, Profile>> create(Profile profile) async {
    try {
      final profileDto = ProfileDto.fromDomain(profile);
      ProfileDto returnedProfileDto =
          await _profileRemoteService.create(profileDto);
      return right(returnedProfileDto.toDomain());
    } on CommunicationException catch (e) {
      return left(_reactOnCommunicationException(e));
    }
  }

  @override
  Future<Either<ProfileFailure, Profile>> delete(Profile profile) async {
    try {
      final profileDto = ProfileDto.fromDomain(profile);
      ProfileDto returnedProfileDto =
          await _profileRemoteService.delete(profileDto);
      return right(returnedProfileDto.toDomain());
    } on CommunicationException catch (e) {
      return left(_reactOnCommunicationException(e));
    }
  }

  @override
  Future<Either<ProfileFailure, List<Profile>>> getList(
          Operation operation, int amount,{Post post, Profile profile, Event event}) async {
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  Future<Either<ProfileFailure, Profile>> getSingleProfile(Id id) async {
    // TODO: implement getSingleProfile
    throw UnimplementedError();
  }

  @override
  Future<Either<ProfileFailure, Profile>> update(Profile profile) async {
    try {
      final profileDto = ProfileDto.fromDomain(profile);
      ProfileDto returnedpProfileDto;
      returnedpProfileDto = await _profileRemoteService.update(profileDto);
      return right(returnedpProfileDto.toDomain());
    } on CommunicationException catch (e) {
      return left(_reactOnCommunicationException(e));
    }
  }

  ProfileFailure _reactOnCommunicationException(CommunicationException e) {
    switch (e.runtimeType) {
      case NotFoundException:
        return const ProfileFailure.notFound();
        break;
      case InternalServerException:
        return const ProfileFailure.internalServer();
        break;
      case NotAuthenticatedException:
        return const ProfileFailure.notAuthenticated();
        break;
      case NotAuthorizedException:
        return const ProfileFailure.insufficientPermissions();
        break;
      case UnexpectedFormatException:
        return const ProfileFailure.unexpected();
      default:
        return const ProfileFailure.unexpected();
        break;
    }
  }
}
