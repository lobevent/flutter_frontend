
import 'package:flutter_frontend/domain/event/event_series.dart';
import 'package:flutter_frontend/infrastructure/core/json_converters.dart';
import 'package:flutter_frontend/infrastructure/event_series/eventSeries_dtos.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_series_helper_own_and_subscribed.freezed.dart';
part 'event_series_helper_own_and_subscribed.g.dart';

@freezed
class OwnAndSubscribedEventSeriesDto with _$OwnAndSubscribedEventSeriesDto{

  const OwnAndSubscribedEventSeriesDto._();

  const factory OwnAndSubscribedEventSeriesDto(
      {
        @EventSeriesListConverter() required List<EventSeriesDto> own,
        @EventSeriesListConverter() required List<EventSeriesDto> subscribed}) = OwnAndSubscESFull;

  factory OwnAndSubscribedEventSeriesDto.fromJson(Map<String, dynamic> json) =>
      _$OwnAndSubscribedEventSeriesDtoFromJson(json);
}

class EventSeriesListConverter extends ListConverter<EventSeriesDto>{
  const EventSeriesListConverter(): super();
}