import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'failures.freezed.dart';

@freezed
class ValueFailure<T> with _$ValueFailure<T> {
  const factory ValueFailure.invalidEmail({
    @required T failedValue,
  }) = InvalidEmail<T>;
  const factory ValueFailure.noEmailProvided() = NoEmailProvided;
  const factory ValueFailure.shortPassword({
    @required T failedValue,
    @required int minLength,
  }) = ShortPassword<T>;
  const factory ValueFailure.noBigCaseLetterPassword() = NoBigCaseLetterPassword;
  const factory ValueFailure.noSpecialLetterPassword() = NoSpecialLetterPassword;
  const factory ValueFailure.exceedingLength({
    @required T failedValue,
    @required int maxLength,
  }) = ExceedingLength<T>;
  const factory ValueFailure.lengthTooShort({
    @required T failedValue,
    @required int minLength,
  }) = LengthTooShort<T>;
  const factory ValueFailure.empty({
    @required T failedValue,
  }) = Empty<T>;
  const factory ValueFailure.invalidDate({
    @required T failedValue,
  }) = InvalidDate<T>;
  const factory ValueFailure.multiLine({
    @required T failedValue,
  }) = MultiLine<T>;
}
