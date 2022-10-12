import 'package:flutter_frontend/infrastructure/event_series/eventSeries_dtos.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_frontend/infrastructure/core/json_converters.dart';
import 'package:flutter_frontend/infrastructure/core/base_dto.dart';

import '../../domain/feed/event_and_post_carrier.dart';
import '../event/event_dtos.dart';
import '../post/post_dtos.dart';

part 'event_and_post_carrier_dtos.freezed.dart';

@freezed
class EventAndPostCarrierDto extends BaseDto with _$EventAndPostCarrierDto {
  const EventAndPostCarrierDto._();

  factory EventAndPostCarrierDto({
    @EventListConverter() required List<EventDto> eventsDto,
    @PostConverter() required List<PostDto> postsDto,
  }) = EventAndPostCarrierFull;

  @override
  EventsAndPostsCarrier toDomain() {
    return EventsAndPostsCarrier(
      events: eventsDto.map((e) => e.toDomain()).toList(),
      posts: postsDto.map((e) => e.toDomain()).toList(),
    );
  }

  factory EventAndPostCarrierDto.fromDomain(
      EventsAndPostsCarrier eventAndPostCarrier) {
    return EventAndPostCarrierDto(postsDto: [], eventsDto: []);
  }

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}

class EventAndPostListConverter extends ListConverter<EventAndPostCarrierDto> {
  const EventAndPostListConverter() : super();
}
