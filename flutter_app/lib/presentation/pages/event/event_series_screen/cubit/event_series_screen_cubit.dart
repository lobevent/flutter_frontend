import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event_series.dart';
import 'package:flutter_frontend/infrastructure/event_series/eventSeries_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

import '../../../../../domain/event/event_series_invitation.dart';
import '../../../../../domain/profile/profile.dart';
import '../../../../../domain/profile/value_objects.dart';
import '../../../../../infrastructure/event_series_invitation/esi_repository.dart';
import '../../../../../infrastructure/profile/profile_repository.dart';

part 'event_series_screen_state.dart';

part 'event_series_screen_cubit.g.dart';

class EventSeriesScreenCubit extends Cubit<EventSeriesScreenState> {
  bool disableButton = false;
  EventSeriesRepository repository = GetIt.I<EventSeriesRepository>();
  EventSeriesInvitationRepository esiRepository =
      GetIt.I<EventSeriesInvitationRepository>();
  UniqueId seriesId;

  EventSeriesScreenCubit({required this.seriesId})
      : super(EventSeriesScreenState.loading()) {
    loadEventSeries();
    getOwnInvs();
  }

  ProfileRepository profileRepository = GetIt.I<ProfileRepository>();

  Future<void> loadEventSeries() async {
    repository.getSeriesById(seriesId).then((series) {
      series.fold(
          (failure) => emit(state.copyWith(
              status: EventSeriesScreenStatus.error, failure: failure)),
          (series) => emit(EventSeriesScreenState.loaded(eventSeries: series)));
    });
  }

  Future<void> subscribe() async {
    if (state.status == EventSeriesScreenStatus.loaded) {
      emit(state.copyWith(subscribed: true));
      this.repository.addSubscription(state.eventSeries).then((value) {
        value.fold(
            (failure) => emit(state.copyWith(
                status: EventSeriesScreenStatus.error, failure: failure)), (_) {
          emit(state.copyWith(
              eventSeries: state.eventSeries.copyWith(subscribed: true)));
        });
      });
    }
  }

  Future<void> unsubscribe() async {
    if (state.status == EventSeriesScreenStatus.loaded)
      emit(state.copyWith(subscribed: false));
    this.repository.revokeSubscribtion(state.eventSeries).then((value) {
      value.fold(
          (failure) => emit(state.copyWith(
              status: EventSeriesScreenStatus.error, failure: failure)), (_) {
        emit(state.copyWith(
            eventSeries: state.eventSeries.copyWith(subscribed: false)));
      });
    });
  }

  /// fetch friends
  Future<void> getFriendsAndEsInv() async {
    (await this.profileRepository.getFriends(profile: null)).fold(
        (failure) => emit(state.copyWith(
            status: EventSeriesScreenStatus.error, failure: failure)),
        // compare the complete friendlist with the invitations for this event
        // set isLoadingFriends false, as they are loaded now obviously
        (friends) {
      repository.getSeriesById(seriesId).then((series) => series.fold(
              (failure) => emit(state.copyWith(
                  status: EventSeriesScreenStatus.error,
                  failure: failure)), (series) {
            esiRepository.getUnacceptedEventSeriesInvites().then((value) =>
                value.fold(
                    (failure) => emit(state.copyWith(
                        status: EventSeriesScreenStatus.error,
                        failure: failure)),
                    (esInv) => emit(state.copyWith(
                        eventSeries: series, friends: friends, esInv: esInv))));
          }));
    });
  }

  Future<void> getOwnInvs() async {
    await esiRepository.getUnacceptedEventSeriesInvites().then((value) =>
        value.fold(
            (failure) => emit(state.copyWith(
                status: EventSeriesScreenStatus.error, failure: failure)),
            (r) => emit(state.copyWith(
                status: EventSeriesScreenStatus.loaded, esInv: r))));
  }

  // ------------------------------------------------ add/remove friends EsInv ----------------------
  Future<void> addFriend(
      EventSeries es, bool invited, Profile profile, bool isHost) async {
    esiRepository.changeInviteStatus_ofUser(
        profile: profile,
        invited: false,
        addHost: isHost,
        seriesId: seriesId.value.toString());
    /*if (!state.esInv.map((e) => e.invitedProfile).contains(profile)) {
      var esInv = EventSeriesInvitation(
          id: UniqueId(),
          eventSeries: state.eventSeries,
          creationDate: DateTime.now(),
          invitingProfile: Profile(id: UniqueId(), name: ProfileName("fake")),
          invitedProfile: profile,
          accepted: false,
          addAsHost: false);
      state.esInv.add(esInv);
      emit(state);
      addedInvitation(esInv);
    }

     */
  }

  void addFriendAsHost(Profile profile) async {
    if (!state.esInv.map((e) => e.invitedProfile).contains(profile)) {
      EventSeriesInvitation foundInv = state.esInv
          .where((element) => element.invitedProfile == profile)
          .first;
      if (foundInv != null) {
        foundInv.isHost = true;
      } else {
        state.esInv.add(EventSeriesInvitation(
            id: UniqueId(),
            eventSeries: state.eventSeries,
            creationDate: DateTime.now(),
            invitingProfile: Profile(id: UniqueId(), name: ProfileName("fake")),
            accepted: false,
            isHost: true,
            invitedProfile: profile));
        emit(state);
      }
    }
  }

  void removeFriend(Profile profile) async {
    if (state.esInv.map((e) => e.invitedProfile).contains(profile)) {
      state.esInv.removeWhere(
          (element) => element.invitedProfile.id.value == profile.id.value);
      emit(state);
    }
  }

  void removeFriendAsHost(Profile profile) async {
    if (!state.esInv.map((e) => e.invitedProfile).contains(profile)) {
      EventSeriesInvitation foundInv = state.esInv
          .where((element) => element.invitedProfile == profile)
          .first;
      if (foundInv != null) {
        foundInv.isHost = false;
      }
      emit(state);
    }
  }

  // -----------------------------------------VIEW for toggling checkmarks and host in friendlisttile ---------------
  void viewToggleHost(EventSeriesInvitation esInv, bool hostStatus) {
    if (state.status == EventSeriesScreenStatus.loaded) {
      EventSeriesInvitation esInvInList = state.esInv.firstWhere((element) =>
          element.invitedProfile.id.value == esInv.invitedProfile.id.value);
      esInvInList.isHost = hostStatus;
      emit(state);
    }
  }

  void removeHost(EventSeriesInvitation esInv) {
    viewToggleHost(esInv, false);
  }

  void addHost(EventSeriesInvitation esInv) {
    viewToggleHost(esInv, true);
  }

  void addedInvitation(EventSeriesInvitation esInv) {
    if (state.status == EventSeriesScreenStatus.loaded) {
      List<EventSeriesInvitation> esInvs = List.from(state.esInv);
      esInvs.add(esInv);
      emit(state.copyWith(esInv: esInvs));
    }
  }

  void removeInvitation(EventSeriesInvitation esInv) {
    if (state.status == EventSeriesScreenStatus.loaded) {
      state.esInv.removeWhere((element) =>
          element.invitedProfile.id.value == esInv.invitedProfile.id.value);
      emit(state);
    }
  }
}
