import 'dart:html';

import 'package:flutter_frontend/domain/post/post.dart';
import 'package:flutter_frontend/domain/profile/value_objects.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';

@freezed
abstract class Profile with _$Profile {
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
    @required List<Post> posts,
    @required List<Comment> comments,
  }) = _FulllProfile;
}
