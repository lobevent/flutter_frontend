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

class ItemName extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  static int maxLength = Constants.maxTextLength;
  factory ItemName(String input) {
    assert(input != null);
    {
      return ItemName._(validateLength(input, maxLength: maxLength));
    }
  }
  const ItemName._(this.value);
}
