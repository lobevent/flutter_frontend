import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/core/value_validators.dart';

class PostContent extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  static int maxLength;
  //check with maxLength (which u get from backend) if the PostContent is too long
  factory PostContent(String input) {
    assert(input != null);
    {
      return PostContent._(
          validateLength(input, maxLength).flatMap((a) => null));
    }
  }
  const PostContent._(this.value);
}
