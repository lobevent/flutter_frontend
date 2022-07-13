part of 'events_mulitlist_cubit.dart';

@freezed
class EventsMultilistState with _$EventsMultilistState {
  const factory EventsMultilistState({
    required List<Event> ownEventsList,
    required bool showErrorMessages,
    List<Event>? eventsListRecent,
  }) = _OwnEventsState;

  factory EventsMultilistState.initial() = _Initial;

  factory EventsMultilistState.loading() = _LoadInProgress;

  factory EventsMultilistState.loaded({required List<Event> events}) = _Loaded;

  factory EventsMultilistState.loadedOwnBoth(
      {required List<Event> eventsUpcoming,
      required List<Event> eventsRecent}) = _LoadedBoth;

  factory EventsMultilistState.loadedInvited(
      {required List<Invitation> invites}) = _LoadedInvited;

  factory EventsMultilistState.error({required String error}) = _LoadFailure;

  factory EventsMultilistState.deleted({required Event event}) = _deletedEvent;
}
