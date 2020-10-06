import 'package:flutter_frontend/domain/event/value_objects.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
part 'event.freezed.dart';

@freezed
abstract class Event with _$Event {
  const factory Event({
    @required int id,
    @required EventName name,
    @required DateTime creationDate,
    @required EventDescription description,
    @required Profile owner,
  }) = _Event;
}
