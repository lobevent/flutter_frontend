

import 'package:freezed_annotation/freezed_annotation.dart';
part 'event.freezed.dart';

@freezed
abstract class Event with _$Event {
  const factory Event({
    @required int id,
    @required String name,
    @required DateTime creationDate,
    @required String description,
    @required String owner,
}) = _Event;

}