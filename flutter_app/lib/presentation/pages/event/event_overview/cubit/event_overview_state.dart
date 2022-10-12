part of 'event_overview_cubit.dart';

@freezed
class EventOverviewState {
  const factory EventOverviewState.loading() = LoadingState;
  const factory EventOverviewState.loaded({required List<Event> invited_events, required List<Event> attending_events, required List<Event> local}) = EventsLoaded;
  const factory EventOverviewState.failure({required NetWorkFailure failure}) = Failure;
}


