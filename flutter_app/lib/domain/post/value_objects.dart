import 'package:dartz/dartz.dart';

import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/core/value_validators.dart';
import 'package:flutter_frontend/data/constants.dart';

class PostContent extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  static int maxLength = Constants.maxTextLength;
  //check with maxLength, which is defined in the class constants.dart
  factory PostContent(String input) {
    assert(input != null);
    {
      return PostContent._(validateLength(input, maxLength: maxLength));
    }
  }
  const PostContent._(this.value);
}

class CommentContent extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  static int maxLength = Constants.maxTextLength;
  //check with maxLength, which is defined in the class constants.dart
  factory CommentContent(String input) {
    assert(input != null);
    {
      return CommentContent._(validateLength(input, maxLength: maxLength));
    }
  }
  const CommentContent._(this.value);
}
