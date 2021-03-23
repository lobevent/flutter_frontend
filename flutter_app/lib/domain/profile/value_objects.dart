import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/errors.dart';

import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/core/value_validators.dart';
import 'package:flutter_frontend/constants.dart';

class ProfileName extends ValueObject<String> {

  @override
  final Either<ValueFailure<String>, String> value;

  factory ProfileName(String input) {
    assert(input != null);
    {
      //check single line, and the length of the profilename
      return ProfileName._(validateSingleLine(input).andThen(validateLength(input, minLength: Constants.minProfilenameLength, maxLength: Constants.maxProfilenameLength)));
    }
  }
  const ProfileName._(this.value);
}





/*
class Post extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory Post(String input) {
    {
      return Post._(doNothing(input).flatMap((a) => null));
    }
  }
  const Post._(this.value);
}


class Comment extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory Comment(String input) {
    {
      return Comment._(doNothing(input).flatMap((a) => null));
    }
  }
  const Comment._(this.value);
}

 */
