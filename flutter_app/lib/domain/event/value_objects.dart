import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:meta/meta.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/core/value_validators.dart';

class EventName extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory EventName(String input) {
    assert(input != null);
    {
      return EventName._(validateSingleLine(input).flatMap((a) => null));
    }
  }
  const EventName._(this.value);
}
