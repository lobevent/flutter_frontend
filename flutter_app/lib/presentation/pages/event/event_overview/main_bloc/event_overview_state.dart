part of 'event_overview_bloc.dart';

enum MainStatus {upcoming, recent}
class EventOverviewState {
  EventOverviewState({required this.status});
  MainStatus status;
}

