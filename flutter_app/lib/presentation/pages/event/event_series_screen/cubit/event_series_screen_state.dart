part of 'event_series_screen_cubit.dart';

@freezed
class EventSeriesScreenState with _$EventSeriesScreenState {
  //bool isLoadingFriends=false;
  //List<Profile>? friends;
  //List<EventSeriesInvitation>? invitedFriends;

  const factory EventSeriesScreenState.loading() = ESS_Loading;
  const factory EventSeriesScreenState.ready(EventSeries series) = ESS_Ready;
  const factory EventSeriesScreenState.readyAndLoadingSubscription(
      EventSeries series) = ESS_ReadySubscrLoading;
  const factory EventSeriesScreenState.failure(NetWorkFailure failure) =
      ESS_ERROR;
}
