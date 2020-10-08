import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/event/value_objects.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
part 'event.freezed.dart';

@freezed
abstract class Event implements _$Event {
  const Event._();

  const factory Event({
    @required int id,
    @required EventName name,
    @required DateTime date,
    @required EventDescription description,
    @required DateTime creationDate,
    @required Profile owner,
    @required bool public,
  }) = _Event;

  //check if the whole object is no failure
  // TODO I would go with Either<ValueFailure<dynamic>, Unit> since Option indicates that a value is ready to use or absent. But in this case there is always some kind of value even if it's just a value that indicates a failure
  Option<ValueFailure<dynamic>> get failureOption {
    return name.failureOrUnit.andThen(description.failureOrUnit)
      .fold(
        (f) => some(f),
        (_) => none(),
    );
  }
}
