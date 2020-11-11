import 'package:dartz/dartz.dart';

import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/core/value_validators.dart';
import 'package:flutter_frontend/domain/core/constants.dart';

class EventName extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory EventName(String input) {
    assert(input != null);
    {
      return EventName._(validateSingleLine(input));
    }
  }
  const EventName._(this.value);
}

class EventDescription extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory EventDescription(String input) {
    assert(input != null);
    {
      return EventDescription._(validateLength(input, maxLength: Constants.maxTextLength));
    }
  }
  const EventDescription._(this.value);
}
