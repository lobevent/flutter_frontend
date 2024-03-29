part of 'event_series_list_cubit.dart';

@freezed
class EventSeriesListState with _$EventSeriesListState{

  const EventSeriesListState._();
  const factory EventSeriesListState.loading() = ESL_Loading;
  const factory EventSeriesListState.ready(OwnAndSubscribedEventSeries seriesList, List<EventSeriesInvitation> esInvs) = ESL_Ready;
  const factory EventSeriesListState.failure(NetWorkFailure failure) = ESL_ERROR;


}

