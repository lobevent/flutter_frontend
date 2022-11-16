import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/event/invitation.dart';
import 'package:flutter_frontend/domain/event/value_objects.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_series.freezed.dart';

@freezed
class EventSeries with _$EventSeries {
  // final UniqueId id;
  // final EventName name;
  // final EventDescription description;
  //const factory EventSeries({required this.name, required this.description, required this.id,}) = EventSeries;

  const factory EventSeries({
    required UniqueId id,
    required EventName name,
    required EventDescription description,
    required bool public,
    List<Event>? upcomingEvents,
    List<Event>? recentEvents,
    int? subscribersCount,
    int? eventCount,
    bool? subscribed,
    //List<Event>? events
  }) = EventSeriesNormal;
}
