import 'package:flutter_frontend/domain/comment/comment.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/post/post.dart';
import 'package:flutter_frontend/domain/profile/base_profile.dart';
import 'package:flutter_frontend/domain/profile/value_objects.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'full_profile.freezed.dart';

@freezed
abstract class FullProfile extends BaseProfile with _$FullProfile {
  const factory FullProfile({
    @required int id,
    @required ProfileName name,
    @required List<UsrEvntStats> userEventStatus,
    @required List<Event> ownedEvents,
    @required List<Invitation> invitations,
    @required List<Friendship> friendships,
    @required List<Friendship2> friendships2,
    @required List<Post> posts,
    @required List<Comment> comments,
  }) = _FullProfile;
}
