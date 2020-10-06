import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/core/value_validators.dart';

class CommentContent extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  static int maxLength;
  //check with maxLength (which u get from backend) if the CommentContent is too long
  factory CommentContent(String input) {
    assert(input != null);
    {
      return CommentContent._(
          validateLength(input, maxLength).flatMap((a) => null));
    }
  }
  const CommentContent._(this.value);
}
