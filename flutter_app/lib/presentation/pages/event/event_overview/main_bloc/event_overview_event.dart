part of 'event_overview_bloc.dart';

@immutable
abstract class EventOverviewEvent {}

class EventOverviewShowUpcomming extends EventOverviewEvent{}
class EventOverviewShowRecent extends EventOverviewEvent{}
