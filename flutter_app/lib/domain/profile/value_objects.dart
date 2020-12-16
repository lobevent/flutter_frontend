import 'package:dartz/dartz.dart';

import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/core/value_validators.dart';
import 'package:flutter_frontend/domain/core/constants.dart';

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

class Invitation extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory Invitation(String input) {
    {
      return Invitation._(doNothing(input).flatMap((a) => null)); // TODO we will clean this up after cleaning up the validators
    }
  }
  const Invitation._(this.value);
}

class UsrEvntStats extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory UsrEvntStats(String input) {
    {
      return UsrEvntStats._(doNothing(input).flatMap((a) => null)); // TODO we will clean this up after cleaning up the validators
    }
  }
  const UsrEvntStats._(this.value);
}

class Friendship extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory Friendship(String input) {
    {
      return Friendship._(doNothing(input).flatMap((a) => null)); // TODO we will clean this up after cleaning up the validators
    }
  }
  const Friendship._(this.value);
}

// TODO find a more expressive name
class Friendship2 extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory Friendship2(String input) {
    {
      return Friendship2._(doNothing(input).flatMap((a) => null)); // TODO we will clean this up after cleaning up the validators
    }
  }
  const Friendship2._(this.value);
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
