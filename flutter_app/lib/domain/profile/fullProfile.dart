import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/profile/baseProfile.dart';
import 'package:flutter_frontend/domain/profile/value_objects.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fullProfile.freezed.dart';

@freezed
abstract class FullProfile extends BaseProfile with _$FullProfile {
  const factory FullProfile({
    @override @required int id,
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
