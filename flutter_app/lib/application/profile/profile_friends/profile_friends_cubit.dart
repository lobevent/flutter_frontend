import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/profile/i_profile_repository.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/domain/profile/profile_failure.dart';
import 'package:flutter_frontend/domain/profile/value_objects.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_repository.dart';

part 'profile_friends_cubit.freezed.dart';
part 'profile_friends_state.dart';

class ProfileFriendsCubit extends Cubit<ProfileFriendsState> {
  final UniqueId? profileId;

  ProfileFriendsCubit(this.profileId) : super(ProfileFriendsState.initial()) {
    emit(ProfileFriendsState.initial());
    getFriends();
  }
  ProfileRepository repository = GetIt.I<ProfileRepository>();

  //loading the friends and the pending friendrequests
  Future<void> getFriends() async {
    try {
      emit(ProfileFriendsState.loading());

      final Either<
          NetWorkFailure,
          List<
              Profile>> friendList = await repository.getList(
          Operation.friends, 0,
          // here a fake Profile Object is created, because only profileId is needed and available, but name must be in the Profile Object
          // if no profile id is given "profile" is set to null
          //profile: profileId == null ? null :Profile(name:ProfileName("thisNameIsFake"), id: profileId!)
          profile: profileId == null
              ? null
              : Profile(name: ProfileName("thisNameIsFake"), id: profileId!));
      //load the pending friends and mapping
      final Either<NetWorkFailure, List<Profile>> pendingFriendsList =
          await repository.getList(Operation.pendingFriends, 0);
      emit(ProfileFriendsState.loadedBoth(
          friendList: friendList.fold((l) => throw Exception(), (r) => r),
          pendingFriendsList:
              pendingFriendsList.fold((l) => throw Exception(), (r) => r)));
    } catch (e) {
      emit(ProfileFriendsState.error(error: e.toString()));
    }
  }

  Future<bool> deleteFriendship(Profile profile) async {
    final success = await repository.deleteFriend(profile.id);

    this.state.maybeMap((value) => null,
        loaded: (state) {
          state.friendList.remove(profile);
          List<Profile> friends = state.friendList;

          //update the listview
          emit(ProfileFriendsState.deleted(profile: profile));
          //emit state again to have the new list
          emit(ProfileFriendsState.loaded(friendList: friends));
        },
        orElse: () => throw Exception('LogicError'));

    return success;
  }
}
