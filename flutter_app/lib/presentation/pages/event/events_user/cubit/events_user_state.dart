part of 'events_user_cubit.dart';

@freezed
class EventsUserState with _$EventsUserState{

  const factory EventsUserState.loading() = LoadingState;
  const factory EventsUserState.loaded({required List<Event> future_events, required List<Event> recent_events}) = EventsLoaded;
  const factory EventsUserState.failure({required NetWorkFailure failure}) = Failure;
}


