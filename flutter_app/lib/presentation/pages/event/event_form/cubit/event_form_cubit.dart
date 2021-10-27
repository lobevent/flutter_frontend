import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/event/value_objects.dart';
import 'package:flutter_frontend/domain/profile/i_profile_repository.dart'
    as profileOps;
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/infrastructure/event/event_repository.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';

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

  Future<void> saveEvent() async {
    Either<NetWorkFailure, Unit>? failureOrSuccess;
    emit(state.copyWith(isSaving: true));
    if (state.event.failureOption.isNone()) {
      //failureOrSuccess =  await right(unit);
      //failureOrSuccess =  await left(EventFailure.insufficientPermissions());
      failureOrSuccess = (await repository.create(state.event))
          .fold((l) => left(l), (r) => right(unit));
    }
    emit(state.copyWith(
        isSaving: false,
        showErrorMessages: true,
        saveFailureOrSuccessOption: optionOf(failureOrSuccess)));
  }

  Future<void> submit() async {
    if (state.isEditing) {
      updateEvent();
      return;
    }
    saveEvent();
  }

  void changeTitle(String title) {
    emit(state.copyWith(event: state.event.copyWith(name: EventName(title))));
  }

  void changeBody(String body) {
    emit(state.copyWith(
        event: state.event.copyWith(description: EventDescription(body))));
  }

  void changeDate(DateTime date) {
    emit(state.copyWith(event: state.event.copyWith(date: date.toUtc())));
  }

  void changePublic(bool public) {
    emit(state.copyWith(event: state.event.copyWith(public: public)));
  }

  void changeVisibleWithoutLogin(bool vwl) {
    emit(state.copyWith(event: state.event.copyWith(visibleWithoutLogin: vwl)));
  }

  void addFriend(Profile profile) {
    // TODO: implement this
  }

  void removeFriend(Profile profile) {
    // TODO: implement this
  }

  /// fetch friends
  Future<void> getFriends() async {
    emit(state.copyWith(isLoadingFriends: true));
    (await this.profileRepository.getList(profileOps.Operation.friends, 1000))
        .fold(
            (failure) => EventFormState.error(failure),
            // compare the complete friendlist with the invitations for this event
            // set isLoadingFriends false, as they are loaded now obviously
            (friends) => emit(state.copyWith(
                friends: friends,
                isLoadingFriends: false,
                invitedFriends:
                    _generateAttendingFriends(state.event, friends))));
  }

  Future<void> loadEvent(String id) async {
    emit(EventFormState.loading());
    repository.getSingle(UniqueId.fromUniqueString(id)).then((value) =>
        value.fold((failure) => emit(EventFormState.error(failure)),
            (event) => emit(EventFormState.loaded(event))));
  }

  Future<void> updateEvent() async {
    Either<NetWorkFailure, Unit>? failureOrSuccess;
    emit(state.copyWith(isSaving: true));
    if (state.event.failureOption.isNone()) {
      //failureOrSuccess =  await right(unit);
      //failureOrSuccess =  await left(EventFailure.insufficientPermissions());
      failureOrSuccess = (await repository.update(state.event))
          .fold((l) => left(l), (r) => right(unit));
    }
    emit(state.copyWith(
        isSaving: false,
        showErrorMessages: true,
        saveFailureOrSuccessOption: optionOf(failureOrSuccess)));
  }

  /// compare event invitations with an friendlist, and generate list with the intersection
  List<Profile> _generateAttendingFriends(Event event, List<Profile> friends) {
    List<Profile> invitedFriends = [];
    event.invitations?.forEach((invitedProfile) {
      if (friends
          .map((friend) => friend.id.getOrCrash())
          .contains(invitedProfile.id.getOrCrash())) {
        invitedFriends.add(invitedProfile);
      }
    });
    return invitedFriends;
  }
}
