part of 'events_own_cubit.dart';

@freezed
class EventsOwnState {

  const factory EventsOwnState.loading() = LoadingState;
  const factory EventsOwnState.loaded({required List<Event> events}) = EventsLoaded;
  const factory EventsOwnState.failure({required NetWorkFailure failure}) = Failure;
}


