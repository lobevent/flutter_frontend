import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter_frontend/domain/event/event_series_invitation.dart';
import 'package:get_it/get_it.dart';

import '../../../../../../../domain/core/failures.dart';
import '../../../../../../../domain/event/event_series.dart';
import '../../../../../../../domain/profile/profile.dart';
import '../../../../../../../infrastructure/event_series/eventSeries_repository.dart';
import '../../../../../../../infrastructure/event_series_invitation/esi_repository.dart';
import '../../../../../../../infrastructure/profile/profile_repository.dart';
import '../gen_invite_friends_button.dart';

part 'gen_invite_friends_state.dart';

part 'gen_invite_friends_cubit.g.dart';

class GenInviteFriendsCubit<T> extends Cubit<GenInviteFriendsState<T>> {
  bool disableButton = false;
  final InviteFriendsButtonType inviteFriendsButtonType;
  final String? seriesId;

  GenInviteFriendsCubit({required this.inviteFriendsButtonType, this.seriesId})
      : super(GenInviteFriendsState.loading()) {
    //loadFriendsAndStuff();
  }
  ProfileRepository profileRepository = GetIt.I<ProfileRepository>();
  EventSeriesRepository repository = GetIt.I<EventSeriesRepository>();
  EventSeriesInvitationRepository esiRepository =
      GetIt.I<EventSeriesInvitationRepository>();

  Future<void> loadFriendsAndStuff() async {
    await profileRepository.getFriends(profile: null).then((value) =>
        value.fold(
            (failure) => emit(state.copyWith(
                status: GenInviteFriendsStatus.error, failure: failure)),
            // compare the complete friendlist with the invitations for this event
            // set isLoadingFriends false, as they are loaded now obviously
            (friends) async {
          switch (inviteFriendsButtonType) {
            case InviteFriendsButtonType.eventseries:
              await esiRepository
                  .getUnAcceptedInvitesAsHost(seriesId: seriesId!)
                  .then((value) => value.fold(
                          (failue) => emit(state.copyWith(
                              status: GenInviteFriendsStatus.error,
                              failure: failue)), (esInvs) {
                        emit(state.copyWith(
                            status: GenInviteFriendsStatus.loaded,
                            friends: friends,
                            genericInvs: esInvs as List<T>));
                        this.disableButton = false;
                      }));
              break;
            case InviteFriendsButtonType.event:
              // TODO: Handle this case.
              break;
            case InviteFriendsButtonType.todo:
              // TODO: Handle this case.
              break;
          }
        }));
  }

  Future<void> sendInvite(Profile profile) async {
    switch (inviteFriendsButtonType) {
      case InviteFriendsButtonType.eventseries:
        emit(state.copyWith(status: GenInviteFriendsStatus.loading));
        await esiRepository
            .changeInviteStatus_ofUser(
                seriesId: seriesId!, profile: profile, invited: true)
            .then((value) => value.fold(
                    (failure) => emit(state.copyWith(
                        status: GenInviteFriendsStatus.error,
                        failure: failure)), (changedInvite) {
                  List<T> genInvsAdded = [...state.genericInvs, changedInvite as T];
                  emit(state.copyWith(
                    status: GenInviteFriendsStatus.refresh,
                    genericInvs: genInvsAdded as List<T>,
                  ));
                }));
        break;
      case InviteFriendsButtonType.event:
        // TODO: Handle this case.
        break;
      case InviteFriendsButtonType.todo:
        // TODO: Handle this case.
        break;
    }
  }

  Future<void> revokeInvite(Profile profile) async {
    switch (inviteFriendsButtonType) {
      case InviteFriendsButtonType.eventseries:
        List<EventSeriesInvitation> esInvs =
            state.genericInvs as List<EventSeriesInvitation>;
        EventSeriesInvitation esInv = esInvs
            .where((element) =>
                element.invitedProfile.id.value == profile.id.value)
            .first;
        emit(state.copyWith(status: GenInviteFriendsStatus.loading));
        await esiRepository
            .changeInviteStatus_ofUser(
                seriesId: seriesId!, profile: profile, invited: false)
            .then((value) => value.fold(
                    (failure) => emit(state.copyWith(
                        status: GenInviteFriendsStatus.error,
                        failure: failure)), (esInv) {
                  esInvs.remove(esInv);
                  emit(state.copyWith(
                      status: GenInviteFriendsStatus.refresh,
                      genericInvs: esInvs as List<T>));
                }));
        break;
      case InviteFriendsButtonType.event:
        // TODO: Handle this case.
        break;
      case InviteFriendsButtonType.todo:
        // TODO: Handle this case.
        break;
    }
  }

  Future<void> sendInviteAsHost(Profile profile) async {
    switch (inviteFriendsButtonType) {
      case InviteFriendsButtonType.eventseries:
        await esiRepository
            .changeInviteStatus_ofUser(
                seriesId: seriesId!,
                profile: profile,
                invited: true,
                addHost: true)
            .then((value) => value.fold(
                    (failure) => emit(state.copyWith(
                        status: GenInviteFriendsStatus.error,
                        failure: failure)), (esInv) {
                  var genInvsAdded = [...state.genericInvs, esInv];
                  emit(state.copyWith(
                      status: GenInviteFriendsStatus.refresh,
                      genericInvs: genInvsAdded as List<T>));
                }));
        break;
      case InviteFriendsButtonType.event:
        // TODO: Handle this case.
        break;
      case InviteFriendsButtonType.todo:
        // TODO: Handle this case.
        break;
    }
  }

  Future<void> revokeInviteAsHost(Profile profile) async {
    switch (inviteFriendsButtonType) {
      case InviteFriendsButtonType.eventseries:
        List<EventSeriesInvitation> esInvs =
            state.genericInvs as List<EventSeriesInvitation>;
        EventSeriesInvitation esInv = esInvs
            .where((element) =>
                element.invitedProfile.id.value == profile.id.value)
            .first;
        await esiRepository
            .changeInviteStatus_ofUser(
                seriesId: seriesId!,
                profile: profile,
                invited: false,
                addHost: false)
            .then((value) => value.fold(
                    (failure) => emit(state.copyWith(
                        status: GenInviteFriendsStatus.error,
                        failure: failure)), (esInv) {
                  esInvs.remove(esInv);
                  emit(state.copyWith(
                      status: GenInviteFriendsStatus.refresh,
                      genericInvs: esInvs as List<T>));
                }));
        break;
      case InviteFriendsButtonType.event:
        // TODO: Handle this case.
        break;
      case InviteFriendsButtonType.todo:
        // TODO: Handle this case.
        break;
    }
  }
}
