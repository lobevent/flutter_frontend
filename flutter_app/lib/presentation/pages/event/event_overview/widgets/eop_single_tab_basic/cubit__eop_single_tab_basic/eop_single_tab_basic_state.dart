part of 'eop_single_tab_basic_cubit.dart';

enum Status {loading, success, failure/*, recentEventsLoading*/}
class EopSingleTabBasicState {
  const EopSingleTabBasicState({required this.events/*, this.recentEvents = const []*/, required this.status, this.failure});

  final List<Event> events;
  /*final List<Event> recentEvents;*/
  final Status status;
  final NetWorkFailure? failure;

  EopSingleTabBasicState copyWith({List<Event>? events, Status? status, NetWorkFailure? failure/*, List<Event>? recentEvents*/}){
    return EopSingleTabBasicState(
        /*recentEvents: recentEvents ?? this.recentEvents,*/
        events: events ?? this.events,
        status: status ?? this.status,
        failure: failure);
  }

  EopSingleTabBasicState addEventsToList(List<Event> newEvents){
    return copyWith(events: List.of(events)..addAll(newEvents));
  }

}

