part of 'event_series_form_cubit.dart';

@freezed
class EventSeriesFormState with _$EventSeriesFormState{

  const EventSeriesFormState._();
  const factory EventSeriesFormState.initial() = ESF_Initial;
  const factory EventSeriesFormState.saving() = ESF_Saving;
  const factory EventSeriesFormState.ready(EventSeries series) = ESF_Ready;
}

