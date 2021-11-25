import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/profile/i_profile_repository.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/domain/profile/value_objects.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';

part 'profile_friends_cubit.freezed.dart';
part 'profile_friends_state.dart';

class ProfileFriendsCubit extends Cubit<ProfileFriendsState> {
  final UniqueId? profileId;

  ProfileFriendsCubit(this.profileId) : super(ProfileFriendsState.initial()) {
    emit(ProfileFriendsState.initial());
    getFriends();
  }
  ProfileRepository repository = GetIt.I<ProfileRepository>();

  ///loading the friends and the pending friendrequests
  Future<void> getFriends() async {
    try {
      emit(ProfileFriendsState.loading());

      final Either<NetWorkFailure, List<Profile>> friendList =
          await repository.getFriends(
              // here a fake Profile Object is created, because only profileId is needed and available, but name must be in the Profile Object
              // if no profile id is given "profile" is set to null
              //profile: profileId == null ? null :Profile(name:ProfileName("thisNameIsFake"), id: profileId!)
              profile: profileId == null
                  ? null
                  : Profile(
                      name: ProfileName("thisNameIsFake"), id: profileId!));
      //load the pending friends and mapping
      final Either<NetWorkFailure, List<Profile>> pendingFriendsList =
          await repository.getOpenFriends();
      emit(ProfileFriendsState.loadedBoth(
          friendList: friendList.fold((l) => throw Exception(), (r) => r),
          pendingFriendsList:
              pendingFriendsList.fold((l) => throw Exception(), (r) => r)));
    } catch (e) {
      emit(ProfileFriendsState.error(error: e.toString()));
    }
  }

  ///accept the friendship and wait for backendresponse, maybe update the listview here too?
  Future<bool> acceptFriendship(Profile profile) async {
    final success = await repository.acceptFriend(profile.id);

    return success;
  }

  ///delete the friendship and update the listview, 2 lists for the tabs
  Future<bool> deleteFriendship(Profile profile) async {
    final success = await repository.deleteFriend(profile.id);

    this.state.maybeMap((value) => null,
        loadedBoth: (state) {
          state.friendList.remove(profile);
          List<Profile> friends = state.friendList;
          List<Profile> pendingFriends = state.pendingFriendsList;

          //update the listview
          emit(ProfileFriendsState.deleted(profile: profile));
          //emit state again to have the new list
          emit(ProfileFriendsState.loadedBoth(
              friendList: friends, pendingFriendsList: pendingFriends));
        },
        orElse: () => throw Exception('LogicError'));

    return success;
  }
}
