import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'failures.freezed.dart';

@freezed
class ValueFailure<T> with _$ValueFailure<T> {
  const factory ValueFailure.invalidEmail({
    required T failedValue,
  }) = InvalidEmail<T>;
  const factory ValueFailure.noEmailProvided() = NoEmailProvided;
  const factory ValueFailure.shortPassword({
    required T failedValue,
    required int minLength,
  }) = ShortPassword<T>;
  const factory ValueFailure.noBigCaseLetterPassword() = NoBigCaseLetterPassword;
  const factory ValueFailure.noSpecialLetterPassword() = NoSpecialLetterPassword;
  const factory ValueFailure.exceedingLength({
    required T failedValue,
    required int maxLength,
  }) = ExceedingLength<T>;
  const factory ValueFailure.lengthTooShort({
    required T failedValue,
    required int minLength,
  }) = LengthTooShort<T>;
  const factory ValueFailure.empty({
    required T failedValue,
  }) = Empty<T>;
  const factory ValueFailure.invalidDate({
    required T failedValue,
  }) = InvalidDate<T>;
  const factory ValueFailure.multiLine({
    required T failedValue,
  }) = MultiLine<T>;
  const factory ValueFailure.exceedingMinMax({
    required T failedValue,
}) = ExceedingMinMax <T>;
  const factory ValueFailure.outOfRange({
    required T failedValue,
}) = OutOfRange<T>;
}

@freezed
class NetWorkFailure<T> with _$NetWorkFailure<T> {
  const factory NetWorkFailure.unexpected() = Unexpected<T>;

  const factory NetWorkFailure.insufficientPermissions() = InsufficientPermissions<T>;

  const factory NetWorkFailure.unableToUpdate() = UnableToUpdate<T>;

  const factory NetWorkFailure.notAuthenticated() = NotAuthenticated<T>;

  const factory NetWorkFailure.notFound() = NotFound<T>;

  const factory NetWorkFailure.internalServer() = InternalServer<T>;
}
