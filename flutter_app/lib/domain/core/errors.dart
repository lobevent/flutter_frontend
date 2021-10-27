import 'package:flutter_frontend/domain/core/failures.dart';

abstract class CommunicationError extends Error {}

abstract class AuthError extends Error {}

abstract class BadPresentationState extends Error {}

class UnexpectedTypeError extends Error {}

class NotAuthenticatedError extends CommunicationError {}

class NotAuthorizedError extends CommunicationError {}

class NotFoundError extends CommunicationError {}

class InternalServerError extends CommunicationError {}

class PhoneVerificationNotStarted extends AuthError {
  @override
  String toString() {
    const String explanation =
        "This indicates error indicates that [_lastPhoneVerificationId] wasn't set yet. Most of the time this indicates that you didn't call [startPhoneNumberSignInFlow] before [signInWithReceivedSmsCode]";
    return Error.safeToString(explanation);
  }
}

class UnexpectedValueError extends Error {
  final ValueFailure valueFailure;

  UnexpectedValueError(this.valueFailure);

  @override
  String toString() {
    const String explanation =
        "Encountered a ValueFailure at an unrecoverable point. Terminating.";
    return Error.safeToString('$explanation Failure was: $valueFailure');
  }
}

class DtoTypeNotFoundInDeserializationFactoryMapError extends Error {
  static const String explanation =
      "DtoTypeNotFoundInDeserializationFactoryMapError: This error indicates that you tried to deserialize a type that isn't in the serialization factory map which is used to determine the type of the serialized Data.";

  @override
  String toString() {
    return Error.safeToString(explanation);
  }
}

class PhoneNumberPrefixShouldBeSetProperly extends BadPresentationState {}
