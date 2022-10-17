part of 'eop_single_tab_basic_cubit.dart';

enum Status {loading, success, failure}
class EopSingleTabBasicState {
  const EopSingleTabBasicState({required this.events, required this.status, this.failure});

  final List<Event> events;
  final Status status;
  final NetWorkFailure? failure;

  EopSingleTabBasicState copyWith({List<Event>? events, Status? status, NetWorkFailure? failure,}){
    return EopSingleTabBasicState(
        events: events ?? this.events,
        status: status ?? this.status,
        failure: failure);
  }

  EopSingleTabBasicState addEventsToList(List<Event> newEvents){
    return copyWith(events: List.of(events)..addAll(newEvents));
  }

}

