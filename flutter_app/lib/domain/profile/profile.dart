import 'package:dartz/dartz.dart';

import 'package:flutter_frontend/domain/post/comment.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/post/post.dart';
import 'package:flutter_frontend/domain/profile/value_objects.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';

@freezed
abstract class Profile implements _$Profile {
  const Profile._();

  const factory Profile({
    @required int id,
    @required ProfileName name,
  }) = _BaseProfile;

  const factory Profile.full({
    @required int id,
    @required ProfileName name,
    @required List<UsrEvntStats> userEventStatus,
    @required List<Event> ownedEvents,
    @required List<Invitation> invitations,
    @required List<Friendship> friendships,
    @required List<Friendship2> friendships2,
    @required List<Profile> posts,
    @required List<Comment> comments,
  }) = _FullProfile;

  //check if the whole object is no failure
  // TODO same problem as in all other data classes before. Use the methods of value objects. And this seems to be a pretty repetitive task --> implement a super class!
  Option<ValueFailure<dynamic>> get failureOption {
    return name.failureOrUnit.fold((f) => some(f), (_) => none());
  }
}
