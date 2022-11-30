part of 'gen_invite_friends_cubit.dart';

enum GenInviteFriendsStatus {loading, loaded, refresh, error}

@CopyWith()
class GenInviteFriendsState{

  final List<Profile> friends;
  final GenInviteFriendsStatus status;
  final NetWorkFailure? failure;

  factory GenInviteFriendsState.loading() => GenInviteFriendsState(
    status: GenInviteFriendsStatus.loading);

  factory GenInviteFriendsState.loaded({required List<Profile> friends}) =>
      GenInviteFriendsState(
    status: GenInviteFriendsStatus.loaded,
    friends: friends);

  GenInviteFriendsState(
  {this.friends = const[],
    required this.status,
  this.failure,}){}
}