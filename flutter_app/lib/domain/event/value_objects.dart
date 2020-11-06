import 'package:dartz/dartz.dart';

import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/core/value_validators.dart';

class EventName extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory EventName(String input) {
    assert(input != null);
    {
      return EventName._(
        validateSingleLine(input)
      );
    }
  }
  const EventName._(this.value);
}

class EventDescription extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  // TODO maxLength is never initialized?! -> export constants into a file in domain/core/constants.dart
  static int maxLength = 500;
  factory EventDescription(String input) {
    assert(input != null);
    {
      return EventDescription._(
          validateLength(input, maxLength)
      );
    }
  }
  const EventDescription._(this.value);
}
