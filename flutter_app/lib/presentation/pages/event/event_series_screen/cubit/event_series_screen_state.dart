part of 'event_series_screen_cubit.dart';

enum EventSeriesScreenStatus { loading, loaded, error }

@CopyWith()
class EventSeriesScreenState {
  //bool isLoadingFriends=false;
  //List<Profile>? friends;
  //List<EventSeriesInvitation>? invitedFriends;
  final EventSeries eventSeries;
  final EventSeriesScreenStatus status;
  final NetWorkFailure? failure;
  final bool? subscribed;
  final List<Profile> friends;
  final List<EventSeriesInvitation> esInv;

  factory EventSeriesScreenState.loading() => EventSeriesScreenState(
      status: EventSeriesScreenStatus.loading,
      eventSeries: EventSeries.empty());

  factory EventSeriesScreenState.loaded({required EventSeries eventSeries}) =>
      EventSeriesScreenState(
          status: EventSeriesScreenStatus.loaded, eventSeries: eventSeries);

  EventSeriesScreenState(
      {this.subscribed,
      this.failure,
      required this.eventSeries,
      required this.status,
      this.friends = const [],
      this.esInv = const []}) {}
}
