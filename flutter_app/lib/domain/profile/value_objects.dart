import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:meta/meta.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/core/value_validators.dart';

class ProfileName extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory ProfileName(String input) {
    assert(input != null);
    {
      return ProfileName._(validateSingleLine(input).flatMap((a) => null));
    }
  }
  const ProfileName._(this.value);
}

class Invitation extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory Invitation(String input) {
    {
      return Invitation._(doNothing(input).flatMap((a) => null));
    }
  }
  const Invitation._(this.value);
}

class UsrEvntStats extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory UsrEvntStats(String input) {
    {
      return UsrEvntStats._(doNothing(input).flatMap((a) => null));
    }
  }
  const UsrEvntStats._(this.value);
}

class Friendship extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory Friendship(String input) {
    {
      return Friendship._(doNothing(input).flatMap((a) => null));
    }
  }
  const Friendship._(this.value);
}

class Friendship2 extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory Friendship2(String input) {
    {
      return Friendship2._(doNothing(input).flatMap((a) => null));
    }
  }
  const Friendship2._(this.value);
}

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
