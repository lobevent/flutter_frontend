import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'failures.freezed.dart';
/*
@freezed
abstract class ValueFailure<T> with _$ValueFailure<T> {
  const factory ValueFailure.auth(AuthValueFailure<T> f) = _Auth<T>;
  const factory ValueFailure.event(EventValueFailure<T> f) = _Event<T>;
}

 */

@freezed
abstract class ValueFailure<T> with _$ValueFailure<T> {
  const factory ValueFailure.invalidEmail({
    @required T failedValue,
  }) = InvalidEmail<T>;
  const factory ValueFailure.shortPassword({
    @required T failedValue,
  }) = ShortPassword<T>;
  const factory ValueFailure.exceedingLenght({
    @required T failedValue,
  }) = ShortPassword<T>;
  const factory ValueFailure.invalidDate({
    @required T failedValue,
  }) = ShortPassword<T>;
  const factory ValueFailure.multiline({
    @required T failedValue,
  }) = ShortPassword<T>;
}

/*
@freezed
abstract class EventValueFailure<T> with _$EventValueFailure<T> {
  const factory EventValueFailure.invalidEmail({
    @required T failedValue,
  }) = InvalidEmail<T>;
  const factory EventValueFailure.shortPassword({
    @required T failedValue,
  }) = ShortPassword<T>;
}

 */
