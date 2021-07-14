part of 'profile_friends_cubit.dart';

@freezed
class ProfileFriendsState with _$ProfileFriendsState {
  const factory ProfileFriendsState(
      {required List<Profile> friendList,
      required List<Profile> pendingFriendsList}) = _ProfileFriendsState;

  factory ProfileFriendsState.initial() = _Initial;

  factory ProfileFriendsState.loading() = _LoadInProgress;

  factory ProfileFriendsState.loadedBoth(
      {required List<Profile> friendList,
      required List<Profile> pendingFriendsList}) = _LoadedBoth;

  factory ProfileFriendsState.loaded({required List<Profile> friendList}) =
      _Loaded;

  factory ProfileFriendsState.error({required String error}) = _LoadFailure;

  factory ProfileFriendsState.deleted({required Profile profile}) =
      _deletedFriend;
}
