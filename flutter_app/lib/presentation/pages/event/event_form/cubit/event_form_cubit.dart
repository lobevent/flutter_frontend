import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
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
import 'package:flutter_frontend/presentation/pages/event/event_form/cubit/efcubit_editing_mixin.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../infrastructure/core/local/common_hive/common_hive.dart';
import '../../../../../infrastructure/event_series/eventSeries_repository.dart';

part 'event_form_cubit.g.dart';
part 'event_form_state.dart';

class EventFormCubit extends Cubit<EventFormState> with EventFormCubitEditing {
  final Option<String> eventId;
  EventFormCubit(this.eventId) : super(EventFormState.initial(isEdit: eventId.isSome())) {
    eventId.fold((){} , (id) => loadEvent(id));
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


  /// fetch friends
  Future<void> getFriends() async {
    emit(state.copyWith(friendStatus: FriendsStatus.loading));
    (await this.profileRepository.getFriends(profile: null)).fold(
        (failure) => state.copyWith(friendStatus: FriendsStatus.error, friendsFailure: failure),
        // compare the complete friendlist with the invitations for this event
        // set isLoadingFriends false, as they are loaded now obviously
        (friends) {
      _getEventOwnedSeries().then((series) => series.fold(
            (failure) => state.copyWith(seriesStatus: SeriesStatus.error, seriesFailure: failure),
            (mySeries) => emit(state.copyWith(
                event: removeNoneFriends(state.event, friends),
                seriesStatus: SeriesStatus.ready,
                friendStatus: FriendsStatus.ready,
                friends: friends,
                series: mySeries)),
          ));
    });
  }

  Future<void> loadEvent(String id) async {
    emit(state.copyWith(status: MainStatus.loading, isEditing: true));
    repository.getSingle(UniqueId.fromUniqueString(id)).then((value) =>
        value.fold((failure) => emit(state.copyWith(eventFailure:  failure, status: MainStatus.error)),
            (event) => emit(state.copyWith(event: event, status: MainStatus.ready))));
  }

  /// save event to database
  Future<void> saveEvent() async {
    //safe for score
    return updateEditEvent(() => repository.create(state.event));
  }

  /// upload edited event and send to server
  Future<void> updateEvent() async {
    return updateEditEvent(() => repository.update(state.event));
  }

  Future<void> updateEditEvent(Future<Either<NetWorkFailure, Event>> Function() serverCall) async {
    Either<NetWorkFailure, Unit>? failureOrSuccess;
    if (state.event.failureOption.isNone()) {
    emit(state.copyWith(status: MainStatus.saving));
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
    }else{
      emit(state.copyWith(status: MainStatus.formHasErrors, showErrorMessages: true));
    }
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
    List<Invitation> invitations = List.from(event.invitations);
    invitations.removeWhere((invitation) =>
        !friends.map((i) => i.id.value).contains(invitation.profile.id.value));
    return event.copyWith(invitations: invitations);
  }

  // Future<void> chooseImage(Event event) async {
  //   emit(state.copyWith(event: state.event.copyWith(image: await fileRepository.getImage())));
  // }
}
