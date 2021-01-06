import 'package:flutter_frontend/infrastructure/event/event_dtos.dart';
import 'package:json_annotation/json_annotation.dart';

class EventConverter implements JsonConverter<EventDto, Map<String, dynamic>> {
  const EventConverter();
  @override
  EventDto fromJson(Map<String, dynamic> event) {
    return EventDto.fromJson(event);
  }

  @override
  Map<String, dynamic> toJson(EventDto EventDto) {
    return EventDto.toJson();
  }
}