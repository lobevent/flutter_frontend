part of 'add_friends_cubit.dart';

@freezed
class AddFriendsState with _$AddFriendsState{

  const factory AddFriendsState.loadingFriends() = LoadingFriends;
  const factory AddFriendsState.loadedFriends({ required List<Profile> friends}) = LoadedFriends;
  const factory AddFriendsState.error({required NetWorkFailure failure}) = _LoadFailure;
}

