import 'package:bloc/bloc.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/infrastructure/invitation/invitation_repository.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_repository.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/cubit/event_screen/event_screen_cubit.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'add_friends_cubit.freezed.dart';
part 'add_friends_state.dart';

class AddFriendsCubit extends Cubit<AddFriendsState> {
  AddFriendsCubit() : super(AddFriendsState.loadingFriends()){getFriends();}


  ProfileRepository profileRepository = GetIt.I<ProfileRepository>();
  InvitationRepository invitationRepository = GetIt.I<InvitationRepository>();

  ///
  /// this method fetches friends from the backend when needed
  ///
  Future<void>  getFriends() async{
    this.profileRepository.getFriends().then((friendsOrFailure) =>
    // fold the response as it could be an failure
    friendsOrFailure.fold(
      // on failure emit an errorstate
            (failure) => emit(AddFriendsState.error(failure: failure)),
        // if everything went right the user can precede with adding friends
            (friends) => emit(AddFriendsState.loadedFriends(friends: friends)))
    );
  }


  Future<void> inviteFriend(Profile profile, Event event, bool isHost, EventScreenCubit cubit) async{
    invitationRepository.sendInvitation(profile, event, isHost).then((value) => value.fold(
            (failure) => emit(AddFriendsState.error(failure: failure)),
            (invitation){
              AddFriendsState currentState = state;
              emit(AddFriendsState.loadingFriends());
              emit(currentState);
              cubit.addedInvitation(invitation);
            }));
  }


  Future<void> revokeInvitation(Profile profile, Event event, EventScreenCubit cubit) async{
    invitationRepository.revokeInvitation(profile, event).then((value) => value.fold(
            (failure) => emit(AddFriendsState.error(failure: failure)),
            (invitation){
              AddFriendsState currentState = state;
              emit(AddFriendsState.loadingFriends());
              emit(currentState);
              // with this one the view is updated!
              cubit.revokedInvitation(invitation);
            }));
  }


  Future<void> onAddHost(Profile profile, Event event, EventScreenCubit cubit) async{
    throw UnimplementedError();
  }
}
