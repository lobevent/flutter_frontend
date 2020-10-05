

import 'package:freezed_annotation/freezed_annotation.dart';
part 'event.freezed.dart';

@freezed
abstract class Event with _$Event {
  const factory Event({
    @required int Id,
    @required String content,
}) = _Event;

}