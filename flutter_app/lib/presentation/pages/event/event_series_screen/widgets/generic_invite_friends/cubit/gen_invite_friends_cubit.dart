import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter_frontend/domain/event/event_series_invitation.dart';
import 'package:get_it/get_it.dart';

import '../../../../../../../domain/core/failures.dart';
import '../../../../../../../domain/event/event_series.dart';
import '../../../../../../../domain/event/invitation.dart';
import '../../../../../../../domain/profile/profile.dart';
import '../../../../../../../infrastructure/event_series/eventSeries_repository.dart';
import '../../../../../../../infrastructure/event_series_invitation/esi_repository.dart';
import '../../../../../../../infrastructure/invitation/invitation_repository.dart';
import '../../../../../../../infrastructure/profile/profile_repository.dart';
import '../gen_invite_friends_button.dart';

part 'gen_invite_friends_state.dart';

part 'gen_invite_friends_cubit.g.dart';

class GenInviteFriendsCubit<T> extends Cubit<GenInviteFriendsState<T>> {
  bool disableButton = false;
  final InviteFriendsButtonType inviteFriendsButtonType;
  final String? seriesId;
  final String? eventId;

  GenInviteFriendsCubit({required this.inviteFriendsButtonType, this.seriesId, this.eventId})
      : super(GenInviteFriendsState.initial()) {
    //loadFriendsAndStuff();
  }
  ProfileRepository profileRepository = GetIt.I<ProfileRepository>();
  EventSeriesRepository repository = GetIt.I<EventSeriesRepository>();
  EventSeriesInvitationRepository esiRepository =
      GetIt.I<EventSeriesInvitationRepository>();
  InvitationRepository invitationRepository = GetIt.I<InvitationRepository>();

  Future<void> loadFriendsAndStuff(List<T>? invsAlreadyLoaded ) async {
    await profileRepository.getFriends(profile: null).then((value) =>
        value.fold(
            (failure) => emit(state.copyWith(
                status: GenInviteFriendsStatus.error, failure: failure)),
            // compare the complete friendlist with the invitations for this event
            // set isLoadingFriends false, as they are loaded now obviously
            (friends)  {
          switch (inviteFriendsButtonType) {
            /// CASE EVENTSERIES ///
            case InviteFriendsButtonType.eventseries:
              esiRepository
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
          /// CASE EVENTSCREEN ///
            case InviteFriendsButtonType.event:
              emit(state.copyWith(status: GenInviteFriendsStatus.loaded,
              friends: friends, genericInvs: invsAlreadyLoaded as List<T>));
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
        await invitationRepository.sendInvitation(profile, eventId!, false).then((value) => value.fold(
                (failure) => emit(state.copyWith(status: GenInviteFriendsStatus.error,
                failure: failure)),
                (changeInv){
                  List<T> genInvsAdded = [...state.genericInvs, changeInv as T];
                  emit(state.copyWith(status: GenInviteFriendsStatus.refresh,
                  genericInvs: genInvsAdded as List<T>));
                })
        );
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
                  List<EventSeriesInvitation> esInvsUpdated= List.from(esInvs);
                  esInvsUpdated.removeWhere((element) => element.id.value==esInv.id.value);
                  emit(state.copyWith(
                      status: GenInviteFriendsStatus.refresh,
                      genericInvs: esInvsUpdated as List<T>));
                }));
        break;
      case InviteFriendsButtonType.event:
        List<Invitation> invs =
        state.genericInvs as List<Invitation>;
        Invitation inv = invs
            .where((element) =>
        element.profile.id.value == profile.id.value)
            .first;
        await invitationRepository.revokeInvitation(profile, eventId!).then((value) => value.fold(
                (failure) => emit(state.copyWith(status: GenInviteFriendsStatus.error, failure: failure)),
                (invUpdated)  {
                  List<Invitation> invsUpdated= List.from(invs);
                  invsUpdated.removeWhere((element) => element.id.value==inv.id.value);
                  emit(state.copyWith(status: GenInviteFriendsStatus.refresh,
                  genericInvs: invsUpdated as List<T>));
                }));
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
                  List<T> genInvsAdded = [...state.genericInvs, esInv as T];
                  emit(state.copyWith(
                      status: GenInviteFriendsStatus.refresh,
                      genericInvs: genInvsAdded as List<T>));
                }));
        break;
      case InviteFriendsButtonType.event:
        await invitationRepository.addHost(profile, eventId!).then((value) => value.fold(
                (failure) => emit(state.copyWith(
                    status: GenInviteFriendsStatus.error,
                    failure: failure)),
                (inv) {
                  List<T> genInvsAdded = [...state.genericInvs, inv as T];
                  emit(state.copyWith(
                      status: GenInviteFriendsStatus.refresh,
                      genericInvs: genInvsAdded as List<T>));

                }));
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
                  List<EventSeriesInvitation> esInvsUpdated = List.from(esInvs);
                  esInvsUpdated.removeWhere((element) => element.id.value==esInv.id.value);
                  emit(state.copyWith(
                      status: GenInviteFriendsStatus.refresh,
                      genericInvs: esInvsUpdated as List<T>));
                }));
        break;
      case InviteFriendsButtonType.event:
        List<Invitation> invs =
        state.genericInvs as List<Invitation>;
        Invitation inv = invs
            .where((element) =>
        element.profile.id.value == profile.id.value)
            .first;
        await invitationRepository.removeHost(profile, eventId!).then((value) => value.fold(
                (failure) => emit(state.copyWith(
                status: GenInviteFriendsStatus.error,
                failure: failure)), (inv) {
          List<Invitation> invsUpdated = List.from(invs);
          invsUpdated.removeWhere((element) => element.id.value==inv.id.value);
          emit(state.copyWith(
              status: GenInviteFriendsStatus.refresh,
              genericInvs: invsUpdated as List<T>));
        }));
        break;
      case InviteFriendsButtonType.todo:
        // TODO: Handle this case.
        break;
    }
  }
}
