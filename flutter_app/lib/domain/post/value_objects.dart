import 'package:dartz/dartz.dart';

import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/core/value_validators.dart';
import 'package:flutter_frontend/domain/core/constants.dart';

class PostContent extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  // TODO maxLength is never initialized?! -> export constants into a file in domain/core/constants.dart
  static int maxLength = Constants.maxLength;
  //check with maxLength (which u get from backend) if the PostContent is too long
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

  // TODO maxLength is never initialized?! -> export constants into a file in domain/core/constants.dart
  static int maxLength = Constants.maxLength;
  //check with maxLength (which u get from backend) if the CommentContent is too long
  factory CommentContent(String input) {
    assert(input != null);
    {
      return CommentContent._(validateLength(input, maxLength: maxLength));
    }
  }
  const CommentContent._(this.value);
}
