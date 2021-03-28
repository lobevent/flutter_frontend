import 'dart:html';

import 'package:dartz/dartz.dart';

import 'package:flutter_frontend/data/constants.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/core/value_validators.dart';


class PhoneNumberPrefix extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory PhoneNumberPrefix(String value) {
    return PhoneNumberPrefix._(
      // TODO add some verification;
      right(value)
    );
  }

  const PhoneNumberPrefix._(this.value);
}

class PhoneNumber extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory PhoneNumber(String value) {
    return PhoneNumber._(
      // TODO add some verification;
      right(value)
    );
  }

  const PhoneNumber._(this.value);
}



class EmailAddress extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory EmailAddress(String input) {
    return EmailAddress._(
      validateEmailAddress(input),
    );
  }

  factory EmailAddress.notProvided() {
    return EmailAddress._(left(const ValueFailure.noEmailProvided()));
  }

  const EmailAddress._(this.value);
}

class Password extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory Password(String input) {
    return Password._(
      validatePassword(input),
    );
  }

  const Password._(this.value);
}

class Username extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory Username(String username) {
    return Username._(
      validateLength(username, minLength: Constants.minUsernameLength)
    );
  }

  const Username._(this.value);
}
