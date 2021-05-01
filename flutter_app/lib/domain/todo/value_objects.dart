import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/errors.dart';

import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/core/value_validators.dart';
import 'package:flutter_frontend/data/constants.dart';



class TodoDescription extends ValueObject<String> {

  @override
  final Either<ValueFailure<String>, String> value;

  factory TodoDescription(String input) {
    assert(input != null);
    {
      //check single line, and the length of the profilename
      return TodoDescription._(validateSingleLine(input).andThen(validateLength(input, minLength: Constants.maxTextLength)));
    }
  }
  const TodoDescription._(this.value);
}

class TodoName extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;
  static int maxLength = Constants.maxNameLength;

  factory TodoName(String input) {

    assert(input != null);
    {
      return TodoName._(validateLength(input, maxLength: maxLength).flatMap(validateStringNotEmpty).flatMap(validateSingleLine));
    }
  }
  const TodoName._(this.value);
}

class ItemMaxProfiles extends ValueObject<int>{
  @override
  final Either<ValueFailure<int>, int> value;

  factory ItemMaxProfiles(int input) {

    assert(input != null);
    {
      return ItemMaxProfiles._(validateNumberRange<int>(input, max: Constants.maximumProfilesTodoLength, min: 0).flatMap(validateNonNegative));
    }
  }
  const ItemMaxProfiles._(this.value);
}


class ItemName extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;
  static int maxLength = Constants.maxNameLength;

  factory ItemName(String input) {

    assert(input != null);
    {
      return ItemName._(validateLength(input, maxLength: maxLength).flatMap(validateStringNotEmpty).flatMap(validateSingleLine));
    }
  }
  const ItemName._(this.value);
}

class ItemDescription extends ValueObject<String> {

  @override
  final Either<ValueFailure<String>, String> value;

  factory ItemDescription(String input) {
    assert(input != null);
    {
      //check single line, and the length of the profilename
      return ItemDescription._(validateSingleLine(input).andThen(validateLength(input, minLength: Constants.maxTextLength)));
    }
  }
  const ItemDescription._(this.value);
}