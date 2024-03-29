import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/post/post.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';

// TODO rename this one since it's duplicated in domain/event/i_event_repository.dart -> really confusing
/// For dertermination of the List to load
/// for example for showing created posts or feed
enum Operation {
  search,
  attendingUsersEvent,
  follower,
  postProfile,
  friends,
  pendingFriends
}

abstract class IProfileRepository {
  Future<Either<NetWorkFailure, List<Profile>>> getList(
      Operation operation, int amount,
      {Post post, Profile profile, Event event});
  Future<Either<NetWorkFailure, Profile>> getSingleProfile(
      UniqueId id); // todo profile object instead of id
  Future<Either<NetWorkFailure, Profile>> create(Profile profile);
  Future<Either<NetWorkFailure, Profile>> update(Profile profile);
  Future<Either<NetWorkFailure, Profile>> delete(Profile profile);
}
