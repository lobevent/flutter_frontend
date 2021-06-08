import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/post/post.dart';

import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/domain/profile/profile_failure.dart';

// TODO rename this one since it's duplicated in domain/event/i_event_repository.dart -> really confusing
/// For dertermination of the List to load
/// for example for showing created posts or feed
enum Operation{
  search,
  attendingUsersEvent,
  follower,
  postProfile,
}

abstract class IProfileRepository{
  Future <Either<ProfileFailure, List<Profile>>> getList(
      Operation operation, int amount,{ Post post, Profile profile, Event event});
  Future <Either<ProfileFailure, Profile>> getSingleProfile(UniqueId id); // todo profile object instead of id
  Future <Either<ProfileFailure, Profile>> create(Profile profile);
  Future <Either<ProfileFailure, Profile>> update(Profile profile);
  Future <Either<ProfileFailure, Profile>> delete(Profile profile);
}