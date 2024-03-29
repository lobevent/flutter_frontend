import 'dart:core';

import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/data/constants.dart';
import 'package:flutter_frontend/domain/core/failures.dart';

Either<ValueFailure<String>, String> validateEmailAddress(String input) {
  // Maybe not the most robust way of email validation but it's good enough
  const emailRegex =
      r"""^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+""";
  if (RegExp(emailRegex).hasMatch(input)) {
    return right(input);
  } else {
    return left(ValueFailure.invalidEmail(failedValue: input));
  }
}

Either<ValueFailure<String>, String> validatePassword(String input) {
  // You can also add some advanced password checks (uppercase/lowercase, at least 1 number, ...)
  // Added PW checking, at least 1 uppercase letter and TODO: at least 1 special character
  if (input.length < Constants.minPasswordLength) {
    return left(ValueFailure.shortPassword(
        failedValue: input, minLength: Constants.minPasswordLength));
  } else if (!RegExp("[A-Z]").hasMatch(input)) {
    return left(const ValueFailure.noBigCaseLetterPassword());
  } else if (!RegExp(r'[!-/:-@\[-`{-~]').hasMatch(input)) {
    // The four ranges of printable special characters in ASCII
    return left(const ValueFailure.noSpecialLetterPassword());
  } else {
    return right(input);
  }
}

Either<ValueFailure<double>, double> validateLongitude(double input) {
  if (input < 180 && input > -180) {
    return right(input);
  } else {
    return left(ValueFailure.empty(failedValue: input));
  }
}

Either<ValueFailure<double>, double> validateLatitude(double input) {
  if (input < 90 && input > -90) {
    return right(input);
  } else {
    return left(ValueFailure.empty(failedValue: input));
  }
}

Either<ValueFailure<String>, String> validateStringNotEmpty(String input) {
  if (input.isNotEmpty) {
    return right(input);
  } else {
    return left(ValueFailure.empty(failedValue: input));
  }
}

Either<ValueFailure<String>, String> validateLength(String input,
    {int minLength = 0, int? maxLength}) {
  if (input.length < minLength) {
    return left(
        ValueFailure.lengthTooShort(failedValue: input, minLength: minLength));
  }
  if (maxLength != null) {
    if (input.length > maxLength) {
      // check if the string is longer than max length
      return left(ValueFailure.exceedingLength(
          failedValue: input, maxLength: maxLength));
    }
  }

  return right(input);
}

Either<ValueFailure<String>, String> validateSingleLine(String input) {
  // check if for example the title of event is a one liner
  if (input.contains('\n')) {
    return left(ValueFailure.multiLine(failedValue: input));
  } else {
    return right(input);
  }
}

// TODO lets make this right tomorrow don't know what this should actually do (all the functions under this comment)

Either<ValueFailure<String>, String> validateDate(String input) {
  // check if the date is in valid format
  //TODO: idk if this is right, might be fucked up somehow
  DateTime validDate = DateTime.parse(input);
  if (validDate.isAfter(DateTime.now()) || isValidDate(validDate.toString())) {
    return right(input);
  } else {
    return left(ValueFailure.invalidDate(failedValue: input));
  }
}

Either<ValueFailure<int>, int> validateNumberRange(int input,
    {required int max, required int min}) {
  // check if the date is in valid format

  if (input <= max && input >= min) {
    return right(input);
  } else {
    return left(ValueFailure.outOfRange(failedValue: input));
  }
}

Either<ValueFailure<int>, int> validateNonNegative<T extends int>(int input,
    {T? max, T? min}) {
  // check if the date is in valid format
  if (isNonNegative(input)) {
    return right(input);
  } else {
    return left(ValueFailure.outOfRange(failedValue: input));
  }
}

bool isNonNegative(int number) {
  return !(number < 0);
}

bool isValidDate(String input) {
  final date = DateTime.parse(input);
  final originalString = toOriginalString(date);

  return input == originalString;
}

String toOriginalString(DateTime dateTime) {
  //dates with format yyyy.mm.dd please
  final y = dateTime.year.toString().padLeft(4, '0');
  final m = dateTime.month.toString().padLeft(2, '0');
  final d = dateTime.day.toString().padLeft(2, '0');
  return "$y$m$d";
}
