import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/event/event_series.dart';
import 'package:flutter_frontend/domain/event/invitation.dart';
import 'package:flutter_frontend/domain/event/value_objects.dart';
import 'package:flutter_frontend/domain/profile/i_profile_repository.dart'
    as profileOps;
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/infrastructure/event/event_repository.dart';
import 'package:flutter_frontend/infrastructure/file/file_repository.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../infrastructure/event_series/eventSeries_repository.dart';

part 'event_form_cubit.freezed.dart';
part 'event_form_state.dart';

class EventFormCubit extends Cubit<EventFormState> {
  final Option<String> eventId;
  EventFormCubit(this.eventId) : super(EventFormState.initial()) {
    eventId.fold(() => emit(EventFormState.initial()),
        (id) => loadEvent(id).then((value) => getFriends()));
    getFriends();
  }

  ProfileRepository profileRepository = GetIt.I<ProfileRepository>();
  EventRepository repository = GetIt.I<EventRepository>();
  EventSeriesRepository repositorySeries = GetIt.I<EventSeriesRepository>();
  //FileRepository fileRepository = GetIt.I<FileRepository>();

  Future<void> submit() async {
    if (state.isEditing) {
      updateEvent();
      return;
    }
    saveEvent();
  }

  void changePicture(XFile picture) {
    emit(state.copyWith(picture: picture));
  }

  void setEventSeries(EventSeries? series) {
    emit(state.copyWith(event: state.event.copyWith(series: series)));
  }

  void changeTitle(String title) {
    emit(state.copyWith(event: state.event.copyWith(name: EventName(title))));
  }

  void changeBody(String body) {
    emit(state.copyWith(
        event: state.event.copyWith(description: EventDescription(body))));
  }

  void changeMaxPersons(int maxPersons){
    emit(state.copyWith(
        event: state.event.copyWith(maxPersons: maxPersons)));
  }

  void changeDate(DateTime date) {
    emit(state.copyWith(event: state.event.copyWith(date: date.toUtc())));
  }

  void changeLatitude(double? latitude) {
    emit(state.copyWith(event: state.event.copyWith(latitude: latitude)));
  }

  void changeLongitude(double? longitude) {
    emit(state.copyWith(event: state.event.copyWith(longitude: longitude)));
  }

  void changeAddress(String? address){
    emit(state.copyWith(event: state.event.copyWith(address: address)));
  }

  void changePublic(bool public) {
    emit(state.copyWith(event: state.event.copyWith(public: public)));
  }

  void changeVisibleWithoutLogin(bool vwl) {
    emit(state.copyWith(event: state.event.copyWith(visibleWithoutLogin: vwl)));
  }

  void addFriend(Profile profile) {
    if (!state.event.invitations.map((e) => e.profile).contains(profile)) {
      state.event.invitations.add(Invitation(
          profile: profile,
          event: state.event,
          id: UniqueId(),
          addHost: false));
      emit(state);
    }
  }

  /// invites an friend and makes him host
  void addFriendAsHost(Profile profile) {
    if (!state.event.invitations.map((e) => e.profile).contains(profile)) {
      Invitation foundInvitation = state.event.invitations
          .where((element) => element.profile == profile)
          .first;
      if (foundInvitation != null) {
        foundInvitation.addHost = true;
      } else {
        state.event.invitations.add(Invitation(
            profile: profile,
            event: state.event,
            id: UniqueId(),
            addHost: true));
      }
      emit(state);
    }
  }

  void removeFriendAsHost(Profile profile) {
    if (!state.event.invitations.map((e) => e.profile).contains(profile)) {
      Invitation foundInvitation = state.event.invitations
          .where((element) => element.profile == profile)
          .first;
      if (foundInvitation != null) {
        foundInvitation.addHost = false;
      }
      emit(state);
    }
  }

  void removeFriend(Profile profile) {
    if (state.event.invitations
        .map((e) => e.profile.id.toString())
        .contains(profile.id.toString())) {
      state.event.invitations.removeWhere(
          (invitation) => invitation.profile.id.value == profile.id.value);
      emit(state);
    }
  }

  /// fetch friends
  Future<void> getFriends() async {
    emit(state.copyWith(isLoadingFriends: true));
    (await this.profileRepository.getFriends(profile: null)).fold(
        (failure) => EventFormState.error(failure),
        // compare the complete friendlist with the invitations for this event
        // set isLoadingFriends false, as they are loaded now obviously
        (friends) {
      _getEventOwnedSeries().then((series) => series.fold(
            (failure) => EventFormState.error(failure),
            (mySeries) => emit(state.copyWith(
                event: removeNoneFriends(state.event, friends),
                friends: friends,
                isLoadingFriends: false,
                isLoadingSeries: false,
                series: mySeries)),
          ));
    });
  }

  Future<void> loadEvent(String id) async {
    emit(EventFormState.loading());
    repository.getSingle(UniqueId.fromUniqueString(id)).then((value) =>
        value.fold((failure) => emit(EventFormState.error(failure)),
            (event) => emit(EventFormState.loaded(event))));
  }

  /// save event to database
  Future<void> saveEvent() async {
    return updateEditEvent(() => repository.create(state.event));
  }

  /// upload edited event and send to server
  Future<void> updateEvent() async {
    return updateEditEvent(() => repository.update(state.event));
  }

  Future<void> updateEditEvent(
      Future<Either<NetWorkFailure, Event>> Function() serverCall) async {
    Either<NetWorkFailure, Unit>? failureOrSuccess;
    emit(state.copyWith(isSaving: true));
    if (state.event.failureOption.isNone()) {
      //failureOrSuccess =  await right(unit);
      //failureOrSuccess =  await left(EventFailure.insufficientPermissions());
      failureOrSuccess =
          await (await serverCall()).fold((l) => left(l), (r) async {
        if (state.picture != null) {
          (await repository.uploadMainImageToEvent(r.id, state.picture!))
              .fold((l) => left(l), (r) => right(unit));
        }

        return right(unit);
      });
    }
    emit(state.copyWith(
        isSaving: false,
        showErrorMessages: true,
        saveFailureOrSuccessOption: optionOf(failureOrSuccess)));
  }

  /// compare event invitations with an friendlist, and generate list with the intersection
/*  List<Invitation> _generateAttendingFriends(Event event, List<Profile> friends) {
    List<Invitation> invitedFriends = [];
    event.invitations.forEach((invitedProfile) {
      if (friends
          .map((friend) => friend.id.value)
          .contains(invitedProfile.profile.id.value)) {
        invitedFriends.add(invitedProfile);
      }
    });
    return invitedFriends;
  }*/

  Future<Either<NetWorkFailure, List<EventSeries>>> _getEventOwnedSeries() {
    return repositorySeries.getOwnedEventSeries();
  }

  /// remove non friends from invitations
  Event removeNoneFriends(Event event, List<Profile> friends) {
    event.invitations.removeWhere((invitation) =>
        !friends.map((i) => i.id.value).contains(invitation.profile.id.value));
    return event;
  }

  // Future<void> chooseImage(Event event) async {
  //   emit(state.copyWith(event: state.event.copyWith(image: await fileRepository.getImage())));
  // }
}
