import 'package:flutter/cupertino.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/event/event_series.dart';
import 'package:flutter_frontend/domain/event/invitation.dart';
import 'package:flutter_frontend/domain/event/value_objects.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/infrastructure/core/base_dto.dart';
import 'package:flutter_frontend/infrastructure/core/json_converters.dart';
import 'package:flutter_frontend/infrastructure/event/event_dtos.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_dtos.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'eventSeries_dtos.freezed.dart';
part 'eventSeries_dtos.g.dart';

@freezed
class EventSeriesDto extends BaseDto with _$EventSeriesDto {

  const EventSeriesDto._();

  const factory EventSeriesDto(
      {
        required String id,
        required String name,
        required String description,
        @JsonKey(includeIfNull: false) @EventListConverter() List<EventDto>? upcomingEvents,
        @JsonKey(includeIfNull: false) @EventListConverter() List<EventDto>? recentEvents,
        int? subscribersCount,
        int? eventCount,
        bool? subscribed,
        //@JsonKey(includeIfNull: false) @EventListConverter() List<EventDto>? events,
        DateTime? creationDate}) = EventSeriesFull;

  @override
  EventSeries toDomain() {
    return EventSeries(
        id: UniqueId.fromUniqueString(id),
        description: EventDescription(description),
        name: EventName(name),
        recentEvents: recentEvents?.map((e) => e.toDomain()).toList(),
        upcomingEvents: upcomingEvents?.map((e) => e.toDomain()).toList(),
        subscribersCount: subscribersCount,
        eventCount: eventCount,
        subscribed: subscribed,
        );
  }

  factory EventSeriesDto.fromDomain(EventSeries eventSeries) {
    return EventSeriesDto(
      name: eventSeries.name.getOrCrash(),
      description: eventSeries.description.getOrCrash(),
      id: eventSeries.id.value
    );
  }

  factory EventSeriesDto.fromJson(Map<String, dynamic> json) =>
      _$EventSeriesDtoFromJson(json);
}

class EventListConverter extends ListConverter<EventDto> {
  const EventListConverter() : super();
}
