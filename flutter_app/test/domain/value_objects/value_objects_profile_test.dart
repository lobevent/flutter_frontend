import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/post/comment.dart';
import 'package:flutter_frontend/domain/profile/value_objects.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/domain/profile/profile_failure.dart';
import 'package:flutter_frontend/domain/profile/i_profile_repository.dart';
import 'package:mockito/mockito.dart';

class MockProfile extends Mock implements Profile {
  @override
  // TODO: implement copyWith
  $ProfileCopyWith<Profile> get copyWith => throw UnimplementedError();

  @override
  // TODO: implement failureOption
  Option<ValueFailure> get failureOption => throw UnimplementedError();

  @override
  // TODO: implement id
  Id get id => throw UnimplementedError();

  @override
  Result map<Result extends Object>(Result Function(value) $default, {Result Function(value) full}) {
    // TODO: implement map
    throw UnimplementedError();
  }

  @override
  Result maybeMap<Result extends Object>(Result Function(value) $default, {Result Function(value) full, Result Function() orElse}) {
    // TODO: implement maybeMap
    throw UnimplementedError();
  }

  @override
  Result maybeWhen<Result extends Object>(Result Function(Id id, ProfileName name) $default, {Result Function(Id id, ProfileName name, List<Event> ownedEvents, List<Invitation> invitations, List<Friendship> friendships, List<Friendship2> friendships2, List<Profile> posts, List<Comment> comments) full, Result Function() orElse}) {
    // TODO: implement maybeWhen
    throw UnimplementedError();
  }

  @override
  // TODO: implement name
  ProfileName get name => throw UnimplementedError();

  @override
  Result when<Result extends Object>(Result Function(Id id, ProfileName name) $default, {Result Function(Id id, ProfileName name, List<Event> ownedEvents, List<Invitation> invitations, List<Friendship> friendships, List<Friendship2> friendships2, List<Profile> posts, List<Comment> comments) full}) {
    // TODO: implement when
    throw UnimplementedError();
  }
}


main() {
  //Profile profile = Profile(id: 1, name: ProfileName("guenther hermann"));
}
