part of 'eop_single_tab_distances_cubit.dart';

enum Status {gettingGPSPosition, loadingEvents, success, failure}
class EopSingleTabDistancesState {
  const EopSingleTabDistancesState({required this.events, required this.status, this.failure});

  final List<Event> events;
  final Status status;
  final NetWorkFailure? failure;

  EopSingleTabDistancesState copyWith({List<Event>? events, Status? status, NetWorkFailure? failure,}){
    return EopSingleTabDistancesState(
        events: events ?? this.events,
        status: status ?? this.status,
        failure: failure);
  }

  factory EopSingleTabDistancesState.loadingEmpty(){ return const EopSingleTabDistancesState(events: [], status: Status.loadingEvents);}

  EopSingleTabDistancesState addEventsToList(List<Event> newEvents){
    return copyWith(events: List.of(events)..addAll(newEvents));
  }

}

