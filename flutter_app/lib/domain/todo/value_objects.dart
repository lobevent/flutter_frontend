import 'package:dartz/dartz.dart';


import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/core/value_validators.dart';
import 'package:flutter_frontend/domain/core/constants.dart';

class TodoListName extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory TodoListName(String input) {
    assert(input != null);
    {
      return TodoListName._(validateSingleLine(input));
    }
  }
  const TodoListName._(this.value);
}

class ItemContent extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  static int maxLength = Constants.maxTextLength;
  //check with maxLength, which is defined in the class constants.dart
  factory ItemContent(String input) {
    assert(input != null);
    {
      return ItemContent._(validateLength(input, maxLength: maxLength));
    }
  }
  const ItemContent._(this.value);
}