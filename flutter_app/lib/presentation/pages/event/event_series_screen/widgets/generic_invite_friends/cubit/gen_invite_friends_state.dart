part of 'gen_invite_friends_cubit.dart';

enum GenInviteFriendsStatus { loading, loaded, refresh, error }

@CopyWith()
class GenInviteFriendsState<T> {
  final List<T> genericInvs;
  final List<Profile> friends;
  final GenInviteFriendsStatus status;
  final NetWorkFailure? failure;

  factory GenInviteFriendsState.loading() => GenInviteFriendsState<T>(
      status: GenInviteFriendsStatus.loading, genericInvs: []);

  factory GenInviteFriendsState.loaded(
          {required List<Profile> friends, required List<T> genericInvs}) =>
      GenInviteFriendsState<T>(
          status: GenInviteFriendsStatus.loaded,
          friends: friends,
          genericInvs: genericInvs);

  factory GenInviteFriendsState.refresh(
          {required List<Profile> friends, required List<T> genericInvs}) =>
      GenInviteFriendsState<T>(
          status: GenInviteFriendsStatus.refresh,
          friends: friends,
          genericInvs: genericInvs);

  GenInviteFriendsState({
    this.friends = const [],
    required this.genericInvs,
    required this.status,
    this.failure,
  }) {}
}
