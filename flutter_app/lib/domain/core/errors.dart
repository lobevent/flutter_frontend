import 'package:flutter_frontend/domain/core/failures.dart';

class CommunicationError extends Error {}

class NotAuthenticatedError extends CommunicationError {}
class NotAuthorizedError extends CommunicationError {}
class NotFoundError extends CommunicationError {}
class InternalServerError extends CommunicationError {}
class UnexpectedTypeError extends Error {}

class UnexpectedValueError extends Error {
  final ValueFailure valueFailure;

  UnexpectedValueError(this.valueFailure);

  @override
  String toString() {
    const String explanation =
        'Encountered a ValueFailure at an unrecoverable point. Terminating.';
    return Error.safeToString('$explanation Failure was: $valueFailure');
  }
}

class DtoTypeNotFoundInDeserializationFactoryMap extends Error {
  static const String explanation = """
    This error indicates that you tried to deserialize a 
    Type that isn't in the serialization factory map which 
    is used to determine the type of the serialized Data.""";

  @override
  String toString() {
    return Error.safeToString(explanation);
  }
}