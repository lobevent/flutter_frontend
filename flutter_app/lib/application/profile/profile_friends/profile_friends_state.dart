part of 'profile_friends_cubit.dart';

@freezed
class ProfileFriendsState with _$ProfileFriendsState {
  const factory ProfileFriendsState({required List<Profile> friendList}) =
      _ProfileFriendsState;

  factory ProfileFriendsState.initial() = _Initial;

  factory ProfileFriendsState.loading() = _LoadInProgress;

  factory ProfileFriendsState.loaded({required List<Profile> friendList}) =
      _Loaded;

  factory ProfileFriendsState.error({required String error}) = _LoadFailure;

  factory ProfileFriendsState.deleted({required Profile profile}) =
      _deletedFriend;
}
